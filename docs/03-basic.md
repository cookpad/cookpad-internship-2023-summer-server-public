# 基本課題

BFF に以下の機能を実装してください。  
また、BFF の機能追加の際に、各マイクロサービスにも必要な実装があれば追加してください。

- B-1: 材料に `quantity` フィールド、ユーザーに `imageUrl` フィールドを追加する
- B-2: レシピの画像サイズを引数で変更できるようにする
- B-3: レシピIDを指定して情報を取得できる機能を追加
- B-4: レシピの手順を取得する機能を追加
- B-5: レシピのハッシュタグを取得する機能を追加
- B-6: レシピの投稿機能を追加
- B-7: レシピ一覧のページネーション機能を追加

これらの機能のうちどれを追加するかや、どの順番で追加していくかはおまかせします。  
やりたい・できそうなものに取り組んでみてください。  
もし追加できたら別の機能にも取り組んでみてください！  

現在の実装に上記の機能をすべて追加すると、以下のような Schema の差分になると思います。  
取り組む課題によって微妙に異なるので都度課題の説明文を読みながら進めてください。  

```diff
diff --git a/schema.graphql b/schema.graphql
index e8a95d2..928f059 100644
--- a/schema.graphql
+++ b/schema.graphql
@@ -27,7 +27,9 @@ type Hashtag {
 }

 type Ingredient {
   id: ID!
   name: String!
+  quantity: String
 }

 type Mutation {
@@ -44,8 +46,55 @@ type Mutation {
   testField: String!
 }

+type PageInfo {
+  endCursor: String
+  hasNextPage: Boolean!
+  hasPreviousPage: Boolean!
+  startCursor: String
+}
+
 type Query {
-  recipes: [Recipe!]!
+  recipe(id: String!, imageSize: String): Recipe!
+  recipes(
+    after: String
+    before: String
+    first: Int
+    imageSize: String
+    last: Int
+  ): RecipeConnection!

   """
   An example field added by the generator
@@ -55,13 +104,56 @@ type Query {

 type Recipe {
   description: String!
+  hashtags: [Hashtag!]!
   id: ID!
   imageUrl: String
   ingredients: [Ingredient!]!
+  steps: [Step!]!
   title: String!
   user: User!
 }

+type RecipeConnection {
+  edges: [RecipeEdge]
+  nodes: [Recipe]
+  pageInfo: PageInfo!
+}
+
+type RecipeEdge {
+  cursor: String!
+  node: Recipe
+}
+
+type Step {
+  id: ID!
+  imageUrl: String
+  memo: String!
+}
+
 type User {
   id: ID!
+  imageUrl: String
   name: String!
 }

```

このスキーマでクエリを実行したレスポンス例を以下に載せておきます。  

<details>

<summary>recipes query</summary>

## Query

```graphql
query {
  recipes(first: 2, after: "7248364", imageSize: "200x200c") {
    edges {
      cursor
      node {
        id
        title
        imageUrl
        ingredients {
          name
          quantity
        }
        steps {
          memo
          imageUrl
        }
        hashtags(hashtagLimitPerRecipe: 2) {
          name
        }
      }
    }
    pageInfo {
      hasPreviousPage
      hasNextPage
      startCursor
      endCursor
    }
  }
}
```

## Response

