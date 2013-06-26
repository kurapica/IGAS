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
		self.Parent:BlockEvent("OnPositionChanged", "OnSizeChanged")
	end

	function Mask_OnResizeStarted(self)
		self.Parent:BlockEvent("OnPositionChanged", "OnSizeChanged")
	end

	function Mask_OnMoveFinished(self)
		self.Parent:UnBlockEvent("OnPositionChanged", "OnSizeChanged")
		self.Parent:Raise("OnPositionChanged")
	end

	function Mask_OnResizeFinished(self)
		self.Parent:UnBlockEvent("OnPositionChanged", "OnSizeChanged")
		self.Parent:Raise("OnSizeChanged")
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

interface "IFMovable"
	doc [======[
		@name IFMovable
		@type interface
		@desc IFMovable provide a frame moving system
	]======]

	------------------------------------------------------
	-- Event
	------------------------------------------------------
	doc [======[
		@name OnPositionChanged
		@type event
		@desc Fired when the object is moved by cursor
	]======]
	event "OnPositionChanged"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name _ModeOn
		@type method
		@desc Start moving registered Object
		@param group string, group name
		@return nil
	]======]
	function _ModeOn(group)
		return _MaskOn(IFMovable, group)
	end

	doc [======[
		@name _ModeOff
		@type method
		@desc Stop moving registered Object
		@param group string, group name
		@return nil
	]======]
	function _ModeOff(group)
		return _MaskOff(IFMovable, group)
	end

	doc [======[
		@name _IsModeOn
		@type method
		@desc Whether the group is mode on
		@param group string, group name
		@return boolean true if the mode is turn on for the group
	]======]
	function _IsModeOn(group)
		group = tostring(group or _Global):upper()
		return _IFMovable_ModeOn[group]
	end

	doc [======[
		@name _Toggle
		@type method
		@desc Toggle the mode
		@param group string, group name
		@return nil
	]======]
	function _Toggle(group)
		_MaskToggle(IFMovable, group)
	end

	doc [======[
		@name _GetGroupList
		@type method
		@desc Get all group name
		@return table a list contains all groups
	]======]
	function _GetGroupList()
		local ret = {}

		for grp in pairs(_GroupListMovable) do
			tinsert(ret, grp)
		end

		sort(ret)

		return ret
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name IFMovingGroup
		@type property
		@desc The object's moving group name, default "Global"
	]======]
	property "IFMovingGroup" {
		Get = function(self)
			return _Global
		end,
	}

	doc [======[
		@name IFMovable
		@type property
		@desc Whether the object should be turn into the moving mode
	]======]
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
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		_GroupListMovable[self.IFMovingGroup][self] = nil
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFMovable(self)
		if Reflector.ObjectIsClass(self, Region) then
			_GroupListMovable[self.IFMovingGroup][self] = true
		end
	end
endinterface "IFMovable"

interface "IFResizable"
	doc [======[
		@name IFResizable
		@type interface
		@desc IFResizable provide a frame resize system
	]======]

	------------------------------------------------------
	-- Event
	------------------------------------------------------
	doc [======[
		@name OnSizeChanged
		@type event
		@desc Fired when a frame's size changes
	]======]
	event "OnSizeChanged"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name _ModeOn
		@type method
		@desc Start resizing registered Object
		@param group string, group name
		@return nil
	]======]
	function _ModeOn(group)
		return _MaskOn(IFResizable, group)
	end

	doc [======[
		@name _ModeOff
		@type method
		@desc Stop resizing registered Object
		@param group string, group name
		@return nil
	]======]
	function _ModeOff(group)
		return _MaskOff(IFResizable, group)
	end

	doc [======[
		@name _IsModeOn
		@type method
		@desc Whether the group is mode on
		@param group string, group name
		@return boolean true if the mode is turn on for the group
	]======]
	function _IsModeOn(group)
		group = tostring(group or _Global):upper()
		return _IFResizable_ModeOn[group]
	end

	doc [======[
		@name _Toggle
		@type method
		@desc Toggle the mode
		@param group string, group name
		@return nil
	]======]
	function _Toggle(group)
		_MaskToggle(IFResizable, group)
	end

	doc [======[
		@name _GetGroupList
		@type method
		@desc Get all group name
		@return table a list contains all groups
	]======]
	function _GetGroupList()
		local ret = {}

		for grp in pairs(_GroupListResizable) do
			tinsert(ret, grp)
		end

		sort(ret)

		return ret
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name IFResizingGroup
		@type property
		@desc The object's resizing group name, default "Global"
	]======]
	property "IFResizingGroup" {
		Get = function(self)
			return _Global
		end,
	}

	doc [======[
		@name IFResizable
		@type property
		@desc Whether the object should be turn into the resizing mode
	]======]
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
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		_GroupListResizable[self.IFResizingGroup][self] = nil
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFResizable(self)
		if Reflector.ObjectIsClass(self, Region) then
			_GroupListResizable[self.IFResizingGroup][self] = true
		end
	end
endinterface "IFResizable"