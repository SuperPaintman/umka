local math = require "math"

local u = {}

--------------------------------------------------------------------------------
-- Numbers
--------------------------------------------------------------------------------
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
function u.split(str, delim)
  local parts = {}
  local start = 1
  local finded = 1

  if delim and delim ~= "" then
    while finded do
      finded = str:find(delim, start)
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
function u.is_array(a)
  if type(a) ~= "table" then
    return false
  end

  for k, v in pairs(a) do
    if type(k) ~= "number" then
      return false
    end
  end

  return true
end

function u.merge_array(main_array, ...)
  for i = 1, select("#", ...) do
    local arr = select(i, ...)

    for k, v in pairs(arr) do
      table.insert(main_array, v)
    end
  end

  return main_array
end

function u.merge_object(main_object, ...)
  for i = 1, select("#", ...) do
    local obj = select(i, ...)

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
