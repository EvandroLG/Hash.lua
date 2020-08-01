local function has_key(obj)
  for _ in pairs(obj) do
    return true
  end

  return false
end

local function sorted_iter(obj)
  local keys = {}

  for k in pairs(obj) do
    table.insert(keys, k)
  end

  table.sort(keys)

  return function()
    local k = table.remove(keys)

    if k ~= nil then
      return k, obj[k]
    end
  end
end

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