```json
{
  "data": {
    "recipes": {
      "edges": [
        {
          "cursor": "7248038",
          "node": {
            "id": "7248038",
            "title": "安い！うまい！血合カレー",
            "imageUrl": "https://placehold.jp/m.png",
            "ingredients": [
              {
                "name": "マグロの血合",
                "quantity": "300g"
              },
              {
                "name": "にんにく",
                "quantity": "2片"
              },
              {
                "name": "しょうが",
                "quantity": "1片"
              },
              {
                "name": "カレー粉",
                "quantity": "大さじ1"
              },
              {
                "name": "塩麹",
                "quantity": "小さじ2"
              },
              {
                "name": "白ワイン",
                "quantity": "60ミリ"
              }
            ],
            "steps": [
              {
                "memo": "1キロ以上で200円！家計の味方、今回はマグロの血合を使います",
                "imageUrl": "https://placehold.jp/m.png"
              },
              {
                "memo": "にんにく、しょうがをオリーブオイルをひいたフライパンで炒めます",
                "imageUrl": null
              },
              {
                "memo": "一口大に切ったお好みの野菜、血合を入れて中火で炒めます。ここでカレー粉と塩麹を入れて混ぜます。",
                "imageUrl": "https://placehold.jp/m.png"
              },
              {
                "memo": "マグロに火が7割くらい通ったら白ワインを入れて1分強火、そのあと蓋をして弱火で10分。",
                "imageUrl": null
              },
              {
                "memo": "塩、胡椒で味を整えてできあがり！",
                "imageUrl": "https://placehold.jp/m.png"
              }
            ],
            "hashtags": [
              {
                "name": "赤身のグルメ"
              },
              {
                "name": "こどもがパクパク"
              }
            ]
          }
        },
        {
          "cursor": "7247521",
          "node": {
            "id": "7247521",
            "title": "寿司酢で簡単！野菜のマリネ",
            "imageUrl": "https://placehold.jp/m.png",
            "ingredients": [
              {
                "name": "トマト",
                "quantity": "1個"
              },
              {
                "name": "ナス",
                "quantity": "1本"
              },
              {
                "name": "キャベツ",
                "quantity": "1/4個"
              },
              {
                "name": "塩",
                "quantity": "適量"
              },
              {
                "name": "寿司酢",
                "quantity": "大さじ2"
              },
              {
                "name": "",
                "quantity": ""
              }
            ],
            "steps": [
              {
                "memo": "トマト、ナス、キャベツなどお好みの野菜を一口大に刻みます。",
                "imageUrl": null
              },
              {
                "memo": "寿司酢と塩を振りかけて、全体を混ぜたら冷蔵庫で冷やします。",
                "imageUrl": null
              },
              {
                "memo": "冷えて野菜がクタッとしたら出来上がり！そのままでも豆腐にかけるのもオススメ。",
                "imageUrl": null
              },
              {
                "memo": "おすすめの酢は富士寿！コクとまろやかさが段違いです。",
                "imageUrl": "https://placehold.jp/m.png"
              }
            ],
            "hashtags": []
          }
        }
      ],
      "pageInfo": {
        "hasPreviousPage": false,
        "hasNextPage": true,
        "startCursor": "7248038",
        "endCursor": "7247521"
      }
    }
  }
}
```

</details>

<details>

<summary>recipe query</summary>

## Query

```graphql
query {
  recipe(id: "2332714", imageSize: "500x500c") {
    id
    title
    imageUrl
    user {
      name
      imageUrl
    }
    ingredients {
      name
      quantity
    }
    steps {
      memo
      imageUrl
    }
    hashtags {
      name
    }
  }
}
```


## Response

