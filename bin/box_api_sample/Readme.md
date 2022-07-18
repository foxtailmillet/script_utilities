# Box APIのサンプル

## Boxのサインアップ
+ 個人様であれば10GBまでの無料枠があるのでそちらで試す。

## OAuth2.0のアクセストークン取得
+ 事前にやっておくこと
    + Box開発者コンソールで、OAuth 2.0認証方法を利用するカスタムアプリを作成する。
    + アプリケーションの 「構成」タブに移動して、client_idとclient_secretの値をコピーする。
    + アプリケーションの 「構成」 タブで、少なくとも1つのリダイレクトURIが構成されていることを確認する。

+ 流れ
    + 承認URLを作成する
    + ユーザーを承認URLにリダイレクトする
    + ユーザーが自分の代わりにアクションを実行するためのアクセス権限をアプリケーションに付与する (成功した場合は承認コードが提供される)
    + ユーザーを再度アプリケーションにリダイレクトする
    + 承認コードをアクセストークンと交換する

### Box開発者コンソールで、OAuth 2.0認証方法を利用するカスタムアプリを作成する。
+ Box開発者コンソールを表示：https://app.box.com/developers/console
+ 新規アプリを作成（Create New App）
    + カスタムアプリを作成する。（OAuth2.0を使いたいので）
        + https://ja.developer.box.com/guides/applications/select/
    + 認証方法はUser Authentication（OAuth2.0）を選択する
    + App Nameは「curl access」とする。（任意項目なので、他の名前でもよい）

### アプリケーションの 「構成」 タブに移動して、client_idとclient_secretの値をコピーする。
+ Client IDを取得する。（以降では値をCLIENT_IDと表記する）
+ Client Secretを取得する。（以降では値をCLIENT_SECRETと表記する）
+ Client IDとClient Secretはgitに保存してはいけない。（ローカルで閉じていない、クラウドの認証情報なので悪用できてしまう）
+ 保存されている場所は以下
    + Box開発者コンソール
        + My App
            + curl access
                + configuration
                    + OAuth 2.0 Credentials
                        + Client ID
                        + Client Secret

### アプリケーションの 「構成」 タブで、少なくとも1つのリダイレクトURIが構成されていることを確認する。
+ 以下を確認して取得する。
    + Box開発者コンソール
        + My App
            + curl access
                + configuration
                    + OAuth 2.0 Redirect URI
                        + Redirect URIs

### 承認URLを作成する
+ Client IDとRedirect URLを使ってURLを生成する。

```
baseUrl="https://account.box.com/api/oauth2/authorize";
clientId="CLIENT_ID";

authorizationUrl="${baseUrl}?response_type=code&client_id=${clientId}"

echo $authorizationUrl
```

### ユーザーを承認URLにリダイレクトする
+ ブラウザで$authorizationUrlにアクセスする

### ユーザーが自分の代わりにアクションを実行するためのアクセス権限をアプリケーションに付与する (成功した場合は承認コードが提供される)
+ ブラウザ上で許可する
    + Grant access to Box を押す前にデベロッパーツールを開いて待機する。（後述するcodeを拾うのに使う）
    + 「Grant access to Box」ボタンを押下。

### ユーザーを再度アプリケーションにリダイレクトする
+ 以下のようなURLにリダイレクトするので、codeの値を取得する。
+ ここからアクセストークンの交換は30秒で行うこと。（有効期限が30秒なので）
+ 画面遷移してしまうので、デベロッパーツールで通信履歴を追いかけないと取れない。


```
https://your.domain.com/path?code=1234567
```

### 承認コードをアクセストークンと交換する
+ Client ID, Client Secret, 先ほど取得したcodeを使ってアクセストークンを取得する。

```
authentication_url="https://api.box.com/oauth2/token";
client_id="CLIENT_ID"
client_secret="CLIENT_SECRET"
code="先ほど取得したcodeの値"

curl -i -X POST "$authentication_url" \
     -H "Content-Type: application/x-www-form-urlencoded" \
     -d "client_id=${client_id}" \
     -d "client_secret=${client_secret}" \
     -d "code=${code}" \
     -d "grant_type=authorization_code"
```

#### アクセストークンと更新トークン

