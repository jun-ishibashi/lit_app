# CargoLink（カゴリンク）

海外輸出の輸送手段（航空・海上）を**業者ごとに料金・リードタイムで比較**する Web アプリです。画面で表示するサービス名は `config/application.rb` の `config.x.app_display_name` で変更できます（[NAMING.md](docs/NAMING.md) 参照）。

---

## 目次

- [クイックスタート](#クイックスタート)
- [主な機能](#主な機能)
- [使用技術](#使用技術)
- [開発](#開発)
- [本番デプロイ](#本番デプロイ)
- [ドキュメント](#ドキュメント)

---

## クイックスタート

```bash
# 初回のみ
bundle config set --local path 'vendor/bundle'
bundle install
bundle exec rails db:create db:migrate
bundle exec rails db:seed

# 起動
bundle exec rails s
```

ブラウザで **http://localhost:3000** を開く。

| 種別     | メールアドレス        | パスワード |
|----------|------------------------|------------|
| ユーザー | `user@example.com`     | `password` |
| プロバイダー | `provider@example.com` | `password` |

---

## 主な機能

| 対象 | 内容 |
|------|------|
| **検索・比較**（ログイン不要） | 出発地・到着地・サービスタイプ・プロバイダーで検索。料金順・リードタイム順でソート。希望出荷日・到着日を指定すると「最短到着日」「必要出荷日」を表示。 |
| **サービス登録**（プロバイダーのみ） | 運送業者が自社のルート・料金・リードタイム・オプションを登録・編集・削除。自社サービス以外の編集・削除は不可。 |
| **マイページ** | ユーザー・プロバイダーそれぞれの登録情報と（プロバイダーは）提供サービス一覧を表示。 |

制作背景: 日本の生産者（特に中小企業）が海外輸出する際、**複数業者の相見積もりを一括で比較できる「輸送の乗換案内」** を目指して制作しました。

---

## 使用技術

| 種別 | 技術 |
|------|------|
| 言語・FW | Ruby 3.4, Rails 7.2 |
| フロント | HTML, CSS (SCSS), Bootstrap 5, Importmap, Turbo |
| DB | 開発・テスト: SQLite 3 / 本番: PostgreSQL |
| 認証 | Devise（User / Provider を別々に管理） |
| 検索 | Ransack |
| 本番 | Render |

---

## 開発

### 起動

```bash
bundle exec rails s
```

### ホットリロード

開発時は `hotwire-livereload` により、`app/views`・`app/assets/stylesheets`・`app/javascript` などを保存するとブラウザが自動更新されます。

- 無効: `bin/rails livereload:disable`
- 有効: `bin/rails livereload:enable`

### シード・DB

```bash
bundle exec rails db:seed    # 既存データはスキップして追加
bundle exec rails db:reset   # DB 初期化のうえ migrate + seed
```

### 主要テーブル

| テーブル | 役割 |
|----------|------|
| **users** | 依頼側。user_type_id, product_id は ActiveHash。 |
| **providers** | 運送業者。service_type_id は ActiveHash。has_many :services。 |
| **services** | ルート・料金・リードタイム・オプション。belongs_to :provider。departure/destination/service_type/option は ActiveHash。 |

詳細は `db/schema.rb` を参照。

---

## 本番デプロイ

Render でのデプロイ手順です。

1. [Render](https://render.com) でアカウント作成し、GitHub リポジトリを連携する。
2. **New > Blueprint** でこのリポジトリを選択する。
3. `render.yaml` が読み込まれる。環境変数 **RAILS_MASTER_KEY** に `config/master.key` の内容を設定する。
4. **Apply** でデプロイする。`.onrender.com` の URL で公開される。

`DATABASE_URL` は Blueprint の Postgres 連携で自動設定されます。

---

## ドキュメント

| ドキュメント | 内容 |
|--------------|------|
| [ROADMAP.md](docs/ROADMAP.md) | **ビジネスロードマップ**（Phase 0〜3：基盤整備→信頼性→料金・つながり→評価・履歴）。 |
| [MONETIZATION.md](docs/MONETIZATION.md) | マネタイズの可能性・収益モデル候補・実現条件。 |
| [BUSINESS_AND_ROADMAP.md](docs/BUSINESS_AND_ROADMAP.md) | ビジネスロジック・主な流れ・今後の機能・データまわりの検討事項。 |
| [DESIGN_AND_IMPROVEMENTS.md](docs/DESIGN_AND_IMPROVEMENTS.md) | 全体構成と設計上の改善点（認証・認可・レイアウト・テストなど）。 |
| [PROVIDER_UX_AND_TERMINOLOGY.md](docs/PROVIDER_UX_AND_TERMINOLOGY.md) | 「プロバイダ」表現の適切性・ナビ構成・業者向け管理画面の要否。 |

---

## デモ（スクリーンショット）

| 画面 | 説明 |
|------|------|
| トップ | 検索フォームと直近登録されたサービス一覧 |
| 検索結果 | 出発地・到着地・料金・リードタイム・日付計算を表示 |
| サービス詳細 | ルート・料金・オプション・説明。プロバイダーは自社サービスの編集・削除が可能 |

<img width="720" alt="トップ" src="https://user-images.githubusercontent.com/81630353/143537360-551e4472-f5da-49be-9077-d3108ed78ceb.png">
<img width="720" alt="検索" src="https://user-images.githubusercontent.com/81630353/143537317-8e3b7a4b-04d9-4c59-bfb8-3ec247b14849.png">
<img width="720" alt="検索結果" src="https://user-images.githubusercontent.com/81630353/143537665-52b5761a-6bf2-41e4-be6b-41303b39c90a.png">
<img width="720" alt="詳細" src="https://user-images.githubusercontent.com/81630353/143537703-ae8755f5-f372-4443-8438-967ce106cdd1.png">

---

## 課題・今後の機能

- **課題**: 現状は運賃のみの比較のため、サーチャージ・通関費等を含めると実際の輸送コストと乖離する。
- **今後**: レビュー・評価、相談・問い合わせ、数量・重量に応じた料金計算 等。

詳細は [docs/BUSINESS_AND_ROADMAP.md](docs/BUSINESS_AND_ROADMAP.md) を参照。
