-- Checks if object has the key passed by parameter
-- @param object {table}
-- @return {boolean}
local function has_key(obj)
  for _ in pairs(obj) do
    return true
  end

  return false
end

-- Checks if list has the value passed by parameter
-- @param object {table}
-- @return {boolean}
local function includes(list, value)
  for k=1, #list do
    if list[k] == value then return true end
  end

  return false
end

return {
  has_key = has_key,  
  sorted_iter = sorted_iter,
  includes = includes
}
