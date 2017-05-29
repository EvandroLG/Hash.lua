local function is_table(obj)
  return type(obj) == 'table'
end

local function has_key(obj)
  for _ in pairs(obj) do
    return true
  end

  return false
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
    if not is_table(obj) then return false end

    local i = 0

    for _ in pairs(obj) do
      i = i + 1
      if obj[i] ~= nil then return false end
    end

    return true
  end,

  is_empty = function(obj)
    return Hash.is_hash(obj) and not has_key(obj)
  end,

  keys = function(obj)
    local output = {}

    for key in pairs(obj) do
      table.insert(output, key)
    end

    return output
  end,

  values = function(obj)
    local output = {}

    for key, value in pairs(obj) do
      table.insert(output, value)
    end

    return output
  end,

  pick = function(obj, keys)
  end,
}

return Hash
