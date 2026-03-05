# 現状機能の分析と改善提案

アプリの現在の機能を整理し、改善点を優先度・カテゴリ別に提案したドキュメントです。

---

## 1. 現状の機能一覧

### 1.1 ユーザー（依頼側）

| 機能 | 概要 | 備考 |
|------|------|------|
| サービス検索・一覧 | トップで最近10件表示。条件（出発地・到着地・日付・サービスタイプ・作業範囲・インコタームズ・コンテナサイズ・業者・並び順）で検索し、最大100件表示 | Ransack、SearchParams で一元化 |
| サービス詳細 | 1件のサービス内容（料金・リードタイム・作業範囲・インコタームズ・コンテナサイズ・料金に含まれるもの・説明・業者）を表示 | 料金は format_price_for_service で単位付き表示 |
| 見積もり依頼 | ログイン必須。サービス詳細から「見積もりを依頼」→ 荷物情報（重量・容積・個数）・希望インコタームズ・メッセージを入力して送信 | QuoteRequest に保存。業者へは一覧で表示 |
| 見積もり依頼一覧・詳細 | 自分が送った依頼の一覧と詳細（ステータス・依頼者情報は業者側のみ表示） | ステータスは pending / replied / closed。更新 UI は未実装 |
| マイページ | ユーザー show（要ログイン） | 現状はプロフィール表示のみ |
| お問い合わせ | 非ログイン可。名前・メール・件名・本文で送信。DB に保存 | 管理画面・通知は未実装 |

### 1.2 業者（プロバイダー）

| 機能 | 概要 | 備考 |
|------|------|------|
| サービス登録・編集・削除 | ログイン必須。出発地・到着地・サービスタイプ・作業範囲・インコタームズ・コンテナサイズ・料金・料金種別・料金単位・料金に含まれるもの・リードタイム・オプション・説明を登録・編集。削除は自社サービスのみ | 他社サービス編集は「権限がありません」で拒否 |
| 公開プロフィール | `/providers/:id` で誰でも閲覧可能。登録サービス一覧を表示 | 認証不要 |
| マイページ | `/mypage/provider` で自社のサービス一覧・見積もり依頼一覧・アカウント編集・サービス登録への導線 | 認証必須。show と同じビューで条件分岐 |
| 見積もり依頼一覧・詳細 | 自社サービスへの依頼一覧。依頼者名・メールを詳細で表示 | 返信・ステータス更新の UI は未実装 |

### 1.3 共通・マスタ

| 項目 | 内容 |
|------|------|
| 認証 | Devise：User / Provider を別モデルで分離。サインアップ時に name, introduction, user_type_id, product_id（User）, service_type_id（Provider）を許可 |
| 輸送方式 | ServiceType：航空・船舶(LCL)・船舶(FCL)・鉄道・陸送・複合（ActiveHash） |
| 作業範囲 | ServiceScope：通関込み・通関なし・ドア to ドア等（ActiveHash） |
| インコタームズ | Incoterm：EXW, FOB, CIF, DAP, DDP 等（ActiveHash） |
| コンテナサイズ | ContainerSize：20ft, 40ft（ActiveHash） |
| 出発地・到着地 | Departure / Destination（DB マスタ、position で並び） |

---

## 2. 改善提案（優先度・カテゴリ別）

### 2.1 【高】UX・品質

| 改善点 | 現状の課題 | 提案 |
|--------|------------|------|
| **サービス登録・編集フォームのバリデーションエラー表示** | `services/new`・`services/edit` に `@service.errors` の表示がない。保存失敗時、ユーザーは理由が分からない | フォーム上部にエラー概要（例：`shared/error_messages` のような partial）を追加し、各フィールド横に `field_with_errors` またはインラインエラーを表示する |
| **見積もり依頼フォームのエラー表示** | `quote_requests/new` でバリデーション失敗時にエラーが表示されない（現状 QuoteRequest の presence バリデーションは少ないが、今後増やす場合に備える） | 同様にエラー表示 partial を追加する |
| **Service の price / lead_time バリデーション** | DB では NOT NULL だが、モデルに `validates :price, :lead_time, presence: true` および `numericality` がない。不正値で DB エラーになりうる | `validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }`、`validates :lead_time, presence: true, numericality: { only_integer: true, greater_than: 0 }` を追加する |
| **404 / 500 エラーページ** | 存在しない id（例：`/services/99999`、`/providers/99999`）で標準のエラーページになる。本番ではアプリのトーンに合ったページがあるとよい | `rescue_from ActiveRecord::RecordNotFound` で 404 を捕捉し、`public/404.html` や `errors/not_found` を表示。500 も同様にエラーページを用意する |

### 2.2 【高】セキュリティ・堅牢性

