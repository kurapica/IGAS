-- Author      : Kurapica
-- Create Date : 2012/06/28
-- Change Log  :

-- Check Version
local version = 4
if not IGAS:NewAddon("IGAS.Widget.IFMovableResizable", version) then
	return
end

----------------------------------------------------------
-- Manage Functions
----------------------------------------------------------
do
	_Global = "Global"

	_GroupListMovable = _GroupListMovable or setmetatable({},
		{
			__index = function(self, group)
				group = tostring(group or _Global):upper()

				if not rawget(self, group) then
					rawset(self, group, setmetatable({}, _WeakMode))
				end

				return rawget(self, group)
			end,
			__call = function(self, group)
				group = tostring(group or _Global):upper()

				return rawget(self, group)
			end,
		}
	)

	_GroupListResizable = _GroupListResizable or setmetatable({}, getmetatable(_GroupListMovable))

	_IFMovable_ModeOn = _IFMovable_ModeOn or {}
	_IFResizable_ModeOn = _IFResizable_ModeOn or {}

	_IFMaskParent = Frame("IGAS_IFMovableResizable_Mask")
	_IFMaskParent.Visible = false

	_IFMask_Recycle = _IFMask_Recycle or Recycle(Mask, "IFMovableResizable_Mask_%d", _IFMaskParent)

	function _IFMask_Recycle:OnPush(mask)
		mask.Parent = _IFMaskParent
		mask.Visible = false
	end

	function _IFMask_Recycle:OnInit(mask)
		mask.OnMoveStarted = Mask_OnMoveStarted
		mask.OnResizeStarted = Mask_OnResizeStarted
		mask.OnMoveFinished = Mask_OnMoveFinished
		mask.OnResizeFinished = Mask_OnResizeFinished
	end

	function Mask_OnMoveStarted(self)
		self.Parent:BlockScript("OnPositionChanged", "OnSizeChanged")
	end

	function Mask_OnResizeStarted(self)
		self.Parent:BlockScript("OnPositionChanged", "OnSizeChanged")
	end

	function Mask_OnMoveFinished(self)
		self.Parent:UnBlockScript("OnPositionChanged", "OnSizeChanged")
		self.Parent:Fire("OnPositionChanged")
	end

	function Mask_OnResizeFinished(self)
		self.Parent:UnBlockScript("OnPositionChanged", "OnSizeChanged")
		self.Parent:Fire("OnSizeChanged")
	end

	function _MaskOn(IF, group)
		group = tostring(group or _Global):upper()

		local lst

		if IF == IFMovable then
			lst = _GroupListMovable(group)
			_IFMovable_ModeOn[group] = true
		elseif IF == IFResizable then
			lst = _GroupListResizable(group)
			_IFResizable_ModeOn[group] = true
		end

		if not lst or not next(lst) then
			return
		end

		local cnt = 1
		local needMask

		for frm in pairs(lst) do
			-- Check if item no need move or resize
			if IF == IFMovable then
				needMask = frm.IFMovable
			elseif IF == IFResizable then
				needMask = frm.IFResizable
			end

			if needMask then
				if not frm.__IFMovableResizable_Mask then
					frm.__IFMovableResizable_Mask = _IFMask_Recycle()

					frm.__IFMovableResizable_Mask.Parent = frm
					frm.__IFMovableResizable_Mask.ParentVisible = frm.Visible
				end

				if IF == IFMovable then
					frm.__IFMovableResizable_Mask.AsMove = true
				elseif IF == IFResizable then
					frm.__IFMovableResizable_Mask.AsResize = true
				end

				frm.Visible = true
				frm.__IFMovableResizable_Mask.Visible = true
			end
		end
	end

	function _MaskOff(IF, group)
		group = tostring(group or _Global):upper()

		if _UsingMask then
			error("Can't turn off mode when mouse is down", 3)
		end

		local lst

		if IF == IFMovable then
			lst = _GroupListMovable(group)
			_IFMovable_ModeOn[group] = nil
		elseif IF == IFResizable then
			lst = _GroupListResizable(group)
			_IFResizable_ModeOn[group] = nil
		end

		if not lst or not next(lst) then
			return
		end

		local mask

		for frm in pairs(lst) do
			mask = frm.__IFMovableResizable_Mask
			if mask then
				if IF == IFMovable then
					mask.AsMove = false
				elseif IF == IFResizable then
					mask.AsResize = false
				end

				if not mask.AsMove and not mask.AsResize then
					frm.Visible = mask.ParentVisible
					frm.__IFMovableResizable_Mask = nil
					_IFMask_Recycle(mask)
				end
			end
		end
	end

	function _MaskToggle(IF, group)
		group = tostring(group or _Global):upper()
		local on

		if IF == IFMovable then
			on = _IFMovable_ModeOn[group]
		elseif IF == IFResizable then
			on = _IFResizable_ModeOn[group]
		end
		if on then
			_MaskOff(IF, group)
		else
			_MaskOn(IF, group)
		end
	end
end

