---
-- Lua utility library
-- @module umka
-- @author Alexander Krivoshhekov <SuperPaintmanDeveloper@gmail.com>
-- @license MIT
--

local math = require "math"

local u = {}

--------------------------------------------------------------------------------
-- Numbers
--------------------------------------------------------------------------------

--- Return random number
-- @tparam[opt=0]     number  lower         The lower bound.
-- @tparam[opt=1]     number  upper         The upper bound.
-- @tparam[opt=false] boolean floating      Specify returning a floating-point number.
--
-- @treturn number                          Returns the random number
--
-- @since 0.1.0
--
-- @usage
-- u.random(0, 10)
-- -- => 7
--
-- u.random(7)
-- -- => 4
--
-- u.random(-10, 10, true)
-- -- => -4.2717062898648
--
-- u.random(2.4, 7.1)
-- -- => 3.3085299233985
function u.random(...)
  local args_count = select("#", ...)
  local lower     = select(1, ...)
  local upper     = select(2, ...)
  local floating  = select(3, ...)

  if args_count == 1 then
    upper = lower
    lower = nil
  end

  if lower == nil then lower = 0 end
  if upper == nil then upper = 1 end
  if floating == nil then floating = false end

  if not u.is_integer(lower) or not u.is_integer(upper) then floating = true end

  -- Swap values when lover > upper
  if lower > upper then
    lower, upper = upper, lower
  end

  if floating then
    return math.min(lower + math.random() * (upper - lower), upper)
  else
    return math.random(lower, upper)
  end
end

--- Checks if value is an integer.
-- @tparam    number   value      The value to check.
--
-- @treturn   boolean             Returns true if value is an integer, else false.
--
-- @since 0.1.0
--
-- @usage
-- u.is_integer(6)
-- -- => true
--
-- u.is_integer(-9000)
-- -- => true
--
-- u.is_integer(1337.85)
-- -- => false
--
-- u.is_integer("8")
-- -- => false
function u.is_integer(value)
  if type(value) ~= "number" then
    return false
  end

  return value % 1 == 0
end

--------------------------------------------------------------------------------
-- Strings
--------------------------------------------------------------------------------

--- Splits string into an array of strings
-- @tparam        string str              The string to split.
-- @tparam[opt]   string separator        The character to use for separating the string.
--
-- @treturn       string[]                Returns the array of strings.
--
-- @since 0.1.0
--
-- @usage
-- u.split("abc")
-- -- => {"a", "b", "c"}
--
-- u.split("a-b-c", "-")
-- -- => {"a", "b", "c"}
--
-- u.split("a--|--b--|--c", "--|--")
-- -- => {"a", "b", "c"}
function u.split(str, separator)
  local parts = {}
  local start = 1
  local finded = 1

  if separator and separator ~= "" then
    while finded do
      finded = str:find(separator, start)
      if finded then
        table.insert(parts, str:sub(start, finded - 1))
        start = finded + #separator
      else
        table.insert(parts, str:sub(start))
      end
    end
  else
    for i = 1, #str do
      table.insert(parts, str:sub(i, i))
    end
  end

  return parts
end

--------------------------------------------------------------------------------
-- Tables
--------------------------------------------------------------------------------

--- Checks if value is an array.
-- @tparam   any    value         The value to check.
--
-- @treturn  boolean              Returns true if value is an array, else false.
--
-- @since 0.1.0
--
-- @usage
-- u.is_array({})
-- -- => true
--
-- u.is_array({1, 2, 3})
-- -- => true
--
-- u.is_array({ hello = "world" })
-- -- => false
--
-- u.is_array("umka")
-- -- => false
function u.is_array(value)
  if type(value) ~= "table" then
    return false
  end

  for k, v in pairs(value) do
    if type(k) ~= "number" then
      return false
    end
  end

  return true
end

--- Merge two or more arrays into one
-- @tparam    any[]    main_array    The destination array.
-- @tparam    any[][]  ...           The source arrays.
--
-- @treturn   any[]                  Returns array.
--
-- @since 0.1.0
--
-- @usage
-- u.merge_arrays({1, 2, 3}, {4, 5})
-- -- => {1, 2, 3, 4, 5}
--
-- u.merge_arrays({1, 2, 3}, {4, 5}, {"hello"}, {1})
-- -- => {1, 2, 3, 4, 5, "hello", 1}
function u.merge_arrays(main_array, ...)
  -- Walk arrays
  for i = 1, select("#", ...) do
    local arr = select(i, ...)

    -- Walk values of source array
    for k, v in pairs(arr) do
      table.insert(main_array, v)
    end
  end

  return main_array
