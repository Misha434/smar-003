![logo_with_margin](https://user-images.githubusercontent.com/61964919/130588238-21854f7a-0496-4b89-b59a-94c7b2d6ab93.png)

<h2 style="text-align: center"> スマホ比較アプリ</p>


## 目次
- [プロジェクトの概要説明](#anchor1)
- [実装機能 一覧](#anchor2)
- [サービス GIFアニメ（デモ）](#anchor3)
- [使用言語、環境、テクノロジー](#anchor4)
- [ER図](#anchor5)
- [システム構成図](#anchor6)
- [使い方](#anchor7)
- [こだわり・苦戦したポイント](#anchor8)
- [今後の予定](#anchor9)


<a id="anchor1"></a>

## プロジェクトの概要説明

スマホを買い換える時に、「バッテリーの持ちがいい」、「予算度外視でサクサク動くものにしたい」自分の望む視点でスマホを直感的に調べるサイトがあればいいなと思い作成しました。

<a id="anchor2"></a>

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

<a id="anchor3"></a>

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

<a id="anchor4"></a>

## 使用言語、環境、テクノロジー

### 意識したポイント

- バックエンドエンジニア志望なので、主に Rails や Ruby の扱い方をメインに学習・実践しました。
- アプリ内のパフォーマンスを意識して、N + 1 問題が発生しないよう考慮しながらコーディングしました。

### フロントエンド

- Bootstrap 5
- Font-Awesome
- jQuery
- JavaScript

### バックエンド

- Ruby 2.6.3
- Rails 6.0.3 (Asset Pipline未使用)
- MySQL

#### 使用したgem
| 名称 | 備考 |
| --- | --- |
| pagy | ページネーション機能 |
| ransack | 検索機能 |
| ActiveStorage | ファイル(画像)アップロードツール |
| RSpec | System Spec (E2Eテスト) <br> Model Spec (モデルテスト) |
| rubocop | 静的コード解析ツール |
| capistrano | デプロイツール |
| slim | テンプレートエンジン |

### インフラ

- AWS

| 名称 |  | 備考 |
| --- | --- | --- |
| EC2 | App サーバー: Unicorn | - |
|  | Web サーバー: Nginx | - |
| RDS | RDBMS: MySQL | - |
| Route 53 | DNSサービス | - |
| S3 | ストレージ機能 | - |

### 開発環境

- AWS Cloud9 (Ubuntu)
- Vagrant (CentOS 7)

### その他
#### インフラ使用技術 選定での背景
当初は Heroku へのデプロイでのリリースを検討していましたが以下の理由で AWS 導入することにしました。

- 可能な限り無料枠を利用・低予算で開発したかった
- Heroku(無料枠) 
  - サーバー起動時間がかかる
  - MySQLのアドオンは容量1GB以上だと有料であること

<a id="anchor5"></a>

## ER図

![ER_diagram_210824](https://user-images.githubusercontent.com/61964919/130623494-373cff7e-2501-414d-8a51-4ce8016e2f6b.png)

<a id="anchor6"></a>

## システム構成図

![Infrastracture_Diagram_20210824](https://user-images.githubusercontent.com/61964919/130624628-da443786-522e-48fd-bd4c-9564276f098d.png)


<a id="anchor7"></a>

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

<a id="anchor8"></a>

## こだわり・苦戦したポイント

### 製品口コミ 平均値表示機能

- Home画面で上位3製品の平均値を表示する処理が、複雑で苦戦しました。

- 評価の星表示部分は自作しています。

### 投稿機能

自己プロフィール画面から口コミ投稿する際に、ブランドから製品を絞り込む Ajax処理を実装しました。

<a id="anchor9"></a>

## 今後の計画

- [ ] SSL有効化(ALBの利用)
- [x] ~~DB: EC2 から RDS の利用に切り替え~~
- [ ] 日本語対応
- [ ] レスポンシブ対応
- [ ] Docker化
- [ ] SPA化

### 追加予定機能
- [x] ~~機能別 製品一覧(ソート機能)~~
- [ ] 口コミ リプライ機能
- [ ] 通知機能
- [ ] 問い合わせ機能