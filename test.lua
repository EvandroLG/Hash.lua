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

test('is_hash should returns false when object is working as a array', function()
  assert_equal(false, Hash.is_hash({ 1, 3, 4 }))
end)

test('is_hash should returns false when a item in the table does not have key/value', function()
  assert_equal(false, Hash.is_hash( { a = 1, b = 2, 3 } ))
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
  local obj = { a=1, b=2 }
  assert_equal(true, Hash.remove_key(obj, 'b'))
  assert_equal(nil, obj.b)
end)

test('pick should return a table with keys passed in second parameter', function()
  local result = Hash.pick({ a=1, b=2, c=3 }, { 'a', 'c' })

  assert_equal(1, result.a)
  assert_equal(3, result.c)
  assert_equal(nil, result.b)
end)

test('pick should return a table accourding to callback match', function()
  local result = Hash.pick({ a=1, b=2, c=3 }, function(key, value)
    return key == 'a'
  end)

  assert_equal(1, result.a)
  assert_equal(nil, result.b)
  assert_equal(nil, result.c)
end)

test('map should return a table of values by mapping each value in table through a transformation function', function()
  local result = Hash.map({ a=1, b=2, c=3 }, function(value, key)
    return value * 2
  end)

  table.sort(result)

  assert_equal(3, #result)
  assert_equal(2, result[1])
  assert_equal(4, result[2])
  assert_equal(6, result[3])
end)
