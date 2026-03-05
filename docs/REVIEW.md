# CargoLink — 全体コードレビュー

実施日を想定した全体レビューです。良い点・要対応・推奨改善に分けて整理しています。

---

## 1. 良い点・しっかりしている点

- **認証・認可**
  - `UsersController#show` / `ProvidersController#show` に `authenticate_user!` / `authenticate_provider!` があり、未ログイン時は Devise がログイン画面へリダイレクトする。
  - サービスの編集・削除は `authorize_provider!` で自社のみに制限されている。

- **検索まわり**
  - `SearchParams` で Ransack キーを一元管理し、コントローラの `permit` とヘルパーの `search_refine_query_params` で一貫して利用している。
  - `Service` の `ransackable_attributes` / `ransackable_associations` が定義され、検索可能範囲が明確。

- **レイアウト**
  - ヘッダー・フッターは `application.html.erb` で共通レンダリングされており、各ビューで重複していない。

- **モデル**
  - Departure / Destination は DB マスタとして適切に scope（selectable, with_coordinates）を持ち、Service はバリデーションと Ransack 設定が揃っている。

- **ドキュメント**
  - README・ROADMAP・DESIGN_AND_IMPROVEMENTS・ROUTES など docs が整っており、方針と改善案が追いやすい。

---

## 2. 要対応（バグ・セキュリティ・一貫性）

### 2.1 検索の日付パラメータで例外が発生しうる 【対応済み】

**場所**: `ServicesController#search`

```ruby
@shipping_date = params[:shipping_date].presence&.then { |d| Date.parse(d.to_s) }
@arrival_date = params[:arrival_date].presence&.then { |d| Date.parse(d.to_s) }
```

**問題**: `Date.parse` は不正な文字列で `ArgumentError` を投げる。例: `arrival_date=invalid` で検索すると 500 になる。

**推奨**: パースに失敗したら nil にする。

```ruby
def safe_date(param)
  return nil if param.blank?
  Date.parse(param.to_s)
rescue ArgumentError
  nil
end
# search 内で @shipping_date = safe_date(params[:shipping_date]) など
```

---

### 2.2 プロバイダー show の URL と挙動の不整合 【対応済み】

**場所**: `config/routes.rb` の `resources :providers, only: :show` と `ProvidersController#show`

**問題**:
- URL は `/providers/:id` だが、`@provider = current_provider` のみで **params[:id] を参照していない**。
- どの id でアクセスしても「ログイン中のプロバイダー」が表示される。他社プロバイダー詳細としての公開ページにはなっていない。

**推奨**: 設計をどちらかに揃える。
- **マイページ専用にする**: すでに `mypage_provider_path` があるので、`/providers/:id` をやめて「プロバイダー詳細は mypage のみ」にするか、
- **公開プロフィールにする**: `@provider = Provider.find(params[:id])` で表示し、編集・登録は `current_provider == @provider` のときだけ可能にする。

現状のままでも「マイページとして /providers/1 に飛ばす」運用はできるが、URL と実装が一致していないため、ドキュメントかコメントで意図を書いておくとよい。

---

### 2.3 DESIGN_AND_IMPROVEMENTS の古い記述 【対応済み】

**場所**: `docs/DESIGN_AND_IMPROVEMENTS.md`

- 「出発地・到着地等を ActiveHash に寄せ」→ 現在は **Departure / Destination は ApplicationRecord（DB マスタ）** になっている。
- 「ヘッダー・フッターをレイアウトに寄せる」→ **すでに application レイアウトで共通化済み**。

**推奨**: 上記を現状に合わせて修正する。

---

## 3. 推奨改善（パフォーマンス・保守性・テスト）

### 3.1 N+1 の可能性（検索結果・一覧） 【対応済み】

**場所**: `ServicesController#index`, `#search` で `@p.result` をそのまま渡し、ビューで `service.departure.name`, `service.destination.name`, `service.provider.name` などを参照している。

**推奨**: 必要に応じて `includes` を付与する。

```ruby
# index
@services = @p.result.includes(:departure, :destination, :provider).order(created_at: :desc).limit(10)

# search
@services = @p.result.includes(:departure, :destination, :provider).limit(100)
```

ServiceType は ActiveHash のため includes に含めると `table_name` エラーになるので除外。departure / destination / provider のみ includes で N+1 防止。検索結果は limit(100) で上限を設けている。

---

### 3.2 検索結果の件数・ページネーション

**現状**: `search` では `@p.result` を全件取得。件数が増えるとメモリ・応答時間が増える。

**推奨**: 段階的に
- 表示件数に上限を設ける（例: `limit(100)`）、
- 必要になったら Kaminari や Pagy でページネーションを導入する。

---

### 3.3 テストの不足

**現状**:
- `ServicesControllerTest` で index / show / new / create / edit / update / destroy / search の基本はあるが、**search に q パラメータを付けた場合**や**create 成功時のリダイレクト・flash** などは未カバー。
- `UsersControllerTest` / `ProvidersControllerTest` の内容次第では、認証必須や他ユーザーアクセス時の挙動のテストがあると安心。

**推奨**:
- 検索: `get search_services_path, params: { q: { departure_id_eq: 2 } }` で 200 と `@services` の扱いを確認するテストを追加。
- 日付パラメータ: 不正日付で 500 にならないこと（上記 safe_date 対応後）をテストするとよい。

---

### 3.4 ログ・フィルタ

**現状**: `filter_parameter_logging` に `password` のみ。

**推奨**: Devise の `reset_password_token` や、本番でログに残したくないパラメータ（例: `email` の一部）があれば追加を検討する。Devise は多くのトークンをデフォルトでフィルタしているが、カスタムパラメータがあれば明示的に追加すると安全。

---

### 3.5 SearchParams のコメント 【対応済み】

**場所**: `config/initializers/search_params.rb`

**現状**: 「ステップ検索」への言及が残っている可能性がある（ステップ式検索削除後）。

**推奨**: 「トップの検索フォーム・検索結果の『条件を変える』で共通利用」など、現仕様に合わせたコメントにしておく。

---

## 4. その他・軽い指摘

- **README**: 主な機能に「ステップで検索」の記述が残っていなければそのままでよい。残っていれば削除または「検索はトップの一覧フォームのみ」に合わせる。
- **build_search_q**: 削除済み。検索条件は `permitted_search_q` と `search_refine_query_params` で扱う。
- **Rubocop**: `config` が Exclude に入っているため、`config/initializers/search_params.rb` は Rubocop の対象外。他ファイルは設定に従って問題なし。

---

## 5. まとめ

| 優先度 | 内容 | 状態 |
|--------|------|------|
| **高** | 検索の日付パラメータで `Date.parse` が例外を出さないようにする（safe_date 的な処理）。 | 対応済み |
| **高** | プロバイダー show の「URL は /providers/:id だが id を使っていない」を設計として決め、必要なら実装かドキュメントを揃える。 | 対応済み |
| **中** | DESIGN_AND_IMPROVEMENTS の「ActiveHash」「ヘッダー・フッター」の記述を現状に合わせて修正。 | 対応済み |
| **中** | 検索結果・一覧の N+1 防止（includes）。 | 対応済み |
| **低** | 検索結果の件数制限・ページネーション、テスト追加、filter_parameters の見直し、SearchParams コメント修正。 | SearchParams コメントは対応済み |

全体として、認証・認可・検索パラメータの一元化・レイアウト共通化は整っており、上記を順に対応していけば、保守性と堅牢性がさらに上がります。
