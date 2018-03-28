# SwiftyStringScore

SwiftyStringScore (StringScore_Swift) is a Swift library which provides fast fuzzy string matching/scoring. Based on the [JavaScript library of the same name](https://github.com/joshaven/string_score), by [Joshaven Potter](https://github.com/joshaven).

![Screenshot](https://raw.githubusercontent.com/yichizhang/SwiftyStringScore/master/Screenshots/screenshot1.png)

## Examples

```
"hello world".score(word: "axl")	// ->0.0
"hello world".score(word: "ow")	// ->0.354545454545455
"hello world".score(word: "e")	// ->0.109090909090909
"hello world".score(word: "h")	// ->0.586363636363636
"hello world".score(word: "he")	// ->0.622727272727273
"hello world".score(word: "hel")	// ->0.659090909090909
"hello world".score(word: "hell")	// ->0.695454545454545
"hello world".score(word: "hello")	// ->0.731818181818182
"hello world".score(word: "hello worl")	// ->0.913636363636364
"hello world".score(word: "hello world")	// ->1.0
"hello world".score(word: "hello wor1")	// ->0.0
"hello world".score(word: "h")	// ->0.586363636363636
"hello world".score(word: "H")	// ->0.531818181818182
"hello world".score(word: "HiMi")	// ->0.0
"hello world".score(word: "Hills")	// ->0.0
"hello world".score(word: "Hillsd")	// ->0.0

"He".score(word: "h")	// ->0.675
"He".score(word: "H")	// ->0.75

"Hello".score(word: "hell")	// ->0.8475
"Hello".score(word: "hello")	// ->0.93
"Hello".score(word: "hello worl")	// ->0.0
"Hello".score(word: "hello world")	// ->0.0
"Hello".score(word: "hello wor1")	// ->0.0

"hello world".score(word: "hello worl", fuzziness:0.5)	// ->0.913636363636364
"hello world".score(word: "hello world", fuzziness:0.5)	// ->1.0
"hello world".score(word: "hello wor1", fuzziness:0.5)	// ->0.608181818181818

"Hillsdale Michigan".score(word: "HiMi", fuzziness:1.0)	// ->0.669444444444444
"Hillsdale Michigan".score(word: "Hills", fuzziness:1.0)	// ->0.661111111111111
"Hillsdale Michigan".score(word: "Hillsd", fuzziness:1.0)	// ->0.683333333333333
```

## Parameters

### Fuzziness

A number between 0 and 1 which varys how fuzzy/ the calculation is.
Defaults to `nil` (fuzziness disabled).


## License

Licensed under the [MIT license](http://www.opensource.org/licenses/mit-license.php).