```json
{
  "data": {
    "recipe": {
      "id": "2332714",
      "title": "圧力鍋で簡単！スペアリブの赤ワイン煮込み",
      "imageUrl": "https://placehold.jp/m.png",
      "user": {
        "name": "kotori2010",
        "imageUrl": "https://placehold.jp/m.png"
      },
      "ingredients": [
        {
          "name": "スペアリブ",
          "quantity": "500g"
        },
        {
          "name": "玉ねぎ",
          "quantity": "1.5〜2個"
        },
        {
          "name": "★ケチャップ",
          "quantity": "大匙3"
        },
        {
          "name": "★赤ワイン",
          "quantity": "1.5カップ（300cc）"
        },
        {
          "name": "★塩",
          "quantity": "小匙１"
        },
        {
          "name": "★粗挽き黒胡椒",
          "quantity": "適量"
        },
        {
          "name": "★ローリエ",
          "quantity": "1〜2枚"
        },
        {
          "name": "パセリ",
          "quantity": "お好みで"
        }
      ],
      "steps": [
        {
          "memo": "フライパンに少量の油を熱し、スペアリブの表面を焼き付けて旨みを閉じ込める。（フッ素加工のフライパンなら油無しでOK）",
          "imageUrl": null
        },
        {
          "memo": "圧力鍋に１のスペアリブ、櫛形に切った玉ねぎ、★の材料を全て入れ、蓋を閉めて強火にかける。沸騰しておもりが揺れたら弱火に。",
          "imageUrl": null
        },
        {
          "memo": "おもりの揺れが止まらないように気をつけながら弱火のまま15分煮込む。火を止めたらそのまま放置して減圧。",
          "imageUrl": null
        },
        {
          "memo": "これでもうホロホロに柔らかいスペアリブになっています。器に盛り、お好みでパセリを散らして出来上がり。",
          "imageUrl": null
        }
      ],
      "hashtags": [
        {
          "name": "おもてなし"
        },
        {
          "name": "お酒が進む"
        },
        {
          "name": "とろとろお肉"
        },
        {
          "name": "食べたかった味"
        },
        {
          "name": "柔らか"
        },
        {
          "name": "あるものでできる"
        },
        {
          "name": "圧力鍋でお肉ホロホロ"
        },
        {
          "name": "肉食系喜ぶ"
        },
        {
          "name": "簡単ご馳走"
        },
        {
          "name": "圧力鍋"
        }
      ]
    }
  }
}
```

</details>


# 提出方法

実装した内容を適宜 commit し、 Pull Request (PR)を出してください。  
その際、 PR のベースブランチを自分の名前にしてください。  

- 全て一つの PR で提出する時
  - どのコミットがどの課題に対応するのかわかりやすくするために、commit のタイトルを課題の名前にしてください
    - 例： git commit -m "材料に `quantity` フィールド、ユーザーに `imageUrl` フィールドを追加する"
  - 講師側で進捗を把握するために課題が終わる度に出している PR に push して進捗を積み上げていってもらえると助かります
- 課題ごとに複数の PR に分ける時
  - どの PR がどの課題に対応するのかわかりやすくするために PR のタイトルを課題の名前にしてください
    - 例： "材料に `quantity` フィールド、ユーザーに `imageUrl` フィールドを追加する"
  - 出した PR はすぐにマージしてもらって、次の課題に進んでもらって大丈夫です

## 実装が正しいかどうかの確認

