# EnjuNii
[![CircleCI](https://circleci.com/gh/next-l/enju_nii/tree/2.x.svg?style=svg)](https://circleci.com/gh/next-l/enju_nii/tree/2.x)
[![Coverage Status](https://coveralls.io/repos/github/next-l/enju_nii/badge.svg?branch=2.x)](https://coveralls.io/github/next-l/enju_nii?branch=2.x)

CiNii Booksから書誌をインポートするための Enju プラグインです。

## インストール方法 / How to Install

お使いのenju_leafのGemfile に以下の行を追加してください。

    gem 'enju_nii', github: "next-l/enju_nii", branch: '2.x'

gemをインストールします。

    $ bundle update

インストールが完了したら、以下のコマンドでセットアップを行います。

    $ rake enju_nii_engine:install:migrations
    $ rake enju_nii:setup

データベースを更新します。

    $ rake db:migrate

その後、Enjuを再起動してください。

http://(Enjuのホスト)/cinii_books/ にアクセスすると、 CiNii Books検索によるインポート機能が利用できます。

## ライセンス / License

This project rocks and uses MIT-LICENSE.

## 製作者・貢献者 (Authors and contributors)
* [TANABE, Kosuke](https://github.com/nabeta) ([@nabeta](https://twitter.com/nabeta))
* [Project Next-L](https://www.next-l.jp) ([@ProjectNextL](https://twitter.com/ProjectNextL))

