# EnjuNii
[<img src="https://travis-ci.com/next-l/enju_nii.svg?branch=1.3" alt="Build
Status" />](https://travis-ci.com/next-l/enju_nii) [<img
src="https://coveralls.io/repos/next-l/enju_nii/badge.svg?branch=1.3&service=g
ithub" alt="Coverage Status"
/>](https://coveralls.io/github/next-l/enju_nii?branch=1.3) [<img
src="https://hakiri.io/github/next-l/enju_nii/1.3.svg" alt="security"
/>](https://hakiri.io/github/next-l/enju_nii/1.3)

CiNii Booksから書誌をインポートするための Enju プラグインです。

## インストール方法 / How to Install

お使いのenju_leafのGemfile に以下の行を追加してください。

    gem 'enju_nii', github: "next-l/enju_nii", branch: '1.3'

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