[仕様を確認するための簡易スクリプトを用意した](./appendix.md#基本課題の仕様確認)ので、必要に応じて利用してください。

以下、課題の各項目について、仕様などを説明します。

# B-1: 材料に `quantity` フィールド、ユーザーに `imageUrl` フィールドを追加する

ハンズオンで `Ingredient`、 `User` の型を定義しましたが、これに新しいフィールドを追加しましょう。

`quantity` は材料の量を示すもので、 `imageUrl` はユーザーアイコン画像の URL を示すものです。

## 仕様

- `Ingredient` 型に `quantity` フィールドを `String` 型で追加すること
- `User` 型に `imageUrl` フィールドを `String` 型で追加すること
- ユーザーの `imageUrl` のサイズは固定で `150x150c` となっていること

# B-2: レシピの画像サイズを引数で変更できるようにする

ハンズオンの A-2 で minirecipe サービスに `image_size` パラメーターを付与してリクエストすると画像サイズを変更できる機能を実装しました。  
これを BFF から利用できるようにしましょう！

以下のようなクエリを投げて、画像の URL に `200x200c` が含まれているものが返ってきたら OK です

```graphql
query {
  recipes(imageSize: "200x200c") {
    title
    imageUrl
  }
}
```

なお、`MinirecipeClient#get` が `params` を受け取れるようになっています。`bff/lib/minirecipe_client.rb` を読んでみてください。

## 仕様

- `imageSize` とう引数をオプショナルで指定できるようになっていること
- `imageSize` という引数を与えた場合、レスポンスの imageUrl の画像サイズが指定した値になっていること
- 指定しない場合は `m` という画像サイズで返ってくること

# B-3: レシピIDを指定して情報を取得できる機能を追加

レシピの一覧を取得するのではなくて、単一のレシピを ID を指定して取得できるようにします。

## 仕様

- レシピ詳細取得クエリのフィールド名は `recipe` になっていること
- レシピ詳細取得クエリと、レシピ一覧取得クエリのレスポンスに使う `Recipe` 型は共通のものを使うこと

# B-4: レシピの手順を取得する機能を追加

`Recipe` 型に調理手順を示す `steps` フィールドを追加しましょう。

## 仕様

- `steps` というフィールドを `[Step!]!` 型で追加すること
- `Step` 型の定義は、課題説明の際に提示したスキーマのようになっていること
- `step` 配列の並びは `ingredients` のときと同様に `position` の昇順になっていること
- 画像のサイズは `220x180` になっていること。

# B-5: レシピのハッシュタグを取得する機能を追加

GraphQL スキーマの `Recipe` 型に `hashtags` フィールドを追加しましょう。

## 仕様

- `hashtags` というフィールドを `[Hashtag!]!` 型で追加すること
- `Hashtag` 型の定義は、課題説明の際に提示したスキーマのようになっていること
- minihashtag サービスに対して N+1 のリクエストにならないようにすること
- `hashtagLimitPerRecipe` という引数で各レシピに対して返ってくるハッシュタグ数を指定できること

## 補足

### minihashtag サービスにすでに実装されているエンドポイントを利用してください

以下のように `/recipe_hashtags?recipe_ids={recipe_ids}` にリクエストを投げると、 recipe_id ごとに紐付いている hashtag の配列が得られるエンドポイントがすでに実装されているので、そちらを利用してください。

※ ハンズオンの内容が終わっていれば正しく動くと思いますが、もし動かない場合は講師や TA を呼んでください

```sh
curl -s 'http://localhost:3002/recipe_hashtags?recipe_ids=2332714,7262515&hashtag_limit_per_recipe=2' | jq .
{
  "recipe_hashtags": [
    {
      "recipe_id": 2332714,
      "hashtags": [
        {
          "id": 21,
          "name": "おもてなし"
        },
        { ... }
      ]
    },
    {
      "recipe_id": 7262515,
      "hashtags": []
    }
  ]
}
```

BFF で実装する場合、リクエスト部分の実装は先に作っているのでそちらを利用してください。

```ruby
client = MinihashtagClient.new
res = client.get("/recipe_hashtags", { recipe_ids: recipe_ids.join(","), hashtag_limit_per_recipe: 2 })
recipe_hashtags = res[:recipe_hashtags]
```

### N+1 になっていることを確認する方法

BFF の rails log を見ることで確認できます。  
各サービスにリクエストをする際にログを出すようにしています。

以下の例では、レシピ一覧で取得した各レシピに対して、 `/recipe_hashtags` を呼んでいるので N+1 になっています。

```log
[Recipe] Request to http://localhost:3001/recipes?cursor=&image_size=200x200c&limit=10
[Hashtag] Request to http://localhost:3002/recipe_hashtags?hashtag_limit_per_recipe=10&recipe_ids=7262515
[Hashtag] Request to http://localhost:3002/recipe_hashtags?hashtag_limit_per_recipe=10&recipe_ids=7261188
...
```

### N+1 を解消する方法

※ N+1にならないようにするのは大変なので、まずは N+1 になる実装から始めて、その後に N+1 を解消する順番をおすすめします（が、強制するものではありません）

GraphQL ではグラフをたどりつつ外部リソースにアクセスする構造になっているため、何もしなければ N+1 が発生します。
これに対して、様々なソリューションがあり、様々なライブラリが公開されています。

例
- https://github.com/shopify/graphql-batch
- https://github.com/exAspArk/batch-loader

これを使うだけであれば簡単なのですが、それではどういう仕組みで動作しているかがわからない状態で利用することになります。  
そこでこの講義では学習の意味も込めて、できるだけ自前で実装しましょう。

graphql-ruby が用意している遅延評価の仕組み（[GraphQL::Schema#lazy_resolve](https://graphql-ruby.org/api-doc/2.0.12/GraphQL/Schema#lazy_resolve-class_method)）だけを利用し、リクエストをまとめる処理は自前で書いてみましょう。

以下のページを参考に実装してみてください。
https://graphql-ruby.org/schema/lazy_execution.html

# B-6: レシピの投稿機能を追加

bff 経由でレシピを投稿できるようにしましょう。

## 仕様

- minirecipe
  - 以下の field を渡せること
    - title
    - description
    - user_id
  - 上記以外の field が渡ってきたときは 400 が返されること
  - 上記の field を持った Recipe モデルのレコードが作成されること
  - 材料については後述する title-to-ingredients という社内の API を利用して自動で埋めること
- BFF
  - Recipe を投稿できること
    - ハッシュタグの投稿と同様にやると良いです。

## title-to-ingredients について

社内には機械学習を用いてユーザーがレシピのタイトルをもとに材料を勝手に提案してくれる API サーバーが存在しています。

本来はこの API はフロントエンドでユーザーに候補を提案するだけで、実際に提案をデータとして保存することはないのですが、今回は簡単のために、この API を利用して勝手にレシピの材料を埋めるような仕組みを作ってみましょう。

minirecipe の Ingredient モデルに `title_to_ingredients` というメソッドがあり、その中で title-to-ingredients のサーバーを叩いています。  
このメソッドを利用すると良いでしょう。

また、title-to-ingredients サーバーの API にリクエストを投げる際には認証が必要です。  

アクセストークンは Authorization Header に入れて渡します。  
今回、リクエストは client -> bff -> minirecipe -> title-to-ingredients となるので、アクセストークンをバケツリレーする必要があります。

minirecipe へのリクエストは以下のようになるでしょう。  
Bearer 以降に上のコンソール画面から取得したアクセストークンを入れます。

```
curl --location 'http://localhost:3001/recipes' \
--header 'Authorization: Bearer xxxxxxxxxxxxxxxx' \
--header 'Content-Type: application/json' \
--data '{
    "title": "おいしい卵焼き",
    "description": "めちゃくちゃ美味しいです",
    "user_id": 10475640
}'
```

# B-7: レシピ一覧のページネーション機能を追加

レシピ一覧取得の際に、ページネーションをできるようにしましょう。  
今回は無限スクロールと相性の良い cursor ベースのページネーションを実装しましょう。

ページネーション実装は、[公式が公開しているベストプラクティス](https://graphql.org/learn/pagination/)に則って行いましょう。

[GraphQL Cursor Connections Specification](https://relay.dev/graphql/connections.htm)の仕様を読み、必要な実装を想像してみましょう。

すべてを実装するのは大変なので以下の制約を加えます。

- 次のデータを取得するページネーションしか実装しない
無限スクロールでは前のデータを取得することはないので実装しなくてよいです
`hasPreviousPage` は常に `false` を返す実装にしてください
- `cursor` は Recipe の ID をそのまま流用する
[GraphQL Cursor Connections Specification](https://relay.dev/graphql/connections.htm) によると、 `cursor` は意味が想像できない文字列にするべきという記載がありますが、今回は簡単のため、 ID の値を String に変換して利用しましょう。

## 仕様

- `recipes` クエリフィールドのスキーマは、課題説明の際に提示したスキーマのようになっていること
- レシピの順番は ID の降順になっていること
- `first`, `after` を指定して、次のデータを取得できること
- `last`, `before` は値が入力されても無視するが、スキーマとしては定義すること
- `hasPreviousPage` は常に `false` を返すこと
- `hasNextPage` はページネーションの状況に合わせて返すこと（次のページがない場合は `false` にすること）
- `cursor` の値は ID を String に変換したものを返すこと

## 補足

### ページネーションの実装

[GraphQL Cursor Connections Specification](https://relay.dev/graphql/connections.htm) に則った実装するための機能を graphql-ruby が提供してくれています。

ドキュメントを参考に実装してみましょう。
https://graphql-ruby.org/pagination/overview.html

# おわり

もし、万が一、全部できた方は、より発展的な課題にチャレンジしてみましょう！

[発展課題へ進む](./04-advanced.md)
