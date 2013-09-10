Loop
====

Lua object-oriented program system, also with a special syntax keyword system. Now, it only works for Lua 5.1. Since the 'getfenv', 'setfenv', 'newproxy' api is removed from Lua 5.2, the system won't works on it now.


How to use
====

Use loadfile or require to load the class.lua file in the folder. Then you can try the below code:

	do
		-- Define a class
		class "MyClass"
			function Greet(self, name)
				print("Hello " .. name .. ", My name is " .. self.Name)
			end

			property "Name" {
				Storage = "_Name",     -- The real field that used to store the value, explain later
				Type = System.String,  -- the property's type used to validate the value,
									   -- System.Sting means the value should be a string, also explain later.
			}
		endclass "MyClass"
	end

Now we create a class with a 'Greet' method and a 'Name' property. Then we can use it like :

	do
		-- Create the class's object, also with init settings, the init table can contains properties settings
		-- and many more settings in it, will be explained later.
		ob = MyClass{ Name = "Kurapica" }

		-- Call the object's method, you should get : Hello Ann, My name is Kurapica
		ob:Greet("Ann")

		-- Property settings, 123 is not a string, so the code failed with message : stdin:10: Name must be a string, got number.
		ob.Name = 123
	end

Here I use 'do ... end' because you may try those code in an interactive programming environment, many definitions like class, struct, interface's definitions should be kept in one piece. After here, I'll not use 'do ... end' again, but just remember to add it yourself.


Features
====

There are some keywords that released into the _G :

* namespace
* import
* enum
* struct
* class
* partclass
* interface
* partinterface
* Module

The 'namespace' & 'import' are used to control the namespace system used to store classes, interfaces, structs and enums.

The 'enum' is used to define an enum type.

The 'struct' is used to start the definition of a struct type. A data of a struct type, is a normal table in lua, without metatable settings or basic lua type data like string, number, thread, function, userdata, boolean. The struct types are used to validate or create the values that follow the explicitly structure that defined in the struct types.

The 'class' & 'partclass' are used to start the definition of a class. In an object-oriented system, the core part is the objects. One object should have methods that used to tell it do some jobs, also would have properties to store the data used to mark the object's state. A class is an abstract of objects, and can be used to create objects with the same properties and methods settings.

The 'interface' & 'partinterface' are used to start the definition of an interface. Sometimes we may not know the true objects that our program will manipulate, or we want to manipulate objects from different classes, we only want to make sure the objects will have some features that our program needs, like we may need every objects have a 'Name' property to used to show all objects's name. So, the interface is bring in to provide such features. Define an interface is the same like define a class, but no objects can be created from an interface.

The 'Module' is used to start a standalone environment with version check, and make the development with the lua-oop system more easily. This topic will be discussed at last.


namespace & import
====

In an oop project, there would be hundred or thousand classes or other data types to work together, it's important to manage them in groups. The namespace system is bring in to store the classes and other features.

In the namespace system, we can access those features like classes, interfaces, structs with a path string.

A full path looks like 'System.Forms.EditBox', a combination of words separated by '.', in the example, 'System', 'System.Forms' and 'System.Forms.EditBox' are all namespaces, the namespace can be a pure namespace used only to contains other namespaces, but also can be classes, interfaces, structs or enums, only eums can't contains other namespaces.


The 'import' function is used to save the target namespace into current environment, the 1st paramter is a string that contains the full path of the target namespace, so we can share the classes and other features in many lua environments, the 2nd paramter is a boolean, if true, then all the sub-namespace of the target will be saved to the current environment too.

    import (name[, all])


If you already load the class.lua, you can try some example :

	import "System"  -- Short for import( "System" ), just want make it looks like a keyword

	print( System )          -- Output : System
	print( System.Object )   -- Output : System.Object
	print( Object )          -- Output : nil

	import ( "System", true )

	print( Object )          -- Output : System.Object

The System is a root namespace defined in the class.lua file, some basic features are defined in the namespace, such like 'System.Object', used as the super class of other classes.

Also you can see, 'Object' is a sub-namespace in 'System', we can access it just like a field in the 'System'.


The 'namespace' function is used to declare a default namespace for the current environment, so any classes, interfaces, structs and enums that defined after it, will be stored in the namespace as sub-namespaces.

	namespace (name)

Here a simple example, we can see :

	namespace "MySpace.Example"  -- Decalre a new namespace for the current environment

	class "NewClass"             -- The class also be stored in current environment when defined.
	endclass "NewClass"

	print( NewClass )            -- Output : MySpace.Example.NewClass

The namespace system is used to share features like class, if you don't declare a namespace for the environment, those features that defined later will be private.


enum
====

enum is used to defined new value types with enumerated values, normally it would be used as the property's type, and when the object's property is changed, it'll be used to validate the new value.

Here is an example to show how to use create a new enum type :

	do
		import "System"

		-- enum "name" should return a function to receive a table as the enumerated value list
		-- For each key-value in the list, if the key is a string, the key is used as the enumerated field,
		-- if the key is a number and the value is a string, the value is used as the enumerated field
		enum "Day" {
			SUNDAY = 0,
			MONDAY = 1,
			TUESDAY = 2,
			WEDNESDAY = 3,
		    THURSDAY = 4,
		    FRIDAY = 5,
		    SATURDAY = 6,
		    "None",
		}

		-- Use it, all print '0', so the case is ignored for enumerated field
		print(Day.sunday)
		print(Day.Sunday)
		print(Day.sundDay)

		-- print 'None'
		print(Day.none)

		-- get field from value, print 'WEDNESDAY'
		-- The System.Reflector is an interface that contains many functions to get detail of the oop system
		-- will be explained later
		print(System.Reflector.ParseEnum(Day, 3))
	end


struct
====

Lua's table has no limit, but if we have a texture widget to show colors, we may like a 'Color' property for the texture object to change it's color. To make sure the value is validated, struct system is bring in to validate and generate the expected tables.

First, in the System namespace, there are several basic struct types used to validate base value types in lua :

* System.Boolean - The value should be changed to true or false, no validation
* System.String  - means the value should match : type(value) == "string"
* System.Number  - means the value should match : type(value) == "number"
* System.Function  - means the value should match : type(value) == "function"
* System.Table  - means the value should match : type(value) == "table"
* System.Userdata  - means the value should match : type(value) == "userdata"
* System.Thread  - means the value should match : type(value) == "thread"

Define a struct value type is very simple, now we define a file struct, with two field : 'name' for the file name, 'version' for the file version. The name only should be a string, and a file must have a name, the version can be string or number, and also can be nil.

	do
		struct "File"
			import "System"

			name = String
			version = String + Number + nil
		endstruct "File"
	end

Here is the explain :



Let's have some test :

	f1 = File()	-- Error : stdin:1: Usage : File(name, [version]) - name must be a string, got nil.

	f1 = File("Test.lua", File)  -- Error : stdin:1: Usage : File(name, [version]) - version must be a string, got userdata.(Optional)

	f1 = File("Test.lua", 123)
	print(f1.name .. " : " .. f1.version)   -- Print : Test.lua : 123


















