--Hash.lua
--author: Evandro Leopoldino Gonçalves <evandrolgoncalves@gmail.com>
--https://github.com/evandrolg
--License: MIT


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

local Hash = {}

Hash = {
  __VERSION = '1.0.0',
  __DESCRIPTION = "A small library with useful methods to handle Lua's table when it's working like a Hash",
  __LICENCE = [[
  The MIT License (MIT)
  Copyright (c) 2017 Evandro Leopoldino Gonçalves
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:
  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
  ]],

  is_hash = function(obj)
    return type(obj) == 'table'
  end,

  is_empty = function(obj)
    return Hash.is_hash(obj) and not has_key(obj)
  end,

  keys = function(obj)
    assert(Hash.is_hash(obj), 'keys method expects a hash')

    local output = {}

    for key in pairs(obj) do
      table.insert(output, key)
    end

    return output
  end,

  values = function(obj)
    assert(Hash.is_hash(obj), 'values method expects a hash')

    local output = {}

    for key, value in pairs(obj) do
      table.insert(output, value)
    end

    return output
  end,

  remove_key = function(obj, key)
    assert(Hash.is_hash(obj), 'remove_key method expects a hash')

    if obj[key] ~= nil then
      obj[key] = nil
      return true
    end

    return false
  end,

  pick = function(obj, keys_or_callback)
    local output = {}

    if type(keys_or_callback) == 'function' then
      for k, v in pairs(obj) do
        if keys_or_callback(k, v) then output[k] = v  end
      end
    elseif type(keys_or_callback) == 'table' then
      for i=1, #keys_or_callback do
        if obj[keys_or_callback[i]] then
          output[keys_or_callback[i]] = obj[keys_or_callback[i]]
        end
      end
    end

    return output
  end,

  map = function(obj, callback)
    assert(Hash.is_hash(obj), 'map method expects a hash')

    local output = {}

    for k, v in sorted_iter(obj) do
      table.insert(output, callback(v, k))
    end

    return output
  end,

  copy = function(obj)
    assert(Hash.is_hash(obj), 'copy method expects a hash')

    local output = {}

    for k, v in pairs(obj) do
      output[k] = v
    end

    return  output
  end,

  deep_copy = function(obj)
    if type(obj) ~= 'table' then return obj end

    local copy = {}

    for k, v in next, obj do
      copy[k] = Hash.deep_copy(v)
    end

    return copy
  end,

  merge = function(obj1, obj2)
    assert(Hash.is_hash(obj1), 'merge method expects two hashes')
    assert(Hash.is_hash(obj2), 'merge method expects two hashes')

    local copy = Hash.copy(obj1)

    for k, v in pairs(obj2) do
      copy[k] = v
    end

    return copy
  end,

  each = function(obj, callback)
    assert(Hash.is_hash(obj), 'each method expects a hash')

    for k, v in pairs(obj) do
      callback(k, v)
    end
  end
}

return Hash
