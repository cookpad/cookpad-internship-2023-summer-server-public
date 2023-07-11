# 補足資料

## GraphQL

- [GraphQL 公式](https://graphql.org/)
- [graphql-ruby](https://graphql-ruby.org/)
- [Relay](https://relay.dev/)

## Ruby

- [Ruby 公式](https://www.ruby-lang.org/ja/)
- [Ruby API Document](https://docs.ruby-lang.org/ja/3.1/doc/index.html)

## Rails

- [Rails 公式](https://rubyonrails.org/)
- [RailsGuide](https://railsguides.jp/)
- [Rails API Document](https://api.rubyonrails.org/)

## 基本課題の仕様確認

基本課題で、自分の実装が仕様を満たしているかどうかを確認するのが困難な場合は、テストケースを用意していますので、よかったら利用してみてください。

`bff/exercise_progression.yaml` に各課題についてのフラグを用意しているので、実装した課題に関するフラグを true に変更してください。
`rspec` を実行してテストがパスすれば、仕様通りに実装できていることが確認できます。

※ 仕様を網羅できているわけではないのであくまで参考としてご利用ください
※ minirecipe, minihashtag のサービスをローカルで起動している必要があります

例： B-2 と B-4 の課題を実装した場合

```diff
  handson: true
  handson_want: true
  b_1: false
- b_2: false
+ b_2: true
  b_3: false
- b_4: false
+ b_4: true
  b_5: false
  b_6: false
```

```sh
foreman start # minirecipe, minihashtag のサービスをローカルで起動している必要があります
```

```sh
cd bff
bundle exec rspec
```

## VS Code
VS Code を利用する場合は、2023-summer-internship.code-workspace を利用すれば、Multi-root workspace として開くことができます。

```
$ code 2023-summer-internship.code-workspace
```
