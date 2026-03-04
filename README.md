# LIT APP

海外輸出の輸送手段（航空・海上）を**業者ごとに料金・リードタイムで比較**する Web アプリです。

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

→ http://localhost:3000 を開く。  
**ログイン例**: ユーザー `user@example.com` / プロバイダー `provider@example.com`（パスワードはいずれも `password`）

---

## 主な機能

- **検索・比較**（ログイン不要）  
  出発地・到着地・サービスタイプ・プロバイダーで検索。料金の安い順・リードタイムの短い順でソート。希望出荷日・到着日を指定すると「最短到着日」「必要出荷日」を表示。
- **サービス登録**（プロバイダーのみ）  
  運送業者が自社のルート・料金・リードタイム・オプションを登録・編集・削除。自社サービス以外の編集・削除は不可。

---

## 制作背景

日本の生産者（特に中小企業）が海外にモノを輸出する際、どの輸送手段・業者を選べばよいか判断しづらい現状を踏まえ、**複数業者の相見積もりを一括で比較できる「輸送の乗換案内」** を目指して制作しました。

---

## デモ

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

## 使用技術

| 種別 | 技術 |
|------|------|
| 言語・FW | Ruby 3.4, Rails 7.2 |
| フロント | HTML, CSS, Bootstrap 5, Importmap, Turbo |
| DB | 開発・テスト: SQLite 3 / 本番: PostgreSQL |
| 認証 | Devise（User / Provider 別々） |
| 検索 | Ransack |
| ホスティング | Render（本番） |

---

## 開発

### 起動（2回目以降）

```bash
bundle exec rails s
```

開発中は **ホットリロード** が有効です。`app/views`・`app/assets/stylesheets`・`app/javascript` などを保存すると、ブラウザが自動で更新されます（`hotwire-livereload` 使用）。無効にしたいときは `bin/rails livereload:disable`、再度有効化は `bin/rails livereload:enable`。

### シードの再投入

```bash
bundle exec rails db:seed   # ユーザー・プロバイダーが既にいればスキップ
bundle exec rails db:reset  # DB を初期化して migrate + seed
```

### ドキュメント

- [ビジネスロジックと今後の検討事項](docs/BUSINESS_AND_ROADMAP.md) … 役割・流れ・今後の機能・DB まわり

---

## 本番デプロイ（Render）

1. [Render](https://render.com) でアカウント作成し、GitHub リポジトリを連携。
2. **New > Blueprint** でこのリポジトリを選択。
3. `render.yaml` が読み込まれるので、**RAILS_MASTER_KEY** に `config/master.key` の内容を設定。
4. **Apply** でデプロイ。`.onrender.com` の URL で公開されます。

環境変数は `render.yaml` で設定済み（`DATABASE_URL` は Blueprint の Postgres 連携で自動設定）。

---

## 課題・今後の機能

- **課題**: 現状は運賃のみの比較のため、サーチャージ・通関費等を含めると実際の輸送コストと乖離する。
- **今後**: レビュー・評価、相談・問い合わせ、数量・重量に応じた料金計算 等。

詳細は [docs/BUSINESS_AND_ROADMAP.md](docs/BUSINESS_AND_ROADMAP.md) を参照。

---

## データベース（主要テーブル）

| テーブル | 役割 |
|----------|------|
| **users** | 輸送を依頼する側（法人/個人）。user_type_id, product_id は ActiveHash。 |
| **providers** | 運送業者。service_type_id は ActiveHash。has_many :services。 |
| **services** | ルート（departure_id, destination_id）・料金・リードタイム・option_id。belongs_to :provider。departure/destination/service_type/option は ActiveHash。 |

スキーマの詳細は `db/schema.rb` を参照。
