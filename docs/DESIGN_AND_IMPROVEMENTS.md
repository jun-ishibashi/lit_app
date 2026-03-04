# LIT APP — 全体構成と設計上の改善点

設計・構成に着目した改善提案です。実装の優先度ごとに整理しています。

---

## 1. 現状の構成サマリ

| 層 | 内容 |
|----|------|
| **ルーティング** | トップ＝サービス一覧、`/services/search`（検索・`search_services_path`）、`resources :services`、`/for-providers`（業者入口）、`/mypage/provider`（業者マイページ）、`users` / `providers` は `show` のみ。Devise で認証ルートを自動追加。 |
| **コントローラ** | ApplicationController（Devise パラメータ許可）、ServicesController（Ransack・認可）、UsersController / ProvidersController（show のみ）。 |
| **モデル** | User / Provider（Devise）、Service（Ransack）。マスタは ActiveHash（Departure, Destination, ServiceType, Option, UserType, Product）。 |
| **ビュー** | 各ページで `render "shared/header"` / `render "shared/footer"` を個別に呼び出し。レイアウトは flash と yield のみ。 |
| **認証・認可** | Devise で User / Provider を分離。サービスは new/create/edit/update/destroy をプロバイダー必須＋編集・削除は自社のみ。 |

---

## 2. 設計として良い点

- **役割の分離**: ユーザー（依頼側）とプロバイダー（業者）がルート・コントローラ・ビューで一貫して分かれている。
- **認可の明確さ**: サービスの「作成＝プロバイダーのみ」「編集・削除＝そのサービスの提供者のみ」とルールがはっきりしている。
- **マスタの扱い**: 出発地・到着地等を ActiveHash に寄せ、マイグレーションを抑えている。
- **検索の整理**: Ransack の `ransackable_attributes` / `ransackable_associations` をモデルで定義している。
- **ドキュメント**: README と BUSINESS_AND_ROADMAP でビジネス・技術・今後の方針が書かれている。

---

## 3. 改善点（優先度別）

### 3.1 【高】すぐ直すとよいもの

#### A. マイページ・プロバイダー詳細の認証不足

**問題**

- `UsersController#show`: `@user = current_user` のみで、`authenticate_user!` がない。
  - 未ログインで `/users/123` にアクセスすると `current_user` が nil になり、ビューでエラーまたは不整合になる。
- `ProvidersController#show`: 同様に `authenticate_provider!` がなく、`@provider = current_provider` のみ。
  - 未ログインで `/providers/456` にアクセスすると同様のリスクがある。

**推奨**

- マイページは「自分の情報だけ見る」前提なら、**必ず認証してから show を実行**する。
- `UsersController` に `before_action :authenticate_user!`, only: [:show]`
- `ProvidersController` に `before_action :authenticate_provider!`, only: [:show]`
- 未ログイン時は Devise がログイン画面へリダイレクトする。

---

#### B. プロバイダー show の URL と id の不整合

**問題**

- ルートは `resources :providers, only: :show` のため、URL は `/providers/:id` になる。
- しかし `ProvidersController#show` では **params[:id] を使わず** `@provider = current_provider` だけを代入している。
  - どの id でアクセスしても「いまログインしているプロバイダー」が表示される。
  - 「他社のプロバイダー詳細を公開で見る」設計なら、id を使うべき。

**推奨（どちらかで設計をはっきりさせる）**

- **案1: マイページ専用にする**
  - プロバイダーは「自分のマイページ」だけを持つなら、`/providers/:id` ではなく `/provider/dashboard` や `/mypage/provider` のような専用パスにし、`params[:id]` を使わない現状と一致させる。
- **案2: プロバイダー詳細を公開する**
  - `@provider = Provider.find(params[:id])` で表示し、編集・サービス登録は「current_provider == @provider のときだけ」とする。他社は「見るだけ」にし、自社だけ編集可能とする。

---

#### C. ヘッダー・フッターをレイアウトに寄せる

**問題**

- ヘッダー・フッターは全ページ共通なのに、**各ビューで** `render "shared/header"` と `render "shared/footer"` を書いている。
- 新しいページを追加するたびに書き忘れの可能性があり、レイアウト変更時に全ビューを触る必要がある。

**推奨**

- `application.html.erb` で共通レイアウトを定義する。
  - 例: `render "shared/header"` → `yield` → `render "shared/footer"` の順で固定。
