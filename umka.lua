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
-- @tparam[opt=false] bool    floating      Specify returning a floating-point number.
--
-- @treturn number                          Returns the random number
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
function u.in_table(t, i)
  if u.is_array(t) then
    return u.in_array(t, i)
  else
    return u.in_object(t, i)
  end
end

--- @export
return u
