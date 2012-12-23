-- Author      : Kurapica
-- Create Date : 7/16/2008 11:05
-- Change Log  :
--				2011/03/13	Recode as class

----------------------------------------------------------------------------------------------------------------------------------------
--- Cooldown is a specialized variety of Frame that displays the little "clock" effect over abilities and buffs. It can be set with its running time, whether it should appear to "fill up" or "empty out", and whether or not there should be a bright edge where it's changing between dim and bright.
-- <br><br>inherit <a href=".\Frame.html">Frame</a> For all methods, properties and scriptTypes
-- @name Cooldown
-- @class table
-- @field Reverse true if the cooldown animation "sweeps" an area of darkness over the underlying image; false if the animation darkens the underlying image and "sweeps" the darkened area away
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 6
if not IGAS:NewAddon("IGAS.Widget.Cooldown", version) then
	return
end

class "Cooldown"
	inherit "Frame"

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Returns whether a bright line should be drawn on the moving edge of the cooldown animation
	-- @name Cooldown:GetDrawEdge
	-- @class function
	-- @return enabled - 1 if a bright line should be drawn on the moving edge of the cooldown "sweep" animation; otherwise nil (1nil)
	------------------------------------
	-- GetDrawEdge

	------------------------------------
	--- Returns whether the bright and dark portions of the cooldown animation should be inverted
	-- @name Cooldown:GetReverse
	-- @class function
	-- @return enabled - 1 if the cooldown animation "sweeps" an area of darkness over the underlying image; nil if the animation darkens the underlying image and "sweeps" the darkened area away (1nil)
	------------------------------------
	-- GetReverse

	------------------------------------
	--- Sets up the parameters for a Cooldown model.. Note: Most Cooldown animations in the default UI are managed via the function CooldownFrame_SetTimer(self, start, duration, enable), a wrapper for this method which automatically shows the Cooldown element while animating and hides it otherwise.
	-- @name Cooldown:SetCooldown
	-- @class function
	-- @param start Value of GetTime() at the start of the cooldown animation (number)
	-- @param duration Duration of the cooldown animation (excluding that of the final "flash" animation) (number)
	------------------------------------
	-- SetCooldown

	------------------------------------
	--- Sets whether a bright line should be drawn on the moving edge of the cooldown animation. Does not change the appearance of a currently running cooldown animation; only affects future runs of the animation.
	-- @name Cooldown:SetDrawEdge
	-- @class function
	-- @param enable True to cause a bright line to be drawn on the moving edge of the cooldown "sweep" animation; false for the default behavior (no line drawn) (boolean)
	------------------------------------
	-- SetDrawEdge

	------------------------------------
	--- Sets whether to invert the bright and dark portions of the cooldown animation
	-- @name Cooldown:SetReverse
	-- @class function
	-- @param reverse True for an animation "sweeping" an area of darkness over the underlying image; false for the default animation of darkening the underlying image and "sweeping" the darkened area away (boolean)
	------------------------------------
	-- SetReverse

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	property "Reverse" {
		Get = function(self)
			return self:GetReverse() and true or false
		end,
		Set = function(self, enabled)
			self:SetReverse(enabled)
		end,
		Type = Boolean,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Constructor(self, name, parent, ...)
		return CreateFrame("Cooldown", nil, parent, ...)
	end
endclass "Cooldown"

partclass "Cooldown"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(Cooldown)
endclass "Cooldown"