```
{
  "access_token": "…",
  "expires_in": …,
  "token_type": "bearer",
  "refresh_token": "…",
  "issued_token_type": "…"
}
```

+ access_token
    - Boxアクセスの権限
+ refresh_token
    - access_tokenの更新（更新期限切れ時）

## アクセストークンを利用したBox操作

### フォルダ内容一覧取得
+ コマンド実行
```
ACCESS_TOKEN="事前に取得したアクセストークン"

FOLDER_ID="…"
curl -i -X GET "https://api.box.com/2.0/folders/${FOLDER_ID}/items" \
     -H "Authorization: Bearer ${ACCESS_TOKEN}"
```

+ レスポンスの例
```
{"total_count":2,
 "entries":
 [
     {"type":"file",
      "id":"98550…",
      "file_version":
      {
          "type":"file_version",
          "id":"106590…",
          "sha1":"…"
      },
      "sequence_id":"1",
      "etag":"1",
      "sha1":"…",
      "name":"HugaOrder.xlsx"
     },
     {"type":"file",
      "id":"98550…",
      "file_version":
      {
          "type":"file_version",
          "id":"1065899…",
          "sha1":"…"
      },
      "sequence_id":"0",
      "etag":"0",
      "sha1":"…",
      "name":"\u65e5\u672c\u8a9e.docx" //ファイル名は「日本語.docx」だったので2バイト文字は取扱注意
     }
 ],
 "offset":0,
 "limit":100,
 "order":[
     {"by":"type","direction":"ASC"},
     {"by":"name","direction":"ASC"}
 ]
}
```

### ファイル情報の取得
+ コマンド実行
```
ACCESS_TOKEN="事前に取得したアクセストークン"

FILE_ID="…"

curl -i -X GET "https://api.box.com/2.0/files/${FILE_ID}" \
     -H "Authorization: Bearer ${ACCESS_TOKEN}"
```

+ レスポンスの例
```
{"type":"file",
 "id":"…",
 "file_version":{
     "type":"file_version",
     "id":"…",
     "sha1":"…"
 },
 "sequence_id":"1",
 "etag":"1",
 "sha1":"…",
 "name":"HogeResult.xlsx",
 "description":"",
 "size":5862,
 "path_collection":{
     "total_count":2,
     "entries":[
         {"type":"folder","id":"0","sequence_id":null,"etag":null,"name":"All Files"},{"type":"folder","id":"…","sequence_id":"0","etag":"0","name":"out"}
     ]
 },
 "created_at":"2022-07-18T05:02:36-07:00",
 "modified_at":"2022-07-18T05:02:41-07:00",
 "trashed_at":null,
 "purged_at":null,
 "content_created_at":"2022-07-18T05:02:36-07:00","content_modified_at":"2022-07-18T05:02:41-07:00",
 "created_by":{
     "type":"user",
     "id":"…",
     "name":"…",
     "login":"…"
 },
 "modified_by":{
     "type":"user",
     "id":"…",
     "name":"…",
     "login":"…"
 },
 "owned_by":{
     "type":"user",
     "id":"…",
     "name":"…",
     "login":"…"
 },
 "shared_link":null,
 "parent":{
     "type":"folder",
     "id":"…",
     "sequence_id":"0",
     "etag":"0",
     "name":"out"
 },
 "item_status":"active"
}
```


### ファイルダウンロード
+ コマンド実行
```
ACCESS_TOKEN="事前に取得したアクセストークン"

FILE_ID="…"

curl -i -X GET "https://api.box.com/2.0/files/${FILE_ID}/content" \
     -H Content-Type: application/json \
     -H "Authorization: Bearer ${ACCESS_TOKEN}" \
     -L
```

+ レスポンスの例
```
# 権限不足でできていない。
# どこの設定なのかがわかっていない。
```

### フォルダダウンロード

# Box開発者コンソール
+ https://app.box.com/developers/console

# Box OAuth2.0
+ https://ja.developer.box.com/guides/authentication/oauth2/
+ https://ja.developer.box.com/guides/authentication/oauth2/without-sdk/

# BoxのAPIリファレンス
+ https://ja.developer.box.com/reference/get-users-me/