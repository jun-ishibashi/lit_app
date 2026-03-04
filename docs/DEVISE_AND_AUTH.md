# Devise と認証まわり

認証・リダイレクト・パラメータ許可の整理メモ。

---

## 現状

- **モデル**: `User` と `Provider` の2つで Devise を使用。
- **ルート**: `devise_for :providers`, `devise_for :users` でサインイン・サインアウト・登録等のルートが自動追加。
- **リダイレクト**: カスタム未設定のため、サインイン後は **root_path**、サインアウト後も Devise デフォルト（通常は root）へ。
- **フラッシュ**: Devise 標準の `notice` / `alert` を利用。

---

## カスタムしたい場合

### サインイン・サインアウト後の遷移先

`ApplicationController` でオーバーライドする。

```ruby
def after_sign_in_path_for(resource)
  return mypage_provider_path if resource.is_a?(Provider)
  super
end

def after_sign_out_path_for(resource_or_scope)
  return for_providers_path if resource_or_scope == :provider
  super
end
```

### 許可パラメータ（サインアップ）

`ApplicationController#configure_permitted_parameters` で実施済み。

- 許可キー: `:name, :introduction, :user_type_id, :product_id, :service_type_id`（Provider は `:service_type_id` など）

追加・変更する場合は同じメソッド内の `devise_parameter_sanitizer.permit(:sign_up, keys: [...])` を編集する。

---

## 認可（サービス編集・削除）

- サービスの **new / create / edit / update / destroy** は `ServicesController` で `authenticate_provider!` を利用。
- 編集・削除は `authorize_provider!` で「自社のサービスか」をチェックし、違う場合は root へリダイレクト＋`flash[:alert]`。

詳細は `DESIGN_AND_IMPROVEMENTS.md` の「マイページ・プロバイダー詳細の認証不足」も参照。
