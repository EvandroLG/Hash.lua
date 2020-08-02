local Hash = require 'Hash'
local test = require 'simple_test'

test('is_hash', function(a)
  a.ok(Hash.is_hash({ a = 1, b = 2, c = 3 }))
  a.not_ok(Hash.is_hash('lua'))
  a.ok(Hash.is_hash({}))
end)

test('is_empty', function(a)
  a.ok(Hash.is_empty({}))
  a.not_ok(Hash.is_empty({ a = 1 }))
  a.not_ok(Hash.is_empty({ 1, 2, 3 }))
end)

test('keys', function(a)
  local result = Hash.keys({ a = 1, b = 2, c = 3 })

  a.equal(3, #result)
  table.sort(result)
  a.equal('a', result[1])
  a.equal('b', result[2])
  a.equal('c', result[3])
end)

test('values', function(a)
  local result = Hash.values({ a = 10, b = 20, c = 30 })

  a.equal(3, #result)
  table.sort(result)
  a.equal(10, result[1])
  a.equal(20, result[2])
  a.equal(30, result[3])
end)

test('remove_key', function(a)
  local obj = { a=1, b=2, c=false }

  a.ok(Hash.remove_key(obj, 'b'))
  a.equal(nil, obj.b)

  a.ok(true, Hash.remove_key(obj, 'c'))
  a.equal(nil, obj.c)

  a.not_ok(Hash.remove_key({ a=1 }, 'b'))
end)

test('pick', function(a)
  a.deep_equal(
    Hash.pick({ a=1, b=2, c=3 }, { 'a', 'c' }),
    { ['a'] = 1, ['b'] = nil, ['c'] = 3 }
  )

  a.deep_equal(
    Hash.pick({ a=1, b=2, c=3 }, function(key, value)
      return key == 'a'
    end),
    { ['a'] = 1, ['b'] = nil, ['c'] = nil }
  )
end)

test('map', function(a)
  local result = Hash.map({ a=1, b=2, c=3 }, function(value, key)
    return value * 2
  end)

  table.sort(result)

  a.equal(3, #result)
  a.equal(2, result[1])
  a.equal(4, result[2])
  a.equal(6, result[3])
end)

test('copy', function(a)
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

test('deep_copy', function(a)
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

test('merge', function(a)
  local result = Hash.merge({ name = 'lua', year = 1992 },
                            { year = 1993, influences = { 'lisp', 'c++', 'awk' } })

  a.equal('lua', result.name)
  a.equal(1993, result.year)
  a.equal(3, #result.influences)
  a.equal('lisp', result.influences[1])
  a.equal('c++', result.influences[2])
  a.equal('awk', result.influences[3])
end)

test('each', function(a)
  local result = {}
  Hash.each({ a=1, b=2, c=3 }, function(k, v)
    result[k] = v
  end)

  a.equal(1, result.a)
  a.equal(2, result.b)
  a.equal(3, result.c)
end)

test('size', function(a)
  a.equal(
    Hash.size({ ['Lua'] = true, ['Ruby'] = true, ['JavaScript'] = true, ['Python'] = true }),
    4
  )

  a.equal(
    Hash.size({}),
    0
  )
end)

test('omit', function(a)
  local obj = {
    language = 'Lua',
    version = '5.4.0',
    creation_date = 1993,
    paradigms = { 'procedural', 'functional', 'object-oriented' }
  }

  a.deep_equal(
    Hash.omit(
      obj,
      { 'version', 'creation_date' }
    ),
    { language = 'Lua', paradigms = { 'procedural', 'functional', 'object-oriented' } }
  )

  a.deep_equal(
    Hash.omit(
      obj,
      function(v) return type(v) == 'number' end
    ),

    { creation_date = 1993 }
  )
end)

test('find', function(a)
  local users = {
    {
      user = 'evandrolg',
      age = 33,
      active = true,
    },

    {
      user = 'dan_abramov',
      age = 30,
      active = true,
    },

    {
      user = 'hswolff',
      age = 35,
      active = false,
    }
  }

  a.deep_equal(
    Hash.find(users, function(o) return o.active end),
    {
      user = 'evandrolg',
      age = 33,
      active = true,
    }
  )

  a.deep_equal(
    Hash.find(users, function(o) return not o.active end),
    {
      user = 'hswolff',
      age = 35,
      active = false,
    }
  )

  a.equal(
    Hash.find(users, function(o) return o.age > 35 end),
    nil
  )
end)
