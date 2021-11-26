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

<img width="1440" alt="スクリーンショット 2021-11-26 15 22 43" src="https://user-images.githubusercontent.com/81630353/143537360-551e4472-f5da-49be-9077-d3108ed78ceb.png">

- 検索画面

<img width="1440" alt="スクリーンショット 2021-11-26 15 31 34" src="https://user-images.githubusercontent.com/81630353/143537317-8e3b7a4b-04d9-4c59-bfb8-3ec247b14849.png">

<img width="1440" alt="スクリーンショット 2021-11-26 15 31 57" src="https://user-images.githubusercontent.com/81630353/143537209-148be1b4-f9c3-4fb8-9643-0175a5fcba88.png">

出発地と到着地を入力することでサービスの検索、価格に安い順やリードタイムが短い順で検索結果の並び替えが可能。
また、具体的な出荷時期や納品時期が決まっている場合は指定することで、到着予定日や出荷に必要な日が表示される。

- 検索結果画面

<img width="1440" alt="スクリーンショット 2021-11-26 15 35 17" src="https://user-images.githubusercontent.com/81630353/143537665-52b5761a-6bf2-41e4-be6b-41303b39c90a.png">

- サービス詳細画面

<img width="1440" alt="スクリーンショット 2021-11-26 15 36 25" src="https://user-images.githubusercontent.com/81630353/143537703-ae8755f5-f372-4443-8438-967ce106cdd1.png">

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
