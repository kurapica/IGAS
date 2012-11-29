-- Author : kurapica.igas@gmail.com
-- Create Date 	: 2011/03/01
-- ChangeLog
--                2011/10/31 code added as ColorType's member

local version = 4

if not IGAS:NewAddon("IGAS.Widget", version) then
	return
end

------------------------------------------------------
-- Header for System.Widget.*
------------------------------------------------------
import "System"

namespace "System.Widget"

------------------------------------------------------
-- Enums
------------------------------------------------------
-- FramePoint
enum "FramePoint" {
	"TOPLEFT",
	"TOPRIGHT",
	"BOTTOMLEFT",
	"BOTTOMRIGHT",
	"TOP",
	"BOTTOM",
	"LEFT",
	"RIGHT",
	"CENTER",
}
-- FrameStrata
enum "FrameStrata" {
	"PARENT",
	"BACKGROUND",
	"LOW",
	"MEDIUM",
	"HIGH",
	"DIALOG",
	"FULLSCREEN",
	"FULLSCREEN_DIALOG",
	"TOOLTIP",
}
-- DrawLayer
enum "DrawLayer" {
	"BACKGROUND",
	"BORDER",
	"ARTWORK",
	"OVERLAY",
	"HIGHLIGHT",
}
-- AlphaMode
enum "AlphaMode" {
	"DISABLE",
	"BLEND",
	"ALPHAKEY",
	"ADD",
	"MOD",
}
-- OutLineType
enum "OutLineType" {
	"NONE",
	"NORMAL",
	"THICK",
}
-- JustifyVType
enum "JustifyVType" {
	"TOP",
	"MIDDLE",
	"BOTTOM",
}
-- JustifyHType
enum "JustifyHType" {
	"LEFT",
	"CENTER",
	"RIGHT",
}
-- InsertMode
enum "InsertMode" {
	"TOP",
	"BOTTOM",
}
-- Orientation
enum "Orientation" {
	"HORIZONTAL",
	"VERTICAL",
}
-- AttributeType
enum "AttributeType" {
	"nil",
	"boolean",
	"number",
	"string",
}
-- AnimLoopType
enum "AnimLoopType" {
	"NONE",
	"REPEAT",
	"BOUNCE",
}
-- AnimLoopStateType
enum "AnimLoopStateType" {
	"NONE",
	"FORWARD",
	"REVERSE",
}
-- AnimSmoothType
enum "AnimSmoothType" {
	"NONE",
	"IN",
	"OUT",
	"IN_OUT",
	"OUT_IN",
}
-- AnimCurveType
enum "AnimCurveType" {
	"NONE",
	"SMOOTH",
}
-- AnchorType
enum "AnchorType" {
	"ANCHOR_TOPRIGHT",
	"ANCHOR_RIGHT",
	"ANCHOR_BOTTOMRIGHT",
	"ANCHOR_TOPLEFT",
	"ANCHOR_LEFT",
	"ANCHOR_BOTTOMLEFT",
	"ANCHOR_CURSOR",
	"ANCHOR_PRESERVE",
	"ANCHOR_NONE",
}
-- ButtonState
enum "ButtonStateType" {
	"PUSHED",
	"NORMAL",
}
-- ButtonClickType
enum "ButtonClickType" {
	"LeftButtonUp",
	"RightButtonUp",
	"MiddleButtonUp",
	"Button4Up",
	"Button5Up",
	"LeftButtonDown",
	"RightButtonDown",
	"MiddleButtonDown",
	"Button4Down",
	"Button5Down",
	"AnyUp",
	"AnyDown",
}
-- FontColor
enum "FontColor" {
	NORMAL = "|cffffd200",
	HIGHLIGHT = "|cffffffff",
	RED = "|cffff2020",
	GREEN = "|cff20ff20",
	GRAY = "|cff808080",
	YELLOW = "|cffffff00",
	LIGHTYELLOW = "|cffffff9a",
	ORANGE = "|cffff7f3f",
	ACHIEVEMENT = "|cffffff00",
	CLOSE = "|r",
}

------------------------------------------------------
-- Structs
------------------------------------------------------
-- Point
struct "Point"
	x = Number
	y = Number
endstruct "Point"

-- Dimension
struct "Dimension"
	x = Number
	y = Number
endstruct "Dimension"

-- Size
struct "Size"
	width = Number
	height = Number
endstruct "Size"

-- AnchorPoint
struct "AnchorPoint"
	point = FramePoint
	relativeTo = String
	relativePoint = FramePoint
	xOffset = Number
	yOffset = Number
endstruct "AnchorPoint"

-- struct Location
struct "Location"
	structtype "Array"

	element = AnchorPoint
endstruct "Location"

-- MinMax
struct "MinMax"
	min = Number
	max = Number

	function Validate(value)
		assert(value.min <= value.max, "%s.min can't be greater than %s.max.")

		return value
	end
endstruct "MinMax"

-- Inset
struct "Inset"
	left = Number
	right = Number
	top = Number
	bottom = Number
endstruct "Inset"

-- ColorFloat
struct "ColorFloat"
	function Validate(value)
		assert(type(value) == "number", ("%s must be a number, got %s."):format("%s", type(value)))
		assert(value >= 0 and value <= 1, ("%s must in [0-1], got %s."):format("%s", tostring(value)))
		return value
	end
endstruct "ColorFloat"

-- ColorType
struct "ColorType"
	r = ColorFloat
	g = ColorFloat
	b = ColorFloat
	a = ColorFloat + nil
	code = String + nil

	function Validate(value)
		value.a = value.a or 1	-- default
		value.code = ("\124cff%.2x%.2x%.2x"):format(value.r * 255, value.g * 255, value.b * 255)

		return value
	end
endstruct "ColorType"

