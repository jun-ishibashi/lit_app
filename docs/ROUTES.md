# ルート・パス一覧

主要なURLとpathヘルパー。Devise の認証系は省略。

| 用途 | URL | pathヘルパー |
|------|-----|--------------|
| トップ（HOME） | `/` | `root_path` |
| 検索（フォーム送信先） | `/services/search` | `search_services_path` |
| 見積もり依頼一覧・新規・詳細 | `/quote_requests` など | `quote_requests_path`, `new_quote_request_path(service_id: id)` |
| サービス一覧 | `/services` | `services_path` |
| サービス詳細 | `/services/:id` | `service_path(id)` |
| サービス新規 | `/services/new` | `new_service_path` |
| サービス編集 | `/services/:id/edit` | `edit_service_path(id)` |
| ユーザー詳細（マイページ） | `/users/:id` | `user_path(id)` |
| 業者向け入口 | `/for-providers` | `for_providers_path` |
| 業者マイページ | `/mypage/provider` | `mypage_provider_path` |
| 他業者プロフィール | `/providers/:id` | `provider_path(id)` |

## ディレクトリ構成（コントローラ・ビュー）

- **サービス**: `ServicesController` → `app/views/services/`（index, show, new, edit, search）
- **ユーザー**: `UsersController`（show）＋ Devise → `app/views/users/`
- **業者**: `ProvidersController`（entry, show）＋ Devise → `app/views/providers/`
- **共通**: `app/views/shared/`（_header, _footer, _flash）、`app/views/layouts/`

業者向け入口は `ProvidersController#entry`、ビューは `app/views/providers/entry.html.erb`。