- メールレイアウトやエラーページなど、ヘッダー・フッターを出したくない場合は、別レイアウトや `content_for` で「ヘッダーなし」を指定する方法を検討する。

---

### 3.2 【中】設計・保守性の向上

#### D. ServicesController#show の @services

**問題**

- `show` で `@services = @p.result`（Ransack の結果）を代入しているが、サービス詳細ビューでは **@service しか使っていない**。
- 不要なクエリ・代入が残っている可能性がある。

**推奨**

- 詳細画面で `@services` を使っていなければ、`show` から `@services = @p.result` を削除する。
- 将来的に「関連する他サービス」を出したい場合は、その用途に合わせて別の変数名・クエリにすると意図が明確になる。

---

#### E. テストで守る範囲

**問題**

- Minitest のコントローラテストはスケルトンのまま（`assert true` のみや空）のファイルがある。
- 認可（他社サービスの編集・削除を拒否）、未ログイン時のリダイレクト、検索パラメータの扱いなど、**仕様の要所**がテストで守られていない。

**推奨**

- 少なくとも以下はテストで担保することを推奨する。
  - プロバイダー未ログインで `new/create/edit/update/destroy` にアクセス → ログイン画面へリダイレクト。
  - 他社のサービスに対して `edit/update/destroy` → 「権限がありません」で root へリダイレクト。
  - ユーザー／プロバイダーの show に未ログインでアクセス → 認証必須にした後はログイン画面へリダイレクト。
- 検索（Ransack）のキーや日付パラメータの有無で落ちないことも、テストがあると安心。

---

#### F. ページタイトルの統一

**問題**

- レイアウトで `content_for?(:title)` を使っているが、各ビューで `content_for :title` を設定しているかは未確認。
- 設定が抜けていると、全ページが同じ「LIT APP — 海外輸送比較」になり、タブ・ブックマークで区別しづらい。

**推奨**

- 主要なページ（トップ、検索結果、サービス詳細、マイページ、ログイン・登録など）で `content_for :title, "ページ名 | LIT APP"` のように設定する。
- 運用ルールとして「新規ページには必ず title を書く」とすると、SEO と UX の両方に効く。

---

### 3.3 【低】将来の拡張・運用を見据えた検討

#### G. User と Service の関係

**現状**: User はサービスを「検索して見る」だけ。モデル上の関連はない。

**今後**: 相談・見積依頼・成約履歴などを残すなら、User と Service（または見積・注文などの中間モデル）の関連を設計する必要がある。BUSINESS_AND_ROADMAP の「見積・注文」の検討と一致させる。

---

#### H. マスタ（出発地・到着地など）の管理

**現状**: ActiveHash でコードに固定。変更のたびにデプロイが必要。

**今後**: 出発地・到着地の増減や名前修正が頻繁になるなら、管理画面や DB マスタ化を検討する。 typo（Barselona → Barcelona 等）の修正もここに含めるとよい。

---

#### I. エラーページ・404/500

**現状**: Rails デフォルトのエラーページのままの可能性が高い。

**今後**: 本番では 404 / 500 用のビューを用意し、レイアウト（ヘッダー・フッターの有無）や文言をアプリのトーンに合わせると、信頼感と運用のしやすさが増す。

---

## 4. 実装の優先順位（提案）

1. **認証の追加**（3.1-A）… UsersController / ProvidersController の show に `authenticate_user!` / `authenticate_provider!`。
2. **プロバイダー show の設計確定**（3.1-B）… 「マイページ専用」か「公開プロバイダー詳細」か決め、ルートと `params[:id]` の使い方を一致させる。
3. **ヘッダー・フッターのレイアウト化**（3.1-C）… `application.html.erb` に header/footer を移し、各ビューから該当 render を削除。
4. **show の @services 整理**（3.2-D）… 不要なら削除。
5. **テストの充実**（3.2-E）… 認可・未ログインリダイレクト・検索まわりを優先。
6. **content_for :title**（3.2-F）… 主要ページでタイトルを設定。

この順で進めると、セキュリティと一貫性が先に整い、その後に保守性・拡張性を高められます。

---

## 5. 参照

- ビジネスと今後の機能: [BUSINESS_AND_ROADMAP.md](./BUSINESS_AND_ROADMAP.md)
- プロバイダ表現・ナビ・管理画面: [PROVIDER_UX_AND_TERMINOLOGY.md](./PROVIDER_UX_AND_TERMINOLOGY.md)
- 開発・デプロイ: [README.md](../README.md)
