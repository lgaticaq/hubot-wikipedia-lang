# hubot-wikipedia-lang

[![npm version](https://img.shields.io/npm/v/hubot-wikipedia-lang.svg?style=flat-square)](https://www.npmjs.com/package/hubot-wikipedia-lang)
[![npm downloads](https://img.shields.io/npm/dm/hubot-wikipedia-lang.svg?style=flat-square)](https://www.npmjs.com/package/hubot-wikipedia-lang)
[![Build Status](https://img.shields.io/travis/lgaticaq/hubot-wikipedia-lang.svg?style=flat-square)](https://travis-ci.org/lgaticaq/hubot-wikipedia-lang)
[![Coverage Status](https://img.shields.io/coveralls/lgaticaq/hubot-wikipedia-lang/master.svg?style=flat-square)](https://coveralls.io/github/lgaticaq/hubot-wikipedia-lang?branch=master)
[![Code Climate](https://img.shields.io/codeclimate/github/lgaticaq/hubot-wikipedia-lang.svg?style=flat-square)](https://codeclimate.com/github/lgaticaq/hubot-wikipedia-lang)
[![dependency Status](https://img.shields.io/david/lgaticaq/hubot-wikipedia-lang.svg?style=flat-square)](https://david-dm.org/lgaticaq/hubot-wikipedia-lang#info=dependencies)
[![devDependency Status](https://img.shields.io/david/dev/lgaticaq/hubot-wikipedia-lang.svg?style=flat-square)](https://david-dm.org/lgaticaq/hubot-wikipedia-lang#info=devDependencies)

> A Hubot script for search articles in Wikipedia

## Install

```bash
npm i -S hubot-wikipedia-lang
```

Add `["hubot-wikipedia-lang"]` in `external-scripts.json`.

Set optional `HUBOT_WIKIPEDIA_LANG` (default en) in environment variable to change default language.

## Example
`hubot wiki search <query>` -> `Get the first 5 articles`

`hubot wiki summary <article>` -> `Get a one-line description`

`hubot wiki language <language>` -> `Set a language for search`

## License

[MIT](https://tldrlegal.com/license/mit-license)