-- Position
struct "Position"
	x = Number
	y = Number
	z = Number
endstruct "Position"

-- FontType
struct "FontType"
	path = String
	height = Number
	outline = OutLineType
	monochrome = Boolean
endstruct "FontType"

-- BackdropType
struct "BackdropType"
	bgFile = String + nil
	edgeFile = String + nil
	tile = Boolean + nil
	tileSize = Number + nil
	edgeSize = Number + nil
	insets = Inset + nil
endstruct "BackdropType"

-- AnimOrderType
struct "AnimOrderType"
	local floor = math.floor

	function Validate(value)
		assert(type(value) == "number", ("%s must be a number, got %s."):format("%s", type(value)))
		assert(value >=0 and value <= 100, ("%s must be in [0-100], got %s."):format("%s", tostring(value)))

		return floor(value)
	end
endstruct "AnimOrderType"

-- AnimOriginType
struct "AnimOriginType"
	point = FramePoint
	x = Number
	y = Number
endstruct "AnimOriginType"

-- LightType
struct "LightType"
	enabled = Boolean
	omni = Number
	dirX = Number
	dirY = Number
	dirZ = Number
	ambIntensity = ColorFloat + nil
	ambR = ColorFloat + nil
	ambG = ColorFloat + nil
	ambB = ColorFloat + nil
	dirIntensity = ColorFloat + nil
	dirR = ColorFloat + nil
	dirG = ColorFloat + nil
	dirB = ColorFloat + nil

	function Validate(value)
		assert(value.omni == 0 or value.omni == 1, "%s.omni must be 0 or 1.")

		return value
	end
endstruct "LightType"

-- MiniMapPosition
struct "MiniMapPosition"
	radius = Number
	rounding = Number
	angel = Number

	function Validate(value)
		assert(value.radius > 0, "The %s.radius must be greater than 0.")
		assert(value.angel >= 0 and value.angel <= 360, "The %s.angel must in [0-360].")

		return value
	end
endstruct "MiniMapPosition"

------------------------------------------------------
-- Global Settings
------------------------------------------------------
------------------------------------
--- Get the true frame of a IGAS frame
-- @name IGAS:GetUI
-- @class function
-- @param frame the IGAS frame
-- @return the true frame of the IGAS frame
-- @usage IGAS:GetUI(MyFrame1)
------------------------------------
function IGAS:GetUI(frame)
	if frame == nil or type(frame) ~= "table" then
		return frame
	else
		return frame.__UI or frame
	end
end

------------------------------------
--- Get the IGAS frame of a frame
-- @name IGAS:GetWrapper
-- @class function
-- @param frame the frame
-- @return the IGAS frame of the frame
-- @usage IGAS:GetWrapper(UIParent)
------------------------------------
function IGAS:GetWrapper(frame)
	if type(frame) ~= "table" or type(frame[0]) ~= "userdata" then
		-- VirtualUIObject's instance will be return here.
		return frame
	end

	if Object.IsClass(frame, Widget["UIObject"]) then
		-- UIObject's instance will be return here.
		return frame
	end

	if frame.__Wrapper and Object.IsClass(frame.__Wrapper, Widget["UIObject"]) then
		-- Check if the frame already has a wrapper
		-- Don't store it because I don't want a hashtable to be refreshed frequently.
		return frame.__Wrapper
	end

	-- Now build a new wrapper for it.
	if not frame.GetObjectType then
		return frame
	end

	local objType = frame:GetObjectType() or "UIObject"

	if Widget[objType] then
		return Widget[objType](frame) or frame
	else
		return Widget["UIObject"](frame) or frame
	end
end

_G = _G

------------------------------------
--- Get the IGAS frame for the full name
-- @name GetFrame
-- @class function
-- @param name
-- @return frame
-- @usage IGAS:GetFrame("IGAS.UIParent.TestForm.Label")
------------------------------------
function IGAS:GetFrame(name)
	local ret = _G

	if type(name) ~= "string" then return end

	for sub in name:gmatch("[^%.]+") do
		sub = sub and strtrim(sub)
		if not sub or sub =="" then return end

		ret = ret[sub]

		if not ret then return end
	end

	if ret == _G then return end

	return ret
end

_BaseFrame = _BaseFrame or CreateFrame("Frame")
_BaseFrame:Hide()

------------------------------------
--- Store blz UI's methodes to IGAS's Widget
-- @name StoreBlzMethod
-- @class function
-- @param super the super class
-- @param sample the blz UI element's instance
-- @usage StoreBlzMethod(Region, CreateFrame"Frame"))
------------------------------------
function StoreBlzMethod(cls, managerCls)
	local clsEnv = getfenv(2)
	local name = Reflector.GetName(cls)
	local super = Reflector.GetSuperClass(cls)

	local sample, manageSample

	if managerCls and Reflector.IsClass(managerCls) then
		local mname = Reflector.GetName(managerCls)
		manageSample = managerCls(mname, _BaseFrame)
		sample = cls(name, manageSample)
	elseif managerCls then
		sample = managerCls
	else
		sample = cls(name, _BaseFrame)
	end

	if type(IGAS:GetUI(sample)) ~= "table" or getmetatable(IGAS:GetUI(sample)) == nil or type(getmetatable(IGAS:GetUI(sample)).__index) ~= "table" then
		return
	end

	for fname, func in pairs(getmetatable(IGAS:GetUI(sample)).__index) do
		if cls[fname] == nil then
			clsEnv[fname] = func
		end
		--[[if rawget(clsEnv, fname) == nil and super[fname] == nil then
			clsEnv[fname] = func
		end--]]
	end

	--[[if sample ~= managerCls then
		System.Widget.UIObject.Dispose(sample)
	end

	if manageSample then
		System.Widget.UIObject.Dispose(manageSample)
	end--]]
end