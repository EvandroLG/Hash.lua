local Hash = require 'Hash'
local test = require 'simple_test'

test('is_hash should returns false when object is not a table', function(a)
  a.not_ok(Hash.is_hash('lua'))
end)

test('is_hash should returns true when table is empty', function(a)
  a.ok(Hash.is_hash({}))
end)

test('is_hash should returns true when table is working as a hash', function(a)
  a.ok(Hash.is_hash({ a = 1, b = 2, c = 3 }))
end)

test('is_empty should returns false when table is working as an array', function(a)
  a.not_ok(Hash.is_empty({ 1, 2, 3 }))
end)

test('is_empty should returns false when table have at least a key/value', function(a)
  a.not_ok(Hash.is_empty({ a = 1 }))
end)

test('is_empty should returns true when table do not have any content', function(a)
  a.ok(Hash.is_empty({}))
end)

test('keys should returns a table with all keys of the hash', function(a)
  local result = Hash.keys({ a = 1, b = 2, c = 3 })

  a.equal(3, #result)
  table.sort(result)
  a.equal('a', result[1])
  a.equal('b', result[2])
  a.equal('c', result[3])
end)

test('values should returns a table with all values of the hash', function(a)
  local result = Hash.values({ a = 10, b = 20, c = 30 })

  a.equal(3, #result)
  table.sort(result)
  a.equal(10, result[1])
  a.equal(20, result[2])
  a.equal(30, result[3])
end)

test('remove_key should returns false because key does not exist', function(a)
  a.not_ok(Hash.remove_key({ a=1 }, 'b'))
end)

test('remove_key should returns true and remove key from table', function(a)
  local obj = { a=1, b=2, c=false }

  a.ok(Hash.remove_key(obj, 'b'))
  a.equal(nil, obj.b)

  a.ok(true, Hash.remove_key(obj, 'c'))
  a.equal(nil, obj.c)
end)

test('pick should returns a table with keys passed in second parameter', function(a)
  local result = Hash.pick({ a=1, b=2, c=3 }, { 'a', 'c' })

  a.equal(1, result.a)
  a.equal(3, result.c)
  a.equal(nil, result.b)
end)

test('pick should returns a table accourding to callback match', function(a)
  local result = Hash.pick({ a=1, b=2, c=3 }, function(key, value)
    return key == 'a'
  end)

  a.equal(1, result.a)
  a.equal(nil, result.b)
  a.equal(nil, result.c)
end)

test('map should returns a table of values by mapping each value in table through a transformation function', function(a)
  local result = Hash.map({ a=1, b=2, c=3 }, function(value, key)
    return value * 2
  end)

  table.sort(result)

  a.equal(3, #result)
  a.equal(2, result[1])
  a.equal(4, result[2])
  a.equal(6, result[3])
end)

test('copy should returns a new table with the same proprieties of the object passed as parameter', function(a)
  local obj = {
    language = 'lua',
    year = 1993,
    influences = { languages = { 'lisp', 'smalltalk', 'c++', 'awk' } },
  }

  local result = Hash.copy(obj)

  a.equal('lua', result.language)
  a.equal(1993, result.year)
  a.equal('table', type(result.influences))
  a.equal(4, #result.influences.languages)
  a.equal('lisp', result.influences.languages[1])
  a.equal('smalltalk', result.influences.languages[2])
  a.equal('c++', result.influences.languages[3])
  a.equal('awk', result.influences.languages[4])
  obj.influences.languages[1] = 'scheme'
  a.equal('scheme', result.influences.languages[1])
end)

test('deep_copy should returns a new table with the same proprieties of the object passed as parameter using deep algorithm', function(a)
  local obj = {
    language = 'lua',
    year = 1993,
    influences = { languages = { 'lisp', 'smalltalk', 'c++', 'awk' } },
  }

  local result = Hash.deep_copy(obj)

  a.equal('lua', result.language)
  a.equal(1993, result.year)
  a.equal('table', type(result.influences))
  a.equal(4, #result.influences.languages)
  a.equal('lisp', result.influences.languages[1])
  a.equal('smalltalk', result.influences.languages[2])
  a.equal('c++', result.influences.languages[3])
  a.equal('awk', result.influences.languages[4])
  obj.influences.languages[1] = 'scheme'
  a.equal('lisp', result.influences.languages[1])
end)

test('merge should returns a new table contaiining the contents from obj2 and the contents of obje1', function(a)
  local result = Hash.merge({ name = 'lua', year = 1992 },
                            { year = 1993, influences = { 'lisp', 'c++', 'awk' } })

  a.equal('lua', result.name)
  a.equal(1993, result.year)
  a.equal(3, #result.influences)
  a.equal('lisp', result.influences[1])
  a.equal('c++', result.influences[2])
  a.equal('awk', result.influences[3])
end)

test('each should calls the function once for every key in table, passing key and value as parameters', function(a)
  local result = {}
  Hash.each({ a=1, b=2, c=3 }, function(k, v)
    result[k] = v
  end)

  a.equal(1, result.a)
  a.equal(2, result.b)
  a.equal(3, result.c)
end)
