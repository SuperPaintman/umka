local math = require "math"

local u = {}

--------------------------------------------------------------------------------
-- Numbers
--------------------------------------------------------------------------------

--- Return random number
-- @param {Number} [lower=0]              The lower bound.
-- @param {Number} [upper=1]              The upper bound.
-- @param {Number|Boolean} [floating=14]  Specify returning a floating-point number.
--
-- @return {Number}  Returns the random number.
function u.random(lower, upper, floating)
  if lower == nil then lower = 0 end
  if upper == nil then upper = 1 end

  if floating == nil or floating == false then
    floating = 0
  elseif floating == true then
    floating = 14
  elseif floating > 14 then
    floating = 14
  elseif floating < 0 then
    floating = 0
  end

  local m = math.pow(10, floating)

  return math.random(lower * m, upper * m) / m
end

--------------------------------------------------------------------------------
-- Strings
--------------------------------------------------------------------------------

--- Splits string into an array of strings
-- @param {String} str              The string to split.
-- @param {String} [separator]      The character to use for separating the string.
--
-- @return {String[]}  Returns the array of strings.
function u.split(str, separator)
  local parts = {}
  local start = 1
  local finded = 1

  if separator and separator ~= "" then
    while finded do
      finded = str:find(separator, start)
      if finded then
        table.insert(parts, str:sub(start, finded - 1))
        start = finded + 1
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
-- @param {Any} value              The string to split.
--
-- @return {Boolean}  Returns true if value is an array, else false.
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
-- @param {Any[]} main_array        The destination array
-- @param {...Any[]}                The source arrays
--
-- @return {Any[]}  Returns array
function u.merge_array(main_array, ...)
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
-- @param {Object} main_object       The destination object
-- @param {...Object}                The source objects
--
-- @return {Object}  Returns object
function u.merge_object(main_object, ...)
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
-- @param {Table} main_table       The destination table
-- @param {...Table}               The source tables
--
-- @return {Table}  Returns table
function u.merge(main_table, ...)
  local is_arr = false
  if #main_table > 0 and u.is_array(main_table) then
    is_arr = true
  else
    for i = 1, select("#", ...) do
      local t = select(i, ...)

      if #t > 0 and u.is_array(t) then
        is_arr = true
        break
      end
    end
  end

  if is_arr then
    return u.merge_array(main_table, unpack({...}))
  else
    return u.merge_object(main_table, unpack({...}))
  end
end

function u.in_array(t, i)
  for k, v in ipairs(t) do
    if v == i then return true end
  end

  return false
end

function u.in_object(t, i)
  for k, v in pairs(t) do
    if k == i then return true end
  end

  return false
end

function u.in_table(t, i)
  if u.is_array(t) then
    return u.in_array(t, i)
  else
    return u.in_object(t, i)
  end
end

return u
