# Umka

[![Linux Build][travis-image]][travis-url]
[![Test Coverage][coveralls-image]][coveralls-url]
[![Luarocks version][luarocks-image]][luarocks-url]


Lua utility library


## Installation

```sh
luarocks install umka
```

--------------------------------------------------------------------------------

## Usage

```lua
local u = require("umka")

u.random(0, 100, true)
-- ➜ 42.17
```

--------------------------------------------------------------------------------

## API
[Docs][docs-url]

--------------------------------------------------------------------------------

## Changelog
[Changelog][changelog-url]

--------------------------------------------------------------------------------

## License

[MIT][license-url]


[license-url]: LICENSE
[changelog-url]: CHANGELOG.md
[docs-url]: https://superpaintman.github.io/umka/
[travis-image]: https://img.shields.io/travis/SuperPaintman/umka/master.svg?label=linux
[travis-url]: https://travis-ci.org/SuperPaintman/umka
[coveralls-image]: https://img.shields.io/coveralls/SuperPaintman/umka/master.svg
[coveralls-url]: https://coveralls.io/r/SuperPaintman/umka?branch=master
[luarocks-image]: https://img.shields.io/github/tag/superpaintman/umka.svg?label=luarocks
[luarocks-url]: https://luarocks.org/modules/superpaintman/umka
