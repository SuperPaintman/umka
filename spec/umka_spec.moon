u = require "umka"

describe "random()", ->
    it "should return `0` or `1` when no arguments are given", ->
        for i = 1, 1000
            result = u.random()

            assert.is_true result == 0 or result == 1

    it "should support `upper` argument", ->
        for i = 1, 1000
            result = u.random(50)

            assert.is_true u.is_integer(result)
            assert.is_true result >= 0 and result <= 50

    it "should support `lower` and `upper` arguments", ->
        for i = 1, 1000
            result = u.random(10, 80)

            assert.is_true u.is_integer(result)
            assert.is_true result >= 10 and result <= 80

    it "should swap `lower` and `upper` when `lower` > `upper`", ->
        for i = 1, 1000
            result = u.random(80, 10)

            assert.is_true u.is_integer(result)
            assert.is_true result >= 10 and result <= 80

    it "should support `lower`, `upper` and `floating` arguments", ->
        for i = 1, 1000
            result = u.random(10, 80, false)

            assert.is_true u.is_integer(result)
            assert.is_true result >= 10 and result <= 80

    it "should support floats when `floating` is boolean", ->
        has_float = false
        for i = 1, 1000
            result = u.random(8.8, 900.155, true)

            if not u.is_integer(result)
                has_float = true

            assert.is_true result >= 8.8 and result <= 900.155

        assert.is_true has_float

    it "should support floats when `floating` is number", ->
        has_float = false
        for i = 1, 1000
            result = u.random(8.8, 900.155, 10)

            if not u.is_integer(result)
                has_float = true

            assert.is_true result >= 8.8 and result <= 900.155

        assert.is_true has_float

        for i = 1, 1000
            result = u.random(900.1, 900.155, 1)

            assert.is_true result == 900.1

