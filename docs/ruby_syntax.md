## Ruby

基本的にはドキュメントに載っているので正確なものや網羅的なものはそちらを参照してください。  
Document: https://docs.ruby-lang.org/ja/3.1/doc/index.html  

また、基本構文は過去のインターンの資料でわかりやすく説明されているので、そちらも参照してみてください。  
https://speakerdeck.com/sankichi92/cookpad-summer-internship-2021-web-api?slide=12

他言語から Ruby に入門するためのドキュメントもあるので、もし興味があれば見てみてください。  
https://www.ruby-lang.org/ja/documentation/ruby-from-other-languages/

以下では講義で利用しそうな構文を一部抜粋して紹介しています。  
また簡単のため、各メソッドの説明も一部の利用用途のみ説明しています。詳細な仕様やオプションは適宜ドキュメントを参考にしてください。  

```rb
# 配列の操作 https://docs.ruby-lang.org/ja/3.1/class/Array.html

# 配列の長さを返す (length も同様)
[1, nil, 3, nil].size    #=> 4

# nil を取り除いた配列を返す
[1, nil, 3, nil].compact    #=> [1, 3]

# 配列の各要素に対してブロックを評価した結果をすべて含む配列を返す
[1, 2, 3].map {|n| n * 3 }  # => [3, 6, 9]
```

```rb
# 文字列の操作 https://docs.ruby-lang.org/ja/3.1/class/String.html

# 文字列を指定したセパレータによって分割し、文字列の配列を返す
p "a|b|c".split("|")          # => ["a", "b", "c"]   
p "   a \t  b \n  c".split    # => ["a", "b", "c"]  # 先頭と末尾の空白を除いたうえで、空白文字(" \t\r\n\f\v")で分割する。

# 文字列の先頭が引数の文字列と一致すれば true を返す
"string".start_with?("str")          # => true
"string".start_with?("ing")          # => false

# 文字列の先頭から引数の文字列を削除した文字列のコピーを返す
"hello".delete_prefix("hel") # => "lo"
"hello".delete_prefix("llo") # => "hello"
```
