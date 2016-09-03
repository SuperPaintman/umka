u = require "umka"

describe "random()", ->
    it "should return `0` or `1` when no arguments are given", ->
        for i = 1, 1000
            result = u.random()

            assert.is_true result == 0 or result == 1

    it "should support `upper` argument", ->
        for i = 1, 100
            result = u.random(0)

            assert.is_true u.is_integer(result)
            assert.is_true result == 0

        for i = 1, 1000
            result = u.random(50)

            assert.is_true u.is_integer(result)
            assert.is_true result >= 0 and result <= 50

    it "should support `lower` and `upper` arguments", ->
        for i = 1, 100
            result = u.random(15, 15)

            assert.is_true u.is_integer(result)
            assert.is_true result == 15

        for i = 1, 1000
            result = u.random(10, 80)

            assert.is_true u.is_integer(result)
            assert.is_true result >= 10 and result <= 80

    it "should swap `lower` and `upper` when `lower` > `upper`", ->
        for i = 1, 1000
            result = u.random(80, 10)

            assert.is_true u.is_integer(result)
            assert.is_true result >= 10 and result <= 80

    it "should support floats when `lower` is float", ->
        has_float = false
        for i = 1, 1000
            result = u.random(8.8, 90)

            if not u.is_integer(result)
                has_float = true

            assert.is_true result >= 8.8 and result <= 90

        assert.is_true has_float

    it "should support floats when `upper` is float", ->
        has_float = false
        for i = 1, 1000
            result = u.random(9, 55.5)

            if not u.is_integer(result)
                has_float = true

            assert.is_true result >= 9 and result <= 55.5

        assert.is_true has_float

    it "should support floats when `lower` and `upper` is float", ->
        has_float = false
        for i = 1, 1000
            result = u.random(8.7, 158.1)

            if not u.is_integer(result)
                has_float = true

            assert.is_true result >= 8.7 and result <= 158.1

        assert.is_true has_float

    it "should support `lower`, `upper` and `floating` arguments", ->
        for i = 1, 1000
            result = u.random(10, 80, false)

            assert.is_true u.is_integer(result)
            assert.is_true result >= 10 and result <= 80

    it "should support floats when `floating` is boolean", ->
        has_float = false
        for i = 1, 1000
            result = u.random(1, 9000, true)

            if not u.is_integer(result)
                has_float = true

            assert.is_true result >= 1 and result <= 9000

        assert.is_true has_float

        has_float = false
        for i = 1, 1000
            result = u.random(8.8, 900.155, true)

            if not u.is_integer(result)
                has_float = true

            assert.is_true result >= 8.8 and result <= 900.155

        assert.is_true has_float


describe "is_integer()", ->
    it "should return `true` for integer values", ->
        for i = -1000, 1000
            assert.is_true u.is_integer(i)

    it "should return `false` for float values", ->
        for k, v in pairs({-1.5, -124124.17, 100.7, 300.5, 6000.0000000001})
            assert.is_false u.is_integer(v)

    it "should return `false` for other non-integer values", ->
        assert.is_false u.is_integer()
        assert.is_false u.is_integer({})
        assert.is_false u.is_integer({-1, 0, 1})
        assert.is_false u.is_integer({ hello: "world" })
        assert.is_false u.is_integer(false)
        assert.is_false u.is_integer(true)
        assert.is_false u.is_integer(nil)
        assert.is_false u.is_integer("hello lua")
        assert.is_false u.is_integer(->)

