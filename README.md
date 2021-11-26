## アプリ名

LIT APP

## 概要

海外にモノを輸出する際の手段として、航空輸送や海上輸送等の中から価格やリードタイムなどの条件によって業者ごとに比較できる。

## 本番環境

https://lit-app-34712.herokuapp.com

ログイン情報（テスト用）

ユーザー
- Eメール：test@test.com
- パスワード：111aaa

プロバイダー
- Eメール：test@test.com
- パスワード：111aaa

## 制作背景（意図）
日本の生産者が海外にモノを輸出する際に、特に中小企業などでは貿易の専門知識をもたないことが多く、いずれの輸送手段（航空輸送・海上輸送）や業者を選択すべきか分からないのが実情でした。
顧客は複数の運送業者に相見積もりを取る必要があるため、提供する業者側にも時間と労力がかかり非常に非効率であると感じました。さらに輸送に対する顧客のニーズは低コストとリードタイム短縮に偏りがちで、
コスト競争になりやすいことから輸送手段や業者ごとに簡単に比較ができる「輸送の乗換案内」のようなWEBサービスを制作することを決めました。

## DEMO

- トップページ

https://gyazo.com/c726a767414d7b9172d4786b945f4402

- 検索画面

https://gyazo.com/d8bf7f2c295ea9a2baee19bff0900727

https://gyazo.com/c6053242fa4ec7d973d976ca0da05919

出発地と到着地を入力することでサービスの検索、価格に安い順やリードタイムが短い順で検索結果の並び替えが可能。
また、具体的な出荷時期や納品時期が決まっている場合は指定することで、到着予定日や出荷に必要な日が表示される。

- 検索結果画面

https://gyazo.com/10aede5223d2e615844b192473b75b58

- サービス詳細画面

https://gyazo.com/e7affa5145c03c79698d6eb60084c8ff

## 工夫したポイント
- ユーザーのニーズに応じて簡単にサービスが比較できるよう、検索結果をリードタイムが短い順と料金が安い順に並び替えることができるようソート機能を実装した点。
- ユーザーとプロバイダーの目線に立って、常に利便性を考えながら機能を実装した点。サービスの検索や登録のしやすさ等。
- メインである検索機能の使い勝手を考え、周辺の機能と見た目をなるべくシンプルにするようにした点。

## 使用技術(開発環境)
### バックエンド
Ruby, Ruby on rails
### フロントエンド
HTML, CSS
### データベース
MySQL
### ソース管理
Github, GithubDesktop
### エディタ
VScode


## 課題や今後実装したい機能

### 課題
- 現状運賃のみの比較になっており、サーチャージ等の変動費用や通関費用などの輸出に関わる費用は導入されていないため、実際かかる全体の輸送費用とは乖離が生じてしまう点。

### 今後実装したい機能
- 実際にサービスを利用したユーザーのレビュー・評価機能
- ユーザーが業者にサービスについて相談ができるコンタクト機能（メールやGoogleフォーム)
- 製品の数量・重量等の情報入力により、輸送可否の判断や料金を計算する機能

## usersテーブル

|Column              |Type     |Options                    |
|--------------------|---------|---------------------------|
| name               | string  | null: false               |
| email              | string  | null: false, unique: true |
| encrypted_password | string  | null: false               |
| user_type_id       | integer | null: false               |
| product_id         | integer | null: false               |
| introduction       | text    |                           |

### Association
has_many :services
has_many :reviews

## providersテーブル

|Column              |Type     |Options                    |
|--------------------|---------|---------------------------|
| name               | string  | null: false               |
| email              | string  | null: false, unique: true |
| encrypted_password | string  | null: false               |
| service_type_id    | integer | null: false               |
| introduction       | text    |                           |

### Association
has_many :services

## servicesテーブル

|Column            |Type        |Options                         |
|------------------|------------|--------------------------------|
| departure_id     | integer    | null: false                    |
| destination_id   | integer    | null: false                    |
| service_type_id  | integer    | null: false                    |
| price            | integer    | null: false                    |
| lead_time        | integer    | null: false                    |
| option_id        | integer    | null: false                    |
| description      | text       |                                |
| provider         | references | null: false, foreign_key: true |

### Association
belongs_to :user
belongs_to :provider
has_many :reviews

## reviewsテーブル

|Column       |Type        |Options                         |
|-------------|------------|--------------------------------|
| text        | text       | null: false                    |
| point       | integer    | null: false                    |
| user        | integer    | null: false, foreign_key: true |
| provider    | references | null: false, foreign_key: true |

### Association
belongs_to :user
belongs_to :service