----------------------------------------------------------
--- IFMovable
-- @type Interface
-- @name IFMovable
----------------------------------------------------------
interface "IFMovable"
	------------------------------------------------------
	-- Script
	------------------------------------------------------
	------------------------------------
	--- ScriptType, Run when the object is moved by cursor
	-- @name OnPositionChanged
	-- @type script
	-- @usage function obj:OnPositionChanged()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnPositionChanged"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Start move registered Object
	-- @name _ModeOn
	-- @class function
	-- @param group group name
	-- @usage IFMovable._ModeOn("Unit")
	------------------------------------
	function _ModeOn(group)
		return _MaskOn(IFMovable, group)
	end

	------------------------------------
	--- Stop move registered Object
	-- @name _ModeOff
	-- @class function
	-- @param group group name
	-- @usage IFMovable._ModeOff("Unit")
	------------------------------------
	function _ModeOff(group)
		return _MaskOff(IFMovable, group)
	end

	------------------------------------
	--- Check if the group is mode on
	-- @name _IsModeOn
	-- @type function
	-- @param group group name
	-- @return true if the mode is on
	------------------------------------
	function _IsModeOn(group)
		group = tostring(group or _Global):upper()
		return _IFMovable_ModeOn[group]
	end

	------------------------------------
	--- Toggle the mode
	-- @name _Toggle
	-- @type function
	-- @param group group name
	-- @usage IFMovable._Toggle("Unit")
	------------------------------------
	function _Toggle(group)
		_MaskToggle(IFMovable, group)
	end

	------------------------------------
	--- Get all group name
	-- @name _GetGroupList
	-- @class function
	-- @return group name list
	-- @usage IFMovable._GetGroupList()
	------------------------------------
	function _GetGroupList()
		local ret = {}

		for grp in pairs(_GroupListMovable) do
			tinsert(ret, grp)
		end

		sort(ret)

		return ret
	end

	------------------------------------
	--- Remove item
	-- @name Dispose
	-- @type function
	------------------------------------
	function Dispose(self)
		_GroupListMovable[self.IFMovingGroup][self] = nil
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- IFMovingGroup
	property "IFMovingGroup" {
		Get = function(self)
			return _Global
		end,
	}
	-- IFMovable
	property "IFMovable" {
		Get = function(self)
			return not self.__IFMovable_Block
		end,
		Set = function(self, value)
			self.__IFMovable_Block = not value or nil
		end,
		Type = System.Boolean,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFMovable(self)
		if Reflector.ObjectIsClass(self, Region) then
			_GroupListMovable[self.IFMovingGroup][self] = true
		end
	end
endinterface "IFMovable"

----------------------------------------------------------
--- IFResizable
-- @type Interface
-- @name IFResizable
----------------------------------------------------------
interface "IFResizable"
	------------------------------------------------------
	-- Script
	------------------------------------------------------
	------------------------------------
	--- ScriptType, Run when a frame's size changes
	-- @name OnSizeChanged
	-- @type script
	-- @usage function obj:OnSizeChanged()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnSizeChanged"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Start resize registered Object
	-- @name _ModeOn
	-- @class function
	-- @param group group name
	-- @usage IFResizingGroup._ModeOn("Unit")
	------------------------------------
	function _ModeOn(group)
		return _MaskOn(IFResizable, group)
	end

	------------------------------------
	--- Stop resize registered Object
	-- @name _ModeOff
	-- @class function
	-- @param group group name
	-- @usage IFResizingGroup._ModeOff("Unit")
	------------------------------------
	function _ModeOff(group)
		return _MaskOff(IFResizable, group)
	end

	------------------------------------
	--- Check if the group is mode on
	-- @name _IsModeOn
	-- @type function
	-- @param group group name
	-- @return true if the mode is on
	------------------------------------
	function _IsModeOn(group)
		group = tostring(group or _Global):upper()
		return _IFResizable_ModeOn[group]
	end

	------------------------------------
	--- Toggle the mode
	-- @name _Toggle
	-- @type function
	-- @param group group name
	-- @usage IFResizable._Toggle("Unit")
	------------------------------------
	function _Toggle(group)
		_MaskToggle(IFResizable, group)
	end

	------------------------------------
	--- Get all group name
	-- @name _GetGroupList
	-- @class function
	-- @return group name list
	-- @usage IFResizingGroup._GetGroupList()
	------------------------------------
	function _GetGroupList()
		local ret = {}

		for grp in pairs(_GroupListResizable) do
			tinsert(ret, grp)
		end

		sort(ret)

		return ret
	end

	------------------------------------
	--- Remove item
	-- @name Dispose
	-- @type function
	------------------------------------
	function Dispose(self)
		_GroupListResizable[self.IFResizingGroup][self] = nil
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- IFResizingGroup
	property "IFResizingGroup" {
		Get = function(self)
			return _Global
		end,
	}
	-- IFResizable
	property "IFResizable" {
		Get = function(self)
			return not self.__IFResizable_Block
		end,
		Set = function(self, value)
			self.__IFResizable_Block = not value or nil
		end,
		Type = System.Boolean,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFResizable(self)
		if Reflector.ObjectIsClass(self, Region) then
			_GroupListResizable[self.IFResizingGroup][self] = true
		end
	end
endinterface "IFResizable"