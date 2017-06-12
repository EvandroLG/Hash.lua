# Hash.lua

Library with useful methods to handle a Lua's table when it's working as a Hash.

## Installation
To install Hash.lua, run:
```sh
$ luarocks install hash
```

Or simply copy the Hash.lua file and paste in your project :)

## Methods
* Hash.<code>copy(object:table):table</code><br />
Makes a shallow copy of the table passed by parameter.

* Hash.<code>deep_copy(object:table):table</code><br />
Makes a deep copy of the table passed by parameter.

* Hash.<code>each(object:table, callback:function):nil</code><br />
Iterates over a table, yielding each in turn to an iteratee function.

* Hash.<code>is_empty(object:table):boolean</code><br />
Checks if the table is empty.

* Hash.<code>is_hash(object:table):boolean</code><br />
Checks if the table is a Hash.

* Hash.<code>keys(object:table):table</code><br />
Returns a new table populated with the all keys from the table passed as parameter.

* Hash.<code>map(object:table, [callback:function]):table</code><br />
Returns a new table of values by mapping each value in table through a transformation function.

* Hash.<code>merge(object1:table, object2:table):table</code><br />
Returns a new table containing the contents of *object1* and *object2*.

* Hash.<code>pick(object:table, [keys:table|callback:function]):table</code><br />
Returns a new table filtered only with values for the keys passed by parameter. Alternatively it accepts a callback where you can filter which keys to pick.

* Hash.<code>remove_key(object:table, key:string):boolean</code><br />
Removes the key from the table; returns true if it was found and removed, otherwise it returns false.

* Hash.<code>values(object:table):table</code><br />
Returns a new table populated with the all values from the table passed as paramter.
