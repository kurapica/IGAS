-- Author      : Kurapica
-- Create Date : 8/18/2009
-- ChangeLog
--				2011/03/11	Recode as class

----------------------------------------------------------------------------------------------------------------------------------------
--- An AnimationGroup is how various animations are actually applied to a region; this is how different behaviors can be run in sequence or in parallel with each other, automatically. When you pause an AnimationGroup, it tracks which of its child animations were playing and how far advanced they were, and resumes them from that point.<br>
-- An Animation in a group has an order from 1 to 100, which determines when it plays; once all animations with order 1 have completed, including any delays, the AnimationGroup starts all animations with order 2.<br>
-- An AnimationGroup can also be set to loop, either repeating from the beginning or playing backward back to the beginning. An AnimationGroup has an OnLoop handler that allows you to call your own code back whenever a loop completes. The :Finish() method stops the animation after the current loop has completed, rather than immediately.<br>
-- <br><br>inherit <a href=".\UIObject.html">UIObject</a> For all methods, properties and scriptTypes
-- @name AnimationGroup
-- @class table
-- @field Looping Looping type for the animation group: BOUNCE , NONE  , REPEAT
-- @field LoopState the current loop state of the group: FORWARD , NONE , REVERSE
-- @field InitialOffset the starting static translation for the animated region
-- @field Playing
-- @field Paused
-- @field Stoped
-- @field Duration
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 6
if not IGAS:NewAddon("IGAS.Widget.AnimationGroup", version) then
	return
end

