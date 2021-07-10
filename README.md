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