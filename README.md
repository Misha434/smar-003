![logo_with_margin](https://user-images.githubusercontent.com/61964919/130588238-21854f7a-0496-4b89-b59a-94c7b2d6ab93.png)

<h2 style="text-align: center"> スマホ比較アプリ</h2>

![service_summary_image_210906](https://user-images.githubusercontent.com/61964919/132218158-f9f9ce9d-3fb8-4888-972b-1718bbdb6fee.png)


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

スマホを買い換える時に、「バッテリーの持ちがいい」、「サクサク動くものにしたい」自分の望む視点でスマホを直感的に調べるサイトがあればいいなと思い作成しました。

<a id="anchor2"></a>

## 実装機能 一覧

|  機能  |  概要 <br>[ ]内は管理者のみ  | 単体/ 統合テスト  |
| ---- | ---- | :----: |
|  製品 項目別ランキング  | バッテリー容量, Antutu(SoC性能), 口コミ評価平均値 等の上位順にランキング表示 | - / ○ |
|  製品検索機能  | 製品一覧から製品名で検索 | - / ○ |
|  製品情報表示  | スペック詳細情報確認・いいね&口コミ数表示 <br> [ 製品登録・登録内容変更・削除 ]  |  ○ / ○ |
|  ブランド  | ブランドごとの製品一覧表示機能 <br> [ ブランド登録・登録内容変更・削除 ]  |  ○ / ○ |
|  CSV インポート機能 | [ CSV形式のファイルからブランドを一括登録 ]  | WIP |
|  ユーザー登録・ログイン機能  |  ユーザー登録・登録内容変更・ログイン・削除  | ○ / ○ |
|  口コミ投稿機能  | 製品ごとの口コミ投稿・投稿内容変更・削除  |  ○ / ○ |
|  口コミいいね機能  | 口コミにいいね(Ajax) |  ○ / ○ |
|  レスポンシブ対応  | - | - / ○<br>(ユーザー詳細) |

<a id="anchor3"></a>

## サービスのスクリーンショット画像 or デモGIF 動画

- レスポンシブ対応 (スマホ・タブレット・PC)
- 写真(Home画面)
![pages_home_210906](https://user-images.githubusercontent.com/61964919/132216450-133f326d-6193-4490-81d3-b773563d5c54.png)

### 製品 性能別ランキング

- Home -> ゲストログイン -> 製品一覧(レビュー評価でソート) -> 検索 -> 該当製品をレビュー評価でソート) -> 製品詳細

![sort_search_feature_210927](https://user-images.githubusercontent.com/61964919/134905784-1f98d194-61f5-4502-be7d-ee5573a73719.gif)

### 製品比較機能(Bookmark)

- 製品詳細(Bookmark登録) -> 別製品 Bookmark登録 -> 登録数バリデーション(2つまで) -> 登録を1つ解除 -> 製品登録

![bookmark_feature_210927](https://user-images.githubusercontent.com/61964919/134905650-1e108401-f83b-4d71-80a5-cca1a6b3bfe9.gif)
### 口コミ投稿 / いいね 機能
- 製品詳細ページ(画像込みで投稿) -> 投稿したレビューにいいね(Ajax)
![post_feature_210927](https://user-images.githubusercontent.com/61964919/134905672-c706a481-49db-4316-a0a2-3732bd2973c3.gif)

- ユーザープロフィール画面から投稿 (製品選択:Ajax)
![post_feature_user_210927](https://user-images.githubusercontent.com/61964919/134905680-aba5a609-af92-47aa-bb6d-c0af6e0f3022.gif)


<a id="anchor4"></a>

## 使用言語、環境、テクノロジー

### 意識したポイント

- バックエンドエンジニア志望なので、主に Rails や Ruby の扱い方をメインに学習・実践しました。
- 「リーダブルコード」を読んだ知見を生かし、「意図がわかりやすい変数の命名」を意識してコーディングしました。
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
| RSpec | System Spec (統合テスト) <br> Model Spec (単体テスト) |
| rubocop | 静的コード解析ツール |
| capistrano | デプロイツール |
| slim | テンプレートエンジン |
| Bullet | N + 1 問題検出ツール |

### インフラ：AWS
| 名称 |  | 備考 |
| --- | --- | --- |
| EC2 | App サーバー: Unicorn | - |
|  | Web サーバー: Nginx | - |
| RDS | RDBMS: MySQL | - |
| Route 53 | DNSサービス | - |
| S3 | ストレージ機能 | - |
| ELB (ALB) | 負荷分散機能 | - |
| Certificate Manager | SSL証明書 サービス | - |

### CI/CD：CircleCI
#### git push 等 実行時の挙動

| branch | アクション |  |
| --- | --- | --- |
| local -> remote-branch | push | 自動テスト (RSpec, Rubocop) |
| remote-branch -> remote master | merge | 自動テスト (RSpec, Rubocop) |
|  |  | 自動デプロイ(Capistrano) |

### 開発環境
- Docker 20.10.8
- Docker-compose 1.29.2
#### ex.
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

![ER_diagram_210927](https://user-images.githubusercontent.com/61964919/134922029-41632c1a-3e61-495c-897b-40981918761f.png)

<a id="anchor6"></a>

## システム構成図

![Infrastracture_Diagram_20210906](https://user-images.githubusercontent.com/61964919/132186932-927de9f5-a5f3-48fb-9fc7-d59ab98fad67.png)

<a id="anchor7"></a>

## 使い方

### インストール・開発環境下での実行方法

#### 共通
```
$ git clone https://github.com/Misha434/smar-003.git
$ cd smar-003
```

#### Docker 環境
```
$ docker-compose up -d
```

#### Docker 未使用の場合

```
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
- 異常系: 入力フォームは異常値・境界値分析を行っています

### デプロイ方法

- Capistranoで自動デプロイ

<a id="anchor8"></a>

## こだわり・苦戦したポイント

### 環境構築
- Asset Pipeline 未使用にした環境構築に苦労しました。「Precompile が遅い」という記事を見て対応したのですが、環境を統一せず環境構築が完了する前に同時に作業を進めたために、手戻りが多数発生しました。

### レビュー投稿機能

- 自己プロフィール画面から口コミ投稿する際に、ブランドから製品を絞り込む Ajax処理を実装しました。
- Ruby側の変数と、JavaScript側の変数の受渡しの方法がわからず長期間手詰まりを起こしました。jbuilderを利用することで解決しました。
### 製品口コミ 平均値表示機能

- レビュー数:1 の状態から、レビュー全削除をした際にレビュー平均値が nil になってしまうエラーが起きて手詰まりになったことがありました。その際に nilガード・デバックのことを学べました。

- 評価の星表示部分は自作しています。


<a id="anchor9"></a>

## 今後の計画

- [x] ~~SSL有効化(ALBの利用)~~
- [x] ~~DB: EC2 から RDS の利用に切り替え~~
- [x] ~~日本語対応~~
- [x] ~~レスポンシブ対応~~
- [ ] Docker化
- [ ] SPA化

### 追加予定機能
- [x] ~~機能別 製品一覧(ソート機能)~~
- [x] ~~製品比較機能~~
- [ ] 口コミ リプライ機能
- [ ] 通知機能
- [ ] 問い合わせ機能