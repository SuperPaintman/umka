local u = require "umka"

describe("random()", function ()
  it("should return `0` or `1` when no arguments are given", function ()
    for i = 1, 1000 do
      local result = u.random()

      assert.is_true(result == 0 or result == 1)
    end
  end)

  it("should support `upper` argument", function ()
    for i = 1, 1000 do
      local result = u.random(50)

      assert.is_true(u.is_integer(result))
      assert.is_true(result >= 0 and result <= 50)
    end
  end)

  it("should support `lower` and `upper` arguments", function ()
    for i = 1, 1000 do
      local result = u.random(10, 80)

      assert.is_true(u.is_integer(result))
      assert.is_true(result >= 10 and result <= 80)
    end
  end)

  it("should swap `lower` and `upper` when `lower` > `upper`", function ()
    for i = 1, 1000 do
      local result = u.random(80, 10)

      assert.is_true(u.is_integer(result))
      assert.is_true(result >= 10 and result <= 80)
    end
  end)

  it("should support `lower`, `upper` and `floating` arguments", function ()
    for i = 1, 1000 do
      local result = u.random(10, 80, false)

      assert.is_true(u.is_integer(result))
      assert.is_true(result >= 10 and result <= 80)
    end
  end)

  it("should support floats when `floating` is boolean", function ()
    local has_float = false
    for i = 1, 1000 do
      local result = u.random(8.8, 900.155, true)

      if not u.is_integer(result) then
        has_float = true
      end

      assert.is_true(result >= 8.8 and result <= 900.155)
    end

    assert.is_true(has_float)
  end)

  it("should support floats when `floating` is number", function ()
    local has_float = false
    for i = 1, 1000 do
      local result = u.random(8.8, 900.155, 10)

      if not u.is_integer(result) then
        has_float = true
      end

      assert.is_true(result >= 8.8 and result <= 900.155)
    end

    assert.is_true(has_float)

    for i = 1, 1000 do
      local result = u.random(900.1, 900.155, 1)

      assert.is_true(result == 900.1)
    end
  end)
end)
