-- Author      : Kurapica
-- Create Date : 8/18/2009
-- ChangeLog
--				2011/03/11	Recode as class

----------------------------------------------------------------------------------------------------------------------------------------
--- Animations are used to change presentations or other characteristics of a frame or other region over time. The Animation object will take over the work of calling code over time, or when it is done, and tracks how close the animation is to completion.<br>
-- The Animation type doesn't create any visual effects by itself, but it does provide an OnUpdate handler that you can use to support specialized time-sensitive behaviors that aren't provided by the transformations descended from Animations. In addition to tracking the passage of time through an elapsed argument, you can query the animation's progress as a 0-1 fraction to determine how you should set your behavior.<br>
-- You can also change how the elapsed time corresponds to the progress by changing the smoothing, which creates acceleration or deceleration, or by adding a delay to the beginning or end of the animation.<br>
-- You can also use an Animation as a timer, by setting the Animation's OnFinished script to trigger a callback and setting the duration to the desired time.<br>
-- <br><br>inherit <a href=".\UIObject.html">UIObject</a> For all methods, properties and scriptTypes
-- @name Animation
-- @class table
-- @field StartDelay Amount of time the animation delays before its progress begins (in seconds)
-- @field EndDelay Time for the animation to delay after finishing (in seconds)
-- @field Duration Time for the animation to progress from start to finish (in seconds)
-- @field MaxFramerate Maximum number of times per second that the animation will update its progress
-- @field Order Position at which the animation will play relative to others in its group (between 0 and 100)
-- @field Smoothing Type of smoothing for the animation, IN, IN_OUT, NONE, OUT
-- @field Playing whether the animation is playing
-- @field Paused whether the animation is paused
-- @field Stoped whether the animation is stoped
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 4
if not IGAS:NewAddon("IGAS.Widget.Animation", version) then
	return
end

