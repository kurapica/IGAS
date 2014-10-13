-- Author      : Kurapica
-- Create Date : 2014/10/13
-- ChangeLog   :

_ENV = Module "System.Data" "1.0.0"

import "System"

namespace "System.Data"

math.randomseed(os.time())

__StructType__ "Custom"
struct "GUID" {
	GUID = function (value)
		if value == nil then
			value = ""
			for i = 1, 8 do
				value = value .. ("%04X"):format(math.random(0xffff))
				if i > 1 and i < 6 then value = value .. "-" end
			end
			return value
		elseif type(value) ~= "string" or #value ~= 36 or not value:match"^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$" then
			error("%s require data with format like '638D587F-EBED-AC35-0789-7D6DEF095FBF'.")
		end
	end
}

_DataBase = {}
_DataTableMap = {}

__AttributeUsage__{ AttributeTarget = AttributeTargets.Struct, RunOnce = true }
class "__DataTable__"
	inherit "__Attribute__"

	property "Name" { Type = String + nil }

	function ApplyAttribute(self, target, targetType, owner, name)
		local name = self.Name or Reflector.GetNameSpaceName(target)
		if Reflector.GetStructType(target) ~= "MEMBER" then
			print("Can't create datatable based on struct " .. target)
			return
		end

		_DataBase[name] = {}
		_DataTableMap[target] = _DataTableMap[target] or { Owner = target }
		_DataTableMap[target].Name = name
	end

	__Arguments__ { String }
	function __DataTable__(self, name)
		Super(self)
		self.Name = name
	end
endclass "__DataTable__"

__AttributeUsage__{ AttributeTarget = AttributeTargets.Struct, RunOnce = true }
class "__MainKey__"
	inherit "__Attribute__"

	function ApplyAttribute(self, target, targetType, owner, name)
		if Reflector.GetStructType(target) ~= "MEMBER" then
			print("Can't create datatable based on struct " .. tostring(target))
			return
		end

		_DataTableMap[target] = _DataTableMap[target] or { Owner = target }

		local members = Reflector.GetStructMembers(target)
		if members then
			for _, mem in ipairs(members) do
				members[mem] = true
			end

			for _, v in ipairs(self) do
				if members[v] then
					_DataTableMap[target].MainKey = _DataTableMap[target].MainKey or {}
					table.insert(_DataTableMap[target].MainKey, v)
				end
			end
		end

		if not _DataTableMap[target].MainKey or #(_DataTableMap[target].MainKey) == 0 then
			print("No main key is defined")
		end
	end

	__Arguments__ { String }
	function __MainKey__(self, name)
		Super(self)
		table.insert(self, name)
	end

	function __call(self, key)
		if type(key) == "string" then
			table.insert(self, key)
		end
		return self
	end
endclass "__MainKey__"