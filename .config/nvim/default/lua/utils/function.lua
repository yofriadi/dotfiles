local M = {}

M.trim = function(str)
  return (str:gsub("^%s*(.-)%s*$", "%1"))
end

-- Returns the index of the first element in the array that satisfies the provided testing function
M.find_index = function(tbl, func)
  for index, item in ipairs(tbl) do
    if func(item, index) then
      return index
    end
  end

  return nil
end

M.isome = function(tbl, func)
  for index, item in ipairs(tbl) do
    if func(item, index) then
      return true
    end
  end

  return false
end

-- Returns the first element in the array that satisfies the provided testing function
M.ifind = function(tbl, func)
  for index, item in ipairs(tbl) do
    if func(item, index) then
      return item
    end
  end

  return nil
end

M.ieach = function(tbl, func)
  for index, element in ipairs(tbl) do
    func(element, index)
  end
end

M.ifilter = function(tbl, func)
  return vim.tbl_filter(func, tbl)
end

-- Executes a user-supplied "reducer" callback function on each element of the table indexed with a numeric key, in order, passing in the return value from the calculation on the preceding element
M.ireduce = function(tbl, func, acc)
  for i, v in ipairs(tbl) do
    acc = func(acc, v, i)
  end
  return acc
end

M.switch = function(param, t)
  local case = t[param]
  if case then
    return case()
  end
  local defaultFn = t["default"]
  return defaultFn and defaultFn() or nil
end

-- Creates a new table populated with the results of calling a provided functions on every numeric indexed element in the calling table
M.imap = function(tbl, func)
  return M.ireduce(tbl, function(new_tbl, value, index)
    table.insert(new_tbl, func(value, index))
    return new_tbl
  end, {})
end

M.always = function(value)
  return function()
    return value
  end
end

M.ignore = function() end

return M
