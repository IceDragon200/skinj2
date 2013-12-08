Skinj 2
=======
## 0.5.0 [![Code Climate](https://codeclimate.com/github/IceDragon200/skinj2.png)](https://codeclimate.com/github/IceDragon200/skinj2)

## Introduction
Inspired by C's preprocessor, skinj is designed to bring that functionality,
by adding functions like replacement, ruby injection and other nifty features.

Skinj is not limited to inling in ruby scripts, it can be used in anything.
From simple everyday text files, to multi linked scripts.

## Example
Input
```
Herp Derp, Dperity Derp
#-// Skinj Comment, this line will not be rendered
More Derp
#-jump end
Some stuff that we care not about :)
#-label end
```

Output
```
Herp Derp, Dperity Derp
More Derp
```

## Known problems
Skinj does not detect inclusion loops, so be careful when including multiple
files in a file.

## Dependencies
```
thor (http://whatisthor.com/)
```