| 改善点 | 現状の課題 | 提案 |
|--------|------------|------|
| **見積もり依頼の service_id の信頼** | `QuoteRequestsController#create` では `quote_request_params[:service_id]` で Service を取得し、`merge(service: @service)` している。params の service_id を改ざんされても、取得した `@service` で上書きされるため実害は小さいが、存在しない id の場合は 404 になるだけ | 現状で問題は小さい。必要なら「公開されているサービスか」の scope を用意し、それに含まれる場合のみ依頼可能にする |
| **お問い合わせ・見積もり依頼のスパム対策** | レート制限がない。大量送信されると DB や運用負荷が増える | 同一 IP または同一ユーザーからの投稿頻度制限（Rack::Attack や throttle の導入）を検討する |
| **本番の秘密情報のログ出力** | `filter_parameter_logging` で password 等は設定済み。必要に応じて `:reset_password_token` 等の見直し | 既存の initializer を確認し、Devise トークンが漏れないようにする（対応済みの場合は記載のみ） |

### 2.3 【中】機能・運用

| 改善点 | 現状の課題 | 提案 |
|--------|------------|------|
| **見積もり依頼のステータス更新** | 業者が「返信済み」「完了」に更新する UI がない。DB には status があるが運用で更新しづらい | 見積もり依頼詳細（業者向け）にステータス変更のセレクト＋更新ボタンを追加する。必要なら「返信内容」用のテキストフィールドや別モデルを検討する |
| **検索結果のデフォルト並び順** | `search` で `@p.result` に明示的な `order` を付けていない。params に `sorts` が無いときの並びが不定 | デフォルトで `order(created_at: :desc)` や `order(price: :asc)` を適用し、`sorts` があるときだけ上書きする |
| **ページネーション** | 検索結果は `limit(100)` まで。件数が増えると一覧が長くなる | Kaminari や Pagy を導入し、検索結果をページ分割する |
| **業者ログイン後のホーム** | 業者がログイン後もトップはサービス一覧のまま。マイページに直接誘導した方が分かりやすい場合がある | 業者ログイン後の root を `mypage_provider_path` にリダイレクトする、またはトップに「マイページへ」を目立たせる |
| **お問い合わせの管理・通知** | 問い合わせは DB に保存されるが、管理画面やメール通知がない | 簡易的な `/admin/inquiries`（認証必須）で一覧表示する、またはメール通知（Action Mailer）を追加する |

### 2.4 【中】データ・マスタ

| 改善点 | 現状の課題 | 提案 |
|--------|------------|------|
| **出発地・到着地の typo** | 既存ドキュメントで Barselona→Barcelona、Penan→Penang 等の修正が挙がっている | マスタデータをシードまたはマイグレーションで修正する |
| **QuoteRequest のバリデーション** | 必須項目がほぼない（status の inclusion のみ）。意図的に任意にしている場合はよいが、最低限「メッセージまたは荷物情報のいずれか」などを検討できる |  product の要件に合わせて、必要なら presence や length を追加する |

### 2.5 【低】保守性・拡張

| 改善点 | 現状の課題 | 提案 |
|--------|------------|------|
| **Service の ransackable と attribute の整合** | 新規カラム追加時に `ransackable_attributes` の更新を忘れがち | コメントまたはテストで「検索に使う属性は ransackable_attributes に含める」と明文化する |
| **テストの網羅** | コントローラテストは主要フローをカバー。モデルのバリデーション・scope のテストが少ない | Service / QuoteRequest の validation や scope のテストを追加する |
| **CI** | テスト・Lint の自動実行がない | GitHub Actions 等で `bin/rails test` と Rubocop を実行する |

---

## 3. 現状でよくできている点

- **認証・認可の分離**: ユーザーと業者が別モデルで、サービス編集・削除は自社のみ。プロバイダー show は公開、mypage は認証必須で一貫している。
- **検索の一元化**: SearchParams と Ransack でキーを揃え、safe_date で日付の例外を防いでいる。
- **N+1 対策**: 一覧・検索で `includes(:departure, :destination, :provider)` 等がかかっている。
- **料金・単位の明示**: 日本円（JPY）、料金種別（総額 / 円/kg 等）が画面とヘルパーで統一されている。
- **ドキュメント**: REMAINING_ITEMS・TRANSPORT_MODES_AND_QUOTE_REQUIREMENTS・REVIEW 等で方針と残タスクが追いやすい。

---

## 4. 優先して進めるとよい順（提案）

1. **サービス・見積依頼フォームのエラー表示** … 入力ミス時のフィードバックがすぐ得られる。
2. **Service の price / lead_time のバリデーション** … 不正データを防ぎ、エラー表示と合わせて UX が良くなる。
3. **404 / 500 エラーページ** … 本番公開前にあると安心。
4. **見積もり依頼のステータス更新 UI** … 業者が「対応した」と分かるようにでき、運用がしやすくなる。
5. **検索結果のデフォルト並び順** … 初回検索時の見やすさが安定する。

その他（ページネーション、業者ログイン後のホーム、お問い合わせ管理、スパム対策、CI）はリソースとフェーズに応じて REMAINING_ITEMS や ROADMAP と合わせて取り込むとよいです。
