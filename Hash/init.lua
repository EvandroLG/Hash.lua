local utils = require('Hash.utils')

local Hash = {}

Hash = {
  __VERSION = '1.0.2',
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

  -- Verifies if table works like an object.
  -- @param object {table}
  -- @return {boolean}
  is_hash = function(obj)
    return type(obj) == 'table'
  end,

  -- Checks if table is empty.
  -- @param object {table}
  -- @return {boolean}
  is_empty = function(obj)
    return Hash.is_hash(obj) and not utils.has_key(obj)
  end,

  -- Returns a new table populated with the all keys from the table passed as parameter.
  -- @param object {table}
  -- @return {table}
  keys = function(obj)
    assert(Hash.is_hash(obj), 'keys method expects a hash')

    local output = {}

    for key in pairs(obj) do
      table.insert(output, key)
    end

    return output
  end,

  -- Returns a new table populated with the all values from the table passed as paramter.
  -- @param object {table}
  -- @return {table}
  values = function(obj)
    assert(Hash.is_hash(obj), 'values method expects a hash')

    local output = {}

    for key, value in pairs(obj) do
      table.insert(output, value)
    end

    return output
  end,

  -- Removes the key from the table; returns true if it was found and removed, otherwise it returns false.
  -- @param object {table}
  -- @param key {string}
  -- @return {boolean}
  remove_key = function(obj, key)
    assert(Hash.is_hash(obj), 'remove_key method expects a hash')

    if obj[key] ~= nil then
      obj[key] = nil
      return true
    end

    return false
  end,

  -- Returns a new table filtered only with values for the keys passed by parameter. Alternatively it accepts a callback where you can filter which keys to pick.
  -- @param object {table}
  -- @param keys {table|function}
  -- @return {table}
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

  -- Returns a new table of values by mapping each value in table through a transformation function.
  -- @param object {table}
  -- @param callback {function}
  -- @return {table}
  map = function(obj, callback)
    assert(Hash.is_hash(obj), 'map method expects a hash')

    local output = {}

    for k, v in pairs(obj) do
      table.insert(output, callback(v, k))
    end

    return output
  end,

  -- Makes a shallow copy of the table passed by parameter.
  -- @param object {table}
  -- @return {table}
  copy = function(obj)
    assert(Hash.is_hash(obj), 'copy method expects a hash')

    local output = {}

    for k, v in pairs(obj) do
      output[k] = v
    end

    return  output
  end,

  -- Makes a deep copy of the table passed by parameter.
  -- @param object {table}
  -- @return {table}
  deep_copy = function(obj)
    if type(obj) ~= 'table' then return obj end

    local copy = {}

    for k, v in next, obj do
      copy[k] = Hash.deep_copy(v)
    end

    return copy
  end,

  -- Returns a new table containing the contents of `object1` and `object2`.
  -- @param object1 {table}
  -- @param object2 {table}
  -- @return {table}
  merge = function(obj1, obj2)
    assert(Hash.is_hash(obj1), 'merge method expects two hashes')
    assert(Hash.is_hash(obj2), 'merge method expects two hashes')

    local copy = Hash.copy(obj1)

    for k, v in pairs(obj2) do
      copy[k] = v
    end

    return copy
  end,

  -- Iterates over a table, yielding each in turn to an iteratee function.
  -- @param object {table}
  -- @return {nil}
  each = function(obj, callback)
    assert(Hash.is_hash(obj), 'each method expects a hash')

    for k, v in pairs(obj) do
      callback(k, v)
    end
  end,

  -- Iterates over a table, yielding each in turn to an iteratee function.
  -- @param object {table}
  -- @return {number}
  size = function(obj)
    assert(Hash.is_hash(obj), 'each method expects a hash')

    local count = 0

    for k, v in pairs(obj) do
      count = count + 1
    end

    return count
  end,

  -- Returns a copy of the object passed by parameter omitting the keys decided in the second parameter.
  -- @param object {table}
  -- @param keys {table|function}
  -- @return {table}
  omit = function(obj, keys_or_callback)
    assert(Hash.is_hash(obj), 'omit method expects a hash')

    local result = {}

    if type(keys_or_callback) == 'function' then
      for k, v in pairs(obj) do
        if keys_or_callback(v, k) then result[k] = v end
      end
    elseif type(keys_or_callback) == 'table' then
      for k, v in pairs(obj) do
        if not utils.includes(keys_or_callback, k) then
          result[k] = v
        end
      end
    end

    return result
  end,

  -- Returns the value of the first item that satisfies the provided testing function.
  -- @param object {table}
  -- @param callback {table|function}
  -- @return {any}
  find = function(obj, callback)
    assert(Hash.is_hash(obj), 'find method expects a hash')

    for k, v in pairs(obj) do
      if callback(v, k) then return v end
    end

    return nil
  end,

  -- Creates a new table composed of the inverted keys and values of the table passed by parameter
  -- @param object {table}
  -- @return {table}
  invert = function(obj)
    assert(Hash.is_hash(obj), 'invert method expects a hash')

    local output = {}

    for k, v in pairs(obj) do
      output[v] = k
    end

    return output
  end,

  -- Checks if Hash has circular references
  -- @param object {table}
  -- @return {boolean}
  is_cyclic = function(obj)
    local seen = {}

    function verify(_obj)
      if type(_obj) == 'table' then
        if utils.includes(seen, _obj) then
          return true
        end

        table.insert(seen, _obj)

        for k, v in pairs(_obj) do
          if verify(v) then
            return true
          end
        end
      end

      return false
    end

    return verify(obj)
  end
}

return Hash
