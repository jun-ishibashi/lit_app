# CargoLink — 全体構成と設計上の改善点

設計・構成に着目した改善提案です。実装の優先度ごとに整理しています。

---

## 1. 現状の構成サマリ

| 層 | 内容 |
|----|------|
| **ルーティング** | トップ＝サービス一覧、`/services/search`（検索）、`resources :services`、`/for-providers`（業者入口）、`/mypage/provider`（業者マイページ）、`/providers/:id`（プロバイダー公開プロフィール）、`users` は `show` のみ。Devise で認証ルートを自動追加。 |
| **コントローラ** | ApplicationController（Devise パラメータ許可）、ServicesController（Ransack・認可）、UsersController / ProvidersController（show・mypage）。 |
| **モデル** | User / Provider（Devise）、Service（Ransack）。マスタは Departure / Destination が DB（ApplicationRecord）、ServiceType / Option / UserType / Product が ActiveHash。 |
| **ビュー** | ヘッダー・フッターは `application.html.erb` で共通レンダリング。各ビューでは個別に呼ばない。 |
| **認証・認可** | Devise で User / Provider を分離。サービスは new/create/edit/update/destroy をプロバイダー必須＋編集・削除は自社のみ。 |

---

## 2. 設計として良い点

- **役割の分離**: ユーザー（依頼側）とプロバイダー（業者）がルート・コントローラ・ビューで一貫して分かれている。
- **認可の明確さ**: サービスの「作成＝プロバイダーのみ」「編集・削除＝そのサービスの提供者のみ」とルールがはっきりしている。
- **マスタの扱い**: 出発地・到着地は DB マスタ（Departure / Destination）。ServiceType・Option 等は ActiveHash で運用。
- **検索の整理**: Ransack の `ransackable_attributes` / `ransackable_associations` をモデルで定義している。
- **ドキュメント**: README と BUSINESS_AND_ROADMAP でビジネス・技術・今後の方針が書かれている。

---

## 3. 改善点（優先度別）

### 3.1 【高】すぐ直すとよいもの

#### A. マイページ・プロバイダー詳細の認証不足 【対応済み】

**対応内容**

- `UsersController#show`: `before_action :authenticate_user!` を追加済み。未ログイン時は Devise がログイン画面へリダイレクト。
- プロバイダーは `/mypage/provider`（`providers#mypage`）に `authenticate_provider!` を適用。`/providers/:id`（`show`）は公開プロフィールのため認証不要。

---

#### B. プロバイダー show の URL と id の不整合 【対応済み】

**対応内容（案2で実装）**

- `/providers/:id` は `ProvidersController#show` で `@provider = Provider.find(params[:id])` により公開プロフィールとして表示（認証不要）。
- 自分のマイページは `/mypage/provider`（`providers#mypage`）で、認証必須。`@provider = current_provider` で同一ビューを表示し、メールアドレス・アカウント編集・サービス登録は自社ログイン時のみ表示。

---

#### C. ヘッダー・フッターをレイアウトに寄せる 【対応済み】

**対応内容**

- `application.html.erb` で `render "shared/header"` → `yield` → `render "shared/footer"` の順で共通レンダリング済み。各ビューでは個別に呼んでいない。

---

### 3.2 【中】設計・保守性の向上

#### D. ServicesController#show の @services

**現状**

- `ServicesController#show` では `@services` は設定していない（`@service` のみ）。index と search で `@p.result` を `@services` として利用している。詳細画面の実装は問題なし。

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
- 設定が抜けていると、全ページが同じ「CargoLink — 海外輸送比較」になり、タブ・ブックマークで区別しづらい。

**推奨**

- 主要なページ（トップ、検索結果、サービス詳細、マイページ、ログイン・登録など）で `content_for :title, "ページ名 | #{app_name}"` のように設定する。
- 運用ルールとして「新規ページには必ず title を書く」とすると、SEO と UX の両方に効く。

---

### 3.3 【低】将来の拡張・運用を見据えた検討

#### G. User と Service の関係 【一部対応済み】

**現状**: 見積もり依頼（QuoteRequest：user_id, service_id, message, status）を実装済み。User はサービス詳細から「見積もりを依頼」で依頼でき、業者は「見積もり依頼一覧」で自社サービスへの依頼を確認できる。

**今後**: 返信機能・ステータス更新（replied / closed）の UI、成約履歴の記録などは今後の拡張として検討。

---

#### H. マスタ（出発地・到着地など）の管理

**現状**: 出発地・到着地は DB マスタ（Departure / Destination）に移行済み。ServiceType・Option・UserType・Product は ActiveHash でコードに固定。

**今後**: ServiceType 等の増減や名前修正が頻繁になるなら、DB マスタ化や管理画面を検討する。

---

#### I. エラーページ・404/500

**現状**: Rails デフォルトのエラーページのままの可能性が高い。

**今後**: 本番では 404 / 500 用のビューを用意し、レイアウト（ヘッダー・フッターの有無）や文言をアプリのトーンに合わせると、信頼感と運用のしやすさが増す。

---

## 4. 実装の優先順位（提案）

1. ~~**認証の追加**（3.1-A）~~ … 対応済み。
2. ~~**プロバイダー show の設計確定**（3.1-B）~~ … 対応済み（公開プロフィール + mypage）。
3. ~~**ヘッダー・フッターのレイアウト化**（3.1-C）~~ … 対応済み。
4. ~~**show の @services 整理**（3.2-D）~~ … show では @services 未使用のため対応不要。
5. **テストの充実**（3.2-E）… 認可・未ログインリダイレクト・検索まわりを優先。
6. **content_for :title**（3.2-F）… 主要ページでタイトルを設定。

残りの 5・6 と、中〜低優先度の項目を進めると、保守性・拡張性がさらに高まります。

---

## 5. 参照

- ビジネスと今後の機能: [BUSINESS_AND_ROADMAP.md](./BUSINESS_AND_ROADMAP.md)
- プロバイダ表現・ナビ・管理画面: [PROVIDER_UX_AND_TERMINOLOGY.md](./PROVIDER_UX_AND_TERMINOLOGY.md)
- 開発・デプロイ: [README.md](../README.md)
