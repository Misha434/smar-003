# README

## Sma-R

### Home 画面

![smar-003_home_20210811](https://user-images.githubusercontent.com/61964919/128966548-411d3000-331d-4987-bbef-88d90745be51.png)

## プロジェクトの概要説明

スマホを買い換える時に、「バッテリーの持ちがいい」、「予算度外視でサクサク動くものにしたい」自分の望む視点でスマホを直感的に調べるサイトがあればいいなと思い作成しました。

## 実装機能 一覧

ビューはスマホ利用を主要として作成しました。今後タブレット以上の大きさにも対応させる予定です。

|  機能  |  概要 ( [ ]内は管理者のみ )  |
| ---- | ---- |
|  製品 項目別ランキング  | バッテリー容量, Antutu(SoC性能), 口コミ評価平均値 等の上位順にランキング表示 |
|  ユーザー登録・ログイン機能  |  ユーザー登録・登録内容変更・ログイン・削除  |
|  製品情報表示  | スペック詳細情報確認・いいね&口コミ数表示 <br> [ 製品登録・登録内容変更・削除 ]  |
|  製品検索機能  | 製品一覧から製品名で検索 |
|  ブランド  | ブランドごとの製品一覧表示機能 <br> [ ブランド登録・登録内容変更・削除 ]  |
|  口コミ投稿機能  | 製品ごとの口コミ投稿・投稿内容変更・内容変更・削除  |
|  口コミいいね機能  | 口コミにいいね(Ajax) |

## サービスのスクリーンショット画像 or GIFアニメ（デモ）

### 製品 項目別ランキング
![smar-003_home](https://user-images.githubusercontent.com/61964919/128722445-b39a837f-000d-4a80-80da-bf7c68d80780.gif)

### 製品検索機能
![smar-003_search_20210809](https://user-images.githubusercontent.com/61964919/128728274-d6860374-c576-4eb3-9244-899814a51016.gif)

### ブランド
![smar-003_brands_20210809](https://user-images.githubusercontent.com/61964919/128728328-55f06ab6-9298-43f7-aecd-24c0c3f1013d.gif)

### 口コミ投稿機能

![smar-003_post_review_1_20210809](https://user-images.githubusercontent.com/61964919/128728368-083fecdd-35ef-42a7-94d3-73aa1818d542.gif)

![smar-003_post_review_2_20210809](https://user-images.githubusercontent.com/61964919/128728394-191bfafc-30ba-4818-bad8-5854553f7abd.gif)

### 口コミ編集機能
![smar-003_edit_review_20210809](https://user-images.githubusercontent.com/61964919/128728439-eb7454af-abb9-4ae5-84ea-1557912fb4e9.gif)

### 口コミいいね機能
![smar-003_post_like_20210809](https://user-images.githubusercontent.com/61964919/128729132-21f19d24-dfd3-4822-8b1f-1a18a635066a.gif)

## 使用言語、環境、テクノロジー

### 趣旨

- バックエンドエンジニア志望なので、主に Rails や Ruby の扱い方をメインに学習・実践しました。
- アプリ内のパフォーマンスを意識して、N + 1 問題が発生しないよう考慮しながらコーディングしました。

### フロントエンド

- CSS フレームワーク: Bootstrap 5
- Icon: Font-Awesome
- JavaScript ライブラリ: jQuery

### バックエンド

- Ruby 2.6.3
- Rails 6.0.3 (Asset Pipline未使用)
- MySQL


### インフラ

- AWS EC2
  - アプリケーションサーバー: Unicorn
  - Webサーバー: Nginx
- AWS Route 53

当初は Heroku へのデプロイでのリリースを検討していましたが以下の理由で AWS 導入することにしました。

- 可能な限り無料枠を利用・低予算で開発したかった
- Heroku(無料枠) 
  - サーバー起動時間がかかる
  - MySQLのアドオンは容量1GB以上だと有料であること

### その他

| 名称 | 備考 |
| ---- | ---- |
| RSpec | System Spec (E2Eテスト) <br> Model Spec (モデルテスト) |

### 開発環境

- AWS Cloud9 (Ubuntu)
- Vagrant (CentOS 7)

## ER図

![ER_diagram_20210802](https://user-images.githubusercontent.com/61964919/127835343-8de7124c-3b0c-461f-9e35-e97d18052baa.png)

## システム構成図

![Infrastracture_Diagram_20210802](https://user-images.githubusercontent.com/61964919/127831467-0f09fabb-7116-48d4-97c2-672a809c6716.png)

## 使い方

### インストール方法

```

$ git clone https://github.com/Misha434/smar-003.git

$ yarn install --check-file

$ bundle install --without production

$ rails db:create

$ rails db:migrate

$ rails db:seed

### unique varidation に引っかかった場合
$ rails db:migrate:reset
$ rails db:migrate:seed

### 開発環境のサーバー起動
$ foreman start
```


### テスト方法

- 正常系
- 異常系: 入力フォームは異常値・境界値分析のチェックを行っています

### デプロイ方法

- Capistranoで自動デプロイを行っています。

## こだわり・苦戦したポイント

### 製品口コミ 平均値表示機能

- Home画面で上位3製品の平均値を表示する処理が、複雑で苦戦しました。

- 評価の星表示部分は自作しています。

### 投稿機能

自己プロフィール画面から口コミ投稿する際に、ブランドから製品を絞り込む Ajax処理を実装しました。

## 今後の計画

- 日本語対応

- レスポンシブ対応

- SPA化: 開発にあたって、フロント側でバリデーションを実装する際に JavaScript の重要性を感じる場面が多々ありました。 JavaScript の学習をかねてSPA化を行って行きたいです。

- Docker化