class "AnimationGroup"
	inherit "UIObject"

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	------------------------------------
	--- ScriptType, Run whenever an event fires for which the frame is registered
	-- @name AnimationGroup:OnEvent
	-- @class function
	-- @param event the event's name
	-- @param ... the event's parameters
	-- @usage function AnimationGroup:OnEvent(event, ...)<br>
	--    -- do someting<br>
	-- end
	------------------------------------

	------------------------------------
	--- ScriptType, Run when the animation (or animation group) finishes animating
	-- @name AnimationGroup:OnFinished
	-- @class function
	-- @param requested True if animation finished because of a call to AnimationGroup:Finish(); false otherwise
	-- @usage function AnimationGroup:OnFinished(requested)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnFinished"

	------------------------------------
	--- ScriptType, Run when the frame is created
	-- @name AnimationGroup:OnLoad
	-- @class function
	-- @usage function AnimationGroup:OnLoad()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnLoad"

	------------------------------------
	--- ScriptType, Run when the animation group's loop state changes
	-- @name AnimationGroup:OnLoop
	-- @class function
	-- @param loopState the animation group's loop state
	-- @usage function AnimationGroup:OnLoop(loopState)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnLoop"

	------------------------------------
	--- ScriptType, Run when the animation (or animation group) is paused
	-- @name AnimationGroup:OnPause
	-- @class function
	-- @usage function AnimationGroup:OnPause()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnPause"

	------------------------------------
	--- ScriptType, Run when the animation (or animation group) begins to play
	-- @name AnimationGroup:OnPlay
	-- @class function
	-- @usage function AnimationGroup:OnPlay()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnPlay"

	------------------------------------
	--- ScriptType, Run when the animation (or animation group) is stopped
	-- @name AnimationGroup:OnStop
	-- @class function
	-- @param requested True if the animation was stopped due to a call to the animation's or group's :Stop() method; false if the animation was stopped for other reasons
	-- @usage function AnimationGroup:OnStop(requested)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnStop"

	------------------------------------
	--- ScriptType, Run each time the screen is drawn by the game engine
	-- @name AnimationGroup:OnUpdate
	-- @class function
	-- @param elapsed Number of seconds since the OnUpdate handlers were last run (likely a fraction of a second)
	-- @usage function AnimationGroup:OnUpdate(elapsed)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnUpdate"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Creates an Animation as a child of this group
	-- @name AnimationGroup:CreateAnimation
	-- @class function
	-- @param animationType Type of Animation object to be created(string)
	-- @param name Global name to use for the new animation (string)
	-- @param inheritsFrom A template from which to inherit (string)
	-- @return animation - The newly created animation (animation)
	------------------------------------
	function CreateAnimation(self, animationType, name, inheritsFrom)
		return Widget[animationType] and Widget[animationType](name, self, inheritsFrom)
	end

	------------------------------------
	--- Causes animations within the group to complete and stop. If the group is playing, animations will continue until the current loop cycle is complete before stopping. For example, in a group which manages a repeating fade-out-fade-in animation, the associated object will continue to fade completely back in, instead of the animation stopping and the object instantly switching from partial opacity to full opacity instantly. Does nothing if this group is not playing.</p>
	--- <p>To instantly stop an animation, see <a href="Stop.html">AnimationGroup:Stop()</a>.
	-- @name AnimationGroup:Finish
	-- @class function
	------------------------------------
	-- Finish

	------------------------------------
	--- Returns a list of animations belonging to the group
	-- @name AnimationGroup:GetAnimations
	-- @class function
	-- @return ... - A list of Animation objects belonging to the animation group (list)
	------------------------------------
	function GetAnimations(self)
		local tbl = {self.__UI:GetAnimations()}
		for i, v in ipairs(tbl) do
			tbl[i] = IGAS:GetWrapper(v)
		end

		return unpack(tbl)
	end

	------------------------------------
	--- Returns the duration of a single loop cycle for the group, as determined by its child animations. Total duration is based on the durations, delays, and order of child animations; see example for details.
	-- @name AnimationGroup:GetDuration
	-- @class function
	-- @return duration - Total duration of all child animations (in seconds) (number)
	------------------------------------
	-- GetDuration

	------------------------------------
	--- Returns the starting static translation for the animated region
	-- @name AnimationGroup:GetInitialOffset
	-- @class function
	-- @return x - Horizontal distance to offset the animated region (in pixels) (number)
	-- @return y - Vertical distance to offset the animated region (in pixels) (number)
	------------------------------------
	-- GetInitialOffset

	------------------------------------
	--- Returns the looping behavior of the group
	-- @name AnimationGroup:GetLooping
	-- @class function
	-- @return loopType - Looping type for the animation group (string) <ul><li>BOUNCE - Repeatedly animates forward from the initial state to the final state then backwards to the initial state
	-- @return NONE - No looping; animates from the initial state to the final state once and stops
	-- @return REPEAT - Repeatedly animates forward from the initial state to the final state (instantly resetting from the final state to the initial state between repetitions)
	------------------------------------
	-- GetLooping

	------------------------------------
	--- Returns the current loop state of the group
	-- @name AnimationGroup:GetLoopState
	-- @class function
	-- @return loopState - Loop state of the animation group (string) <ul><li>FORWARD - In transition from the start state to the final state
	-- @return NONE - Not looping
	-- @return REVERSE - In transition from the final state back to the start state
	------------------------------------
	-- GetLoopState

	------------------------------------
	--- Returns the highest order amongst the animations in the group
	-- @name AnimationGroup:GetMaxOrder
	-- @class function
	-- @return maxOrder - Highest ordering value (see Animation:GetOrder()) of the animations in the group (number)
	------------------------------------
	-- GetMaxOrder

	------------------------------------
	--- Returns the current state of the animation group's progress
	-- @name AnimationGroup:GetProgress
	-- @class function
	-- @return progress - Value indicating the current state of the group animation: between 0.0 (initial state, child animations not yet started) and 1.0 (final state, all child animations complete) (number)
	------------------------------------
	-- GetProgress

	------------------------------------
	--- Returns whether the group has finished playing. Only valid in the OnFinished and OnUpdate handlers, and only applies if the animation group does not loop.
	-- @name AnimationGroup:IsDone
	-- @class function
	-- @return done - True if the group has finished playing; false otherwise (boolean)
	------------------------------------
	-- IsDone

	------------------------------------
	--- Returns whether the group is paused
	-- @name AnimationGroup:IsPaused
	-- @class function
	-- @return paused - True if animation of the group is currently paused; false otherwise (boolean)
	------------------------------------
	-- IsPaused

	------------------------------------
	--- Returns whether or not the animation group is pending finish
	-- @name AnimationGroup:IsPendingFinish
	-- @class function
	-- @return isPending - Whether or not the animation group is currently pending a finish command.  Since the Finish() method does not immediately stop the animation group, this method can be used to test if Finish() has been called and the group will finish at the end of the current loop. (boolean)
	------------------------------------
	-- IsPendingFinish

	------------------------------------
	--- Returns whether the group is playing
	-- @name AnimationGroup:IsPlaying
	-- @class function
	-- @return playing - True if the group is currently animating; false otherwise (boolean)
	------------------------------------
	-- IsPlaying

	------------------------------------
	--- Pauses animation of the group. Unlike with AnimationGroup:Stop(), the animation is paused at its current progress state (e.g. in a fade-out-fade-in animation, the element will be at partial opacity) instead of reset to the initial state; animation can be resumed with AnimationGroup:Play().
	-- @name AnimationGroup:Pause
	-- @class function
	------------------------------------
	-- Pause

	------------------------------------
	--- Starts animating the group. If the group has been paused, animation resumes from the paused state; otherwise animation begins at the initial state.
	-- @name AnimationGroup:Play
	-- @class function
	------------------------------------
	-- Play

	------------------------------------
	--- Sets a static translation for the animated region. This translation is only used while the animation is playing.</p>
	--- <p>For example, applying an initial offset of 0,-50 to an animation group which fades the PlayerPortrait in and out would cause the portrait image to jump down 50 pixels from its normal position when the animation begins playing, and return to its initial position when the animation is finished or stopped.
	-- @name AnimationGroup:SetInitialOffset
	-- @class function
	-- @param x Horizontal distance to offset the animated region (in pixels) (number)
	-- @param y Vertical distance to offset the animated region (in pixels) (number)
	------------------------------------
	-- SetInitialOffset

	------------------------------------
	--- Sets the looping behavior of the group
	-- @name AnimationGroup:SetLooping
	-- @class function
	-- @param loopType Looping type for the animation group (string) <ul><li>BOUNCE - Repeatedly animates forward from the initial state to the final state then backwards to the initial state
	-- @param NONE No looping; animates from the initial state to the final state once and stops
	-- @param REPEAT Repeatedly animates forward from the initial state to the final state (instantly resetting from the final state to the initial state between repetitions)
	------------------------------------
	-- SetLooping

	------------------------------------
	--- Stops animation of the group. Unlike with AnimationGroup:Pause(), the animation is reset to the initial state (e.g. in a fade-out-fade-in animation, the element will be instantly returned to full opacity) instead of paused at its current progress state.
	-- @name AnimationGroup:Stop
	-- @class function
	------------------------------------
	-- Stop

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- Looping
	property "Looping" {
		Set = function(self, loopType)
			self:SetLooping(loopType)
		end,
		Get = function(self)
			return self:GetLooping()
		end,
		Type = AnimLoopType,
	}
	-- LoopState
	property "LoopState" {
		Get = function(self)
			return self:GetLoopState()
		end,
		Type = AnimLoopStateType,
	}
	-- InitialOffset
	property "InitialOffset" {
		Get = function(self)
			return Dimension(self:GetInitialOffset())
		end,
		Set = function(self, value)
			return self:SetInitialOffset(value.x, value.y)
		end,
		Type = Dimension,
	}
	-- Playing
	property "Playing" {
		Get = function(self)
			return self:IsPlaying()
		end,
		Set = function(self, value)
			if value then
				if not self:IsPlaying() then
					return self:Play()
				end
			else
				if self:IsPlaying() then
					return self:Stop()
				end
			end
		end,
	}
	-- Paused
	property "Paused" {
		Get = function(self)
			return self:IsPaused()
		end,
		Set = function(self, value)
			if value then
				if self:IsPlaying() then
					return self:Pause()
				end
			else
				if self:IsPaused() then
					return self:Play()
				end
			end
		end,
	}
	-- Stoped
	property "Stoped" {
		Get = function(self)
			return not (self:IsPlaying() or self:IsPaused())
		end,
		Set = function(self, value)
			if value then
				if self:IsPlaying() or self:IsPaused() then
					return self:Stop()
				end
			else
				if not (self:IsPlaying() or self:IsPaused()) then
					return self:Play()
				end
			end
		end,
	}
	-- Duration
	property "Duration" {
		Get = function(self)
			return self:GetDuration()
		end
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Constructor(self, name, parent, ...)
		if not IGAS:GetUI(parent).CreateAnimationGroup then
			error("Usage : AnimationGroup(name, parent) : 'parent' - can't create AnimationGroup.")
		end

		return IGAS:GetUI(parent):CreateAnimationGroup(nil, ...)
	end
endclass "AnimationGroup"

partclass "AnimationGroup"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(AnimationGroup)
endclass "AnimationGroup"