end

--- Merge two or more object into one
-- @tparam  table     main_object       The destination object.
-- @tparam  table[]   ...               The source objects.
--
-- @treturn table                       Returns object.
--
-- @since 0.1.0
--
-- @usage
-- u.merge_objects({hello = "world"}, {where = "there"})
-- -- => {hello = "world", where = "there"}
--
-- u.merge_objects({hello = "world"}, {where = "there"}, {hello = "no"})
-- -- => {hello = "no", where = "there"}
function u.merge_objects(main_object, ...)
  -- Walk objects
  for i = 1, select("#", ...) do
    local obj = select(i, ...)

    -- Walk values of source object
    for k, v in pairs(obj) do
      if type(v) == "table" and main_object[k] ~= nil then
        main_object[k] = u.merge(main_object[k], v)
      else
        main_object[k] = v
      end
    end
  end

  return main_object
end

--- Merge two or more tables into one
-- @tparam table        main_table    The destination table.
-- @tparam table[]      ...           The source tables.
--
-- @treturn table                     Returns table.
--
-- @since 0.1.0
--
-- @usage
-- u.merge({hello = "world"}, {where = "there"})
-- -- => {hello = "world", where = "there"}
--
-- u.merge({hello = "world"}, {where = "there"}, {hello = "no"})
-- -- => {hello = "no", where = "there"}
--
-- u.merge({1, 2, 3}, {hello = "world"})
-- -- => {[1] = 1, [2] = 2, [3] = 3, hello = "world"}
--
-- u.merge({hello = "world"}, {4, 5, 6})
-- -- => {[1] = 4, [2] = 5, [3] = 6, hello = "world"}
function u.merge(main_table, ...)
  local is_arr = true

  -- Finding object argument
  if not u.is_array(main_table) then
    is_arr = false
  else
    for i = 1, select("#", ...) do
      local t = select(i, ...)

      if not u.is_array(t) then
        is_arr = false
        break
      end
    end
  end

  if is_arr then
    return u.merge_arrays(main_table, ...)
  else
    return u.merge_objects(main_table, ...)
  end
end

--- Checks if value includes in a array
-- @tparam    any[]  arr        The array to query.
-- @tparam    any    value      The value to search for.
--
-- @treturn   boolean           Returns true if value exists, else false.
--
-- @since 0.1.0
--
-- @usage
-- u.in_array({1, 2, 3}, 3)
-- -- => true
--
-- u.in_array({1, 2, 3}, 7)
-- -- => false
function u.in_array(arr, value)
  for k, v in ipairs(arr) do
    if v == value then return true end
  end

  return false
end

--- Checks if key includes in a object
-- @tparam    table          object       The object to query.
-- @tparam    string|number  key          The key to search for.
--
-- @treturn   boolean                     Returns true if key exists, else false.
--
-- @since 0.1.0
--
-- @usage
-- u.in_object({hello = "world", where = "there"}, "hello")
-- -- => true
--
-- u.in_object({hello = "world", where = "there"}, "umka")
-- -- => false
function u.in_object(object, key)
  for k, v in pairs(object) do
    if k == key then return true end
  end

  return false
end

--- Checks if key or value includes in a object or array
-- @tparam   table|any[]    t     The object or array to query.
-- @tparam   any            i     The key or value to search for.
--
-- @treturn  boolean              Returns true if key or value exists, else false.
--
-- @since 0.1.0
--
-- @usage
-- u.in_table({1, 2, 3}, 3)
-- -- => true
--
-- u.in_table({1, 2, 3}, 7)
-- -- => false
--
-- u.in_table({hello = "world", where = "there"}, "hello")
-- -- => true
--
-- u.in_table({hello = "world", where = "there"}, 1)
-- -- => false
function u.in_table(t, i)
  if u.is_array(t) then
    return u.in_array(t, i)
  else
    return u.in_object(t, i)
  end
end

--- @export
return u
