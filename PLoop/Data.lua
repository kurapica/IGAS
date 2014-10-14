-- Author      : Kurapica
-- Create Date : 2014/10/13
-- ChangeLog   :

_ENV = Module "System.Data" "1.0.0"

import "System"

namespace "System.Data"

math.randomseed(os.time())

GUID_TEMPLTE = [[xx-x-x-x-xxx]]
GUID_FORMAT = "^" .. GUID_TEMPLTE:gsub("x", "%%x%%x%%x%%x"):gsub("%-", "%%-") .. "$"

function GenerateGUIDPart(v) return ("%04X"):format(math.random(0xffff)) end

struct "GUID" {
	function (value)
		if value == nil then
			return GUID_TEMPLTE:gsub("x", GenerateGUIDPart)
		elseif type(value) ~= "string" or #value ~= 36 or not value:match(GUID_FORMAT) then
			error("%s require data with format like '" .. GUID_TEMPLTE:gsub("x", GenerateGUIDPart) .."'.")
		end
	end
}

__AttributeUsage__{ AttributeTarget = AttributeTargets.Struct }
class "__DataTable__" (function(_ENV)
	inherit "__Attribute__"

	local function GetMain(self, value)
		local keys = self.MainKeys
		local cnt = #keys
		if cnt == 1 then
			return tostring(value[keys[1]])
		elseif cnt == 2 then
			return tostring(value[keys[1]]) .. "|" .. tostring(value[keys[2]])
		else
			local key = {}
			for _, mem in ipairs(keys) do tinsert(key, tostring(value[mem])) end
			return tblconcat(key, "|")
		end
	end

	local function GetIndex(self, value)
		local keys = self.IndexKeys
		if not keys then return nil end
		local cnt = #keys
		if cnt == 1 then
			return tostring(value[keys[1]])
		elseif cnt == 2 then
			return tostring(value[keys[1]]) .. "|" .. tostring(value[keys[2]])
		else
			local key = {}
			for _, mem in ipairs(keys) do tinsert(key, tostring(value[mem])) end
			return tblconcat(key, "|")
		end
	end

	-------------------------------------------
	-- Property
	-------------------------------------------
	__Doc__[[The data table's name]]
	property "Name" { Type = String + nil }

	__Doc__[[The database]]
	property "Source" { Type = Table + nil }

	__Doc__[[Whether all members will be used as data field]]
	property "IncludeAll" { Type = Boolean, Default = true }

	__Doc__[[The main keys of the data table]]
	property "MainKeys" { Type = Table + nil }

	__Doc__[[The index keys of the data table]]
	property "IndexKeys" { Type = Table + nil }

	-------------------------------------------
	-- Method
	-------------------------------------------
	function ApplyAttribute(self, target, targetType, owner, name)
		if Reflector.GetStructType(target) ~= "MEMBER" then
			error("Can't create datatable based on struct " .. tostring(target))
		end
		if not self.Name then self.Name = Reflector.GetNameSpaceName(target) end
		if not self.Source then self.Source = {} end

		-- Scan fields
		self.Fields = {}
		self.Members = {}
		self.MainKeys = self.MainKeys or {}

		local chkMainKey = #(self.MainKeys) == 0
		local members = Reflector.GetStructMembers(target)
		for _, mem in ipairs(members) do
			local field = __Attribute__._GetMemberAttribute(target, mem, __DataField__)
			if field or self.IncludeAll then
				tinsert(self.Fields, field and field.Name or mem)
				tinsert(self.Members, mem)
			end
			if chkMainKey and field and field.IsMainKey then tinsert(self.MainKeys, mem) end
		end

		-- Validating the MainKeys
		for i = #(self.MainKeys), 1, -1 do
			local find = false
			local key = self.MainKeys[i]
			for _, v in ipairs(members) do if v == key then find = true break end end
			if not find	then tremove(self.MainKeys, i) end
		end

		-- Using not-nil members as main key if no main keys
		if #(self.MainKeys) == 0 then
			for _, mem in ipairs(members) do
				local ty = Reflector.GetStructMember(target, mem)
				if ty and not ty.AllowNil then
					tinsert(self.MainKeys, mem)
				end
			end
		end

		-- Validating the IndexKeys
		if self.IndexKeys then
			for i = #(self.IndexKeys), 1, -1 do
				local find = false
				local key = self.IndexKeys[i]
				for _, v in ipairs(members) do if v == key then find = true break end end
				if not find	then tremove(self.IndexKeys, i) end
			end
		end

		target.Save = function (value)
			local index = GetMain(self, value)
			local dt = self.Source[index] or {}
			self.Source[index] = dt

			for i, mem in ipairs(self.Members) do
				dt[self.Fields[i]] = value[mem]
			end

			index = GetIndex(self, value)
			if index then
				self.Index = self.Index or {}
				self.Index[index] = dt
			end
		end

		target[Reflector.GetNameSpaceName(target)] = function (value)
			local index = GetMain(self, value)
			local dt = self.Source[index]

			if not dt then
				index = GetIndex(self, value)
				if index and self.Index then
					dt = self.Index[index]
				end
			end

			if dt then
				for i, mem in ipairs(self.Members) do
					value[mem] = dt[self.Fields[i]]
				end
			end
		end
	end

	-------------------------------------------
	-- Constructor
	-------------------------------------------
	__Arguments__{ String }
	function __DataTable__(self, name)
		Super(self)
		self.Name = name
	end

	function __call(self, value)
		if type(value) == "table" then
			if self.MainKeys then
				self.IndexKeys = value
			else
				self.MainKeys = value
			end
		elseif type(value) == "string" then
			self.Name = value
		end
		return self
	end
end)

__AttributeUsage__{ AttributeTarget = AttributeTargets.Member }
class "__DataField__" (function(_ENV)
	inherit "__Attribute__"

	-------------------------------------------
	-- Property
	-------------------------------------------
	__Doc__[[The data field]]
	property "Name" { Type = String + nil }

	__Doc__[[Whether the field is the main key]]
	property "IsMainKey" { Type = Boolean }

	-------------------------------------------
	-- Method
	-------------------------------------------
	function ApplyAttribute(self, target, targetType, owner, name)
		if not self.Name then self.Name = name end
	end

	-------------------------------------------
	-- Constructor
	-------------------------------------------
	__Arguments__{ String }
	function __DataField__(self, name)
		Super(self)
		self.Name = name
	end
end)