class "Animation"
	inherit "UIObject"

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	------------------------------------
	--- ScriptType, Run whenever an event fires for which the frame is registered
	-- @name Animation:OnEvent
	-- @class function
	-- @param event the event's name
	-- @param ... the event's parameters
	-- @usage function Animation:OnEvent(event, ...)<br>
	--    -- do someting<br>
	-- end
	------------------------------------

	------------------------------------
	--- ScriptType, Run when the animation (or animation group) finishes animating
	-- @name Animation:OnFinished
	-- @class function
	-- @param requested True if animation finished because of a call to AnimationGroup:Finish(); false otherwise
	-- @usage function Animation:OnFinished(requested)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnFinished"

	------------------------------------
	--- ScriptType, Run when the frame is created
	-- @name Animation:OnLoad
	-- @class function
	-- @usage function Animation:OnLoad()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnLoad"

	------------------------------------
	--- ScriptType, Run when the animation (or animation group) is paused
	-- @name Animation:OnPause
	-- @class function
	-- @usage function Animation:OnPause()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnPause"

	------------------------------------
	--- ScriptType, Run when the animation (or animation group) begins to play
	-- @name Animation:OnPlay
	-- @class function
	-- @usage function Animation:OnPlay()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnPlay"

	------------------------------------
	--- ScriptType, Run when the animation (or animation group) is stopped
	-- @name Animation:OnStop
	-- @class function
	-- @param requested True if the animation was stopped due to a call to the animation's or group's :Stop() method; false if the animation was stopped for other reasons
	-- @usage function Animation:OnStop(requested)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnStop"

	------------------------------------
	--- ScriptType, Run each time the screen is drawn by the game engine
	-- @name Animation:OnUpdate
	-- @class function
	-- @param elapsed Number of seconds since the OnUpdate handlers were last run (likely a fraction of a second)
	-- @usage function Animation:OnUpdate(elapsed)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnUpdate"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Returns the time for the animation to progress from start to finish
	-- @name Animation:GetDuration
	-- @class function
	-- @return duration - Time for the animation to progress from start to finish (in seconds) (number)
	------------------------------------
	-- GetDuration

	------------------------------------
	--- Returns the amount of time since the animation began playing. This amount includes start and end delays.
	-- @name Animation:GetElapsed
	-- @class function
	-- @return elapsed - Amount of time since the animation began playing (in seconds) (number)
	------------------------------------
	-- GetElapsed

	------------------------------------
	--- Returns the amount of time the animation delays after finishing. A later animation in an animation group will not begin until after the end delay period of the preceding animation has elapsed.
	-- @name Animation:GetEndDelay
	-- @class function
	-- @return delay - Time the animation delays after finishing (in seconds) (number)
	------------------------------------
	-- GetEndDelay

	------------------------------------
	--- Returns the maximum number of times per second that the animation will update its progress. Does not necessarily reflect the running framerate of the animation in progress; World of Warcraft itself may be running at a lower framerate.
	-- @name Animation:GetMaxFramerate
	-- @class function
	-- @return framerate - Maximum number of times per second that the animation will update its progress (number)
	------------------------------------
	-- GetMaxFramerate

	------------------------------------
	--- Returns the order of the animation within its parent group. When the parent AnimationGroup plays, Animations with a lower order number are played before those with a higher number. Animations with the same order number are played at the same time.
	-- @name Animation:GetOrder
	-- @class function
	-- @return order - Position at which the animation will play relative to others in its group (between 0 and 100) (number)
	------------------------------------
	-- GetOrder

	------------------------------------
	--- Returns the progress of an animation, ignoring smoothing effects. The value returned by this method increases linearly with time while the animation is playing, while the value returned by Animation:GetSmoothProgress() may change at a different rate if the animation's smoothing type is set to a value other than NONE.
	-- @name Animation:GetProgress
	-- @class function
	-- @return progress - Progress of the animation: between 0.0 (at start) and 1.0 (at end) (number)
	------------------------------------
	-- GetProgress

	------------------------------------
	--- Returns the progress of the animation and associated delays
	-- @name Animation:GetProgressWithDelay
	-- @class function
	-- @return progress - Progress of the animation and its delays: between 0.0 (at start of start delay) and 1.0 (at end of end delay) (number)
	------------------------------------
	-- GetProgressWithDelay

	------------------------------------
	--- Returns the Region object on which the animation operates
	-- @name Animation:GetRegionParent
	-- @class function
	-- @return region - Reference to the Region object on which the animation operates (i.e. the parent of the animation's parent AnimationGroup). (region, Region)
	------------------------------------
	function GetRegionParent(self)
		return IGAS:GetWrapper(self.__UI:GetRegionParent())
	end

	------------------------------------
	--- Returns the smoothing type for the animation. This setting affects the rate of change in the animation's progress value as it plays.
	-- @name Animation:GetSmoothing
	-- @class function
	-- @return smoothType - Type of smoothing for the animation (string) <ul><li>IN - Initially progressing slowly and accelerating towards the end
	-- @return IN_OUT - Initially progressing slowly and accelerating towards the middle, then slowing down towards the end
	-- @return NONE - Progresses at a constant rate from beginning to end
	-- @return OUT - Initially progressing quickly and slowing towards the end
	------------------------------------
	-- GetSmoothing

	------------------------------------
	--- Returns the progress of the animation (ignoring start and end delay). When using a generic Animation object to animate effects not handled by the built-in Animation subtypes, this method should be used for updating effects in the animation's OnUpdate handler, as it properly accounts for smoothing and delays managed by the Animation object.
	-- @name Animation:GetSmoothProgress
	-- @class function
	-- @return progress - Progress of the animation: between 0.0 (at start) and 1.0 (at end) (number)
	------------------------------------
	-- GetSmoothProgress

	------------------------------------
	--- Returns the amount of time the animation delays before its progress begins
	-- @name Animation:GetStartDelay
	-- @class function
	-- @return delay - Amount of time the animation delays before its progress begins (in seconds) (number)
	------------------------------------
	-- GetStartDelay

	------------------------------------
	--- Returns whether the animation is currently in the middle of a start or end delay
	-- @name Animation:IsDelaying
	-- @class function
	-- @return delaying - True if the animation is currently in its start or end delay period; false if the animation is currently between its start and end periods (or has none) or is not playing (boolean)
	------------------------------------
	-- IsDelaying

	------------------------------------
	--- Returns whether the animation has finished playing
	-- @name Animation:IsDone
	-- @class function
	-- @return done - True if the animation is finished playing; otherwise false (boolean)
	------------------------------------
	-- IsDone

	------------------------------------
	--- Returns whether the animation is currently paused
	-- @name Animation:IsPaused
	-- @class function
	-- @return paused - True if the animation is currently paused; false otherwise (boolean)
	------------------------------------
	-- IsPaused

	------------------------------------
	--- Returns whether the animation is currently playing
	-- @name Animation:IsPlaying
	-- @class function
	-- @return playing - True if the animation is currently playing; otherwise false (boolean)
	------------------------------------
	-- IsPlaying

	------------------------------------
	--- Returns whether the animation is currently stopped
	-- @name Animation:IsStopped
	-- @class function
	-- @return stopped - True if the animation is currently stopped; otherwise false (boolean)
	------------------------------------
	-- IsStopped

	------------------------------------
	--- Pauses the animation. Unlike with Animation:Stop(), the animation is paused at its current progress state (e.g. in a fade-out-fade-in animation, the element will be at partial opacity) instead of reset to the initial state; animation can be resumed with Animation:Play().
	-- @name Animation:Pause
	-- @class function
	------------------------------------
	-- Pause

	------------------------------------
	--- Plays the animation. If the animation has been paused, it resumes from the paused state; otherwise the animation begins at its initial state.
	-- @name Animation:Play
	-- @class function
	------------------------------------
	-- Play

	------------------------------------
	--- Sets the time for the animation to progress from start to finish
	-- @name Animation:SetDuration
	-- @class function
	-- @param duration Time for the animation to progress from start to finish (in seconds) (number)
	------------------------------------
	-- SetDuration

	------------------------------------
	--- Sets the amount of time for the animation to delay after finishing. A later animation in an animation group will not begin until after the end delay period of the preceding animation has elapsed.
	-- @name Animation:SetEndDelay
	-- @class function
	-- @param delay Time for the animation to delay after finishing (in seconds) (number)
	------------------------------------
	-- SetEndDelay

	------------------------------------
	--- Sets the maximum number of times per second for the animation to update its progress. Useful for limiting the amount of CPU time used by an animation. For example, if an UI element is 30 pixels square and is animated to double in size in 1 second, any visible increase in animation quality if WoW is running faster than 30 frames per second will be negligible. Limiting the animation's framerate frees CPU time to be used for other animations or UI scripts.
	-- @name Animation:SetMaxFramerate
	-- @class function
	-- @param framerate Maximum number of times per second for the animation to update its progress, or 0 to run at the maximum possible framerate (number)
	------------------------------------
	-- SetMaxFramerate

	------------------------------------
	--- Sets the order for the animation to play within its parent group. When the parent AnimationGroup plays, Animations with a lower order number are played before those with a higher number. Animations with the same order number are played at the same time.
	-- @name Animation:SetOrder
	-- @class function
	-- @param order Position at which the animation should play relative to others in its group (between 0 and 100) (number)
	------------------------------------
	-- SetOrder

	------------------------------------
	--- Sets the parent for the animation. If the animation was not already a child of the parent, the parent will insert the animation into the proper order amongst its children.
	-- @name Animation:SetParent
	-- @class function
	-- @param animGroup The animation group to set as the parent of this animation (animgroup, AnimationGroup)
	-- @param animGroupName The name of the animation group to set as the parent of this animation (string)
	------------------------------------
	function SetParent(self, parent)
		parent = IGAS:GetWrapper(parent)

		if parent and not Object.IsClass(parent, AnimationGroup) then
			error("Usage : Animation:SetParent(parent) : 'parent' - AnimationGroup element expected.", 2)
		end

		return UIObject.SetParent(self, parent)
	end

	------------------------------------
	--- Sets the smoothing type for the animation. This setting affects the rate of change in the animation's progress value as it plays.
	-- @name Animation:SetSmoothing
	-- @class function
	-- @param smoothType Type of smoothing for the animation (string) <ul><li>IN - Initially progressing slowly and accelerating towards the end
	-- @param IN_OUT Initially progressing slowly and accelerating towards the middle, then slowing down towards the end
	-- @param NONE Progresses at a constant rate from beginning to end
	-- @param OUT Initially progressing quickly and slowing towards the end
	------------------------------------
	-- SetSmoothing

	------------------------------------
	---
	-- @name Animation:SetSmoothProgress
	-- @class function
	------------------------------------
	-- SetSmoothProgress

	------------------------------------
	--- Sets the amount of time for the animation to delay before its progress begins. Start delays can be useful with concurrent animations in a group: see example for details.
	-- @name Animation:SetStartDelay
	-- @class function
	-- @param delay Amount of time for the animation to delay before its progress begins (in seconds) (number)
	------------------------------------
	-- SetStartDelay

	------------------------------------
	--- Stops the animation. Also resets the animation to its initial state.
	-- @name Animation:Stop
	-- @class function
	------------------------------------
	-- Stop

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- StartDelay
	property "StartDelay" {
		Set = function(self, delaySec)
			self:SetStartDelay(delaySec)
		end,
		Get = function(self)
			return self:GetStartDelay()
		end,
		Type = Number,
	}
	-- EndDelay
	property "EndDelay" {
		Set = function(self, delaySec)
			self:SetEndDelay(delaySec)
		end,
		Get = function(self)
			return self:GetEndDelay()
		end,
		Type = Number,
	}
	-- Duration
	property "Duration" {
		Set = function(self, durationSec)
			self:SetDuration(durationSec)
		end,
		Get = function(self)
			return self:GetDuration()
		end,
		Type = Number,
	}
	-- MaxFramerate
	property "MaxFramerate" {
		Set = function(self, framerate)
			self:SetMaxFramerate(framerate)
		end,
		Get = function(self)
			return self:GetMaxFramerate()
		end,
		Type = Number,
	}
	-- Order
	property "Order" {
		Set = function(self, order)
			self:SetOrder(order)
		end,
		Get = function(self)
			return self:GetOrder()
		end,
		Type = Number,
	}
	-- Smoothing
	property "Smoothing" {
		Set = function(self, smoothType)
			self:SetSmoothing(smoothType)
		end,
		Get = function(self)
			return self:GetSmoothing()
		end,
		Type = AnimSmoothType,
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
			return self:IsStopped()
		end,
		Set = function(self, value)
			if value then
				if self:IsPlaying() or self:IsPaused() then
					return self:Stop()
				end
			else
				if self:IsStopped()  then
					return self:Play()
				end
			end
		end,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Constructor(self, name, parent, ...)
		if not Object.IsClass(parent, AnimationGroup) then
			error("Usage : Animation(name, parent) : 'parent' - AnimationGroup element expected.", 2)
		end

		return IGAS:GetUI(parent):CreateAnimation("Animation", nil, ...)
	end
endclass "Animation"

partclass "Animation"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(Animation, AnimationGroup)
endclass "Animation"