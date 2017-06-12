local Hash = require 'Hash'
local format = string.format

function test(name, func)
  xpcall(function()
    func()
    print(format('[pass] %s', name))
  end, function(err)
    print(format('[fail] %s : %s', name, err))
  end)
end

function _equal(a, b)
  return a == b
end

function assert_equal(a, b)
  assert(_equal(a, b))
end

test('is_hash should returns false when object is not a table', function()
  assert_equal(false, Hash.is_hash('lua'))
end)

test('is_hash should returns true when table is empty', function()
  assert_equal(true, Hash.is_hash({}))
end)

test('is_hash should returns true when table is working as a hash', function()
  assert_equal(true, Hash.is_hash({ a = 1, b = 2, c = 3 }))
end)

test('is_empty should returns false when table is working as an array', function()
  assert_equal(false, Hash.is_empty({ 1, 2, 3 }))
end)

test('is_empty should returns false when table have at least a key/value', function()
  assert_equal(false, Hash.is_empty({ a = 1 }))
end)

test('is_empty should returns true when table do not have any content', function()
  assert_equal(true, Hash.is_empty({}))
end)

test('keys should returns a table with all keys of the hash', function()
  local result = Hash.keys({ a = 1, b = 2, c = 3 })

  assert_equal(3, #result)
  table.sort(result)
  assert_equal('a', result[1])
  assert_equal('b', result[2])
  assert_equal('c', result[3])
end)

test('values should returns a table with all values of the hash', function()
  local result = Hash.values({ a = 10, b = 20, c = 30 })

  assert_equal(3, #result)
  table.sort(result)
  assert_equal(10, result[1])
  assert_equal(20, result[2])
  assert_equal(30, result[3])
end)

test('remove_key should returns false because key does not exist', function()
  assert_equal(false, Hash.remove_key({ a=1 }, 'b'))
end)

test('remove_key should returns true and remove key from table', function()
  local obj = { a=1, b=2, c=false }

  assert_equal(true, Hash.remove_key(obj, 'b'))
  assert_equal(nil, obj.b)

  assert_equal(true, Hash.remove_key(obj, 'c'))
  assert_equal(nil, obj.c)
end)

test('pick should returns a table with keys passed in second parameter', function()
  local result = Hash.pick({ a=1, b=2, c=3 }, { 'a', 'c' })

  assert_equal(1, result.a)
  assert_equal(3, result.c)
  assert_equal(nil, result.b)
end)

test('pick should returns a table accourding to callback match', function()
  local result = Hash.pick({ a=1, b=2, c=3 }, function(key, value)
    return key == 'a'
  end)

  assert_equal(1, result.a)
  assert_equal(nil, result.b)
  assert_equal(nil, result.c)
end)

test('map should returns a table of values by mapping each value in table through a transformation function', function()
  local result = Hash.map({ a=1, b=2, c=3 }, function(value, key)
    return value * 2
  end)

  table.sort(result)

  assert_equal(3, #result)
  assert_equal(2, result[1])
  assert_equal(4, result[2])
  assert_equal(6, result[3])
end)

test('copy should returns a new table with the same proprieties of the object passed as parameter', function()
  local obj = {
    language = 'lua',
    year = 1993,
    influences = { languages = { 'lisp', 'smalltalk', 'c++', 'awk' } },
  }

  local result = Hash.copy(obj)

  assert_equal('lua', result.language)
  assert_equal(1993, result.year)
  assert_equal('table', type(result.influences))
  assert_equal(4, #result.influences.languages)
  assert_equal('lisp', result.influences.languages[1])
  assert_equal('smalltalk', result.influences.languages[2])
  assert_equal('c++', result.influences.languages[3])
  assert_equal('awk', result.influences.languages[4])
  obj.influences.languages[1] = 'scheme'
  assert_equal('scheme', result.influences.languages[1])
end)

test('deep_copy should returns a new table with the same proprieties of the object passed as parameter using deep algorithm', function()
  local obj = {
    language = 'lua',
    year = 1993,
    influences = { languages = { 'lisp', 'smalltalk', 'c++', 'awk' } },
  }

  local result = Hash.deep_copy(obj)

  assert_equal('lua', result.language)
  assert_equal(1993, result.year)
  assert_equal('table', type(result.influences))
  assert_equal(4, #result.influences.languages)
  assert_equal('lisp', result.influences.languages[1])
  assert_equal('smalltalk', result.influences.languages[2])
  assert_equal('c++', result.influences.languages[3])
  assert_equal('awk', result.influences.languages[4])
  obj.influences.languages[1] = 'scheme'
  assert_equal('lisp', result.influences.languages[1])
end)

test('merge should returns a new table contaiining the contents from obj2 and the contents of obje1', function()
  local result = Hash.merge({ name = 'lua', year = 1992 },
                            { year = 1993, influences = { 'lisp', 'c++', 'awk' } })

  assert_equal('lua', result.name)
  assert_equal(1993, result.year)
  assert_equal(3, #result.influences)
  assert_equal('lisp', result.influences[1])
  assert_equal('c++', result.influences[2])
  assert_equal('awk', result.influences[3])
end)

test('each should calls the function once for every key in table, passing key and value as parameters', function()
  local result = {}
  Hash.each({ a=1, b=2, c=3 }, function(k, v)
    result[k] = v
  end)

  assert_equal(1, result.a)
  assert_equal(2, result.b)
  assert_equal(3, result.c)
end)
