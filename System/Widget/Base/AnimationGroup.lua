-- Author      : Kurapica
-- Create Date : 8/18/2009
-- ChangeLog
--				2011/03/11	Recode as class

-- Check Version
local version = 6
if not IGAS:NewAddon("IGAS.Widget.AnimationGroup", version) then
	return
end

class "AnimationGroup"
	inherit "UIObject"

	doc [======[
		@name class_name
		@type class
		@desc An AnimationGroup is how various animations are actually applied to a region; this is how different behaviors can be run in sequence or in parallel with each other, automatically. When you pause an AnimationGroup, it tracks which of its child animations were playing and how far advanced they were, and resumes them from that point.<br>
		<br>An Animation in a group has an order from 1 to 100, which determines when it plays; once all animations with order 1 have completed, including any delays, the AnimationGroup starts all animations with order 2.<br>
		<br>An AnimationGroup can also be set to loop, either repeating from the beginning or playing backward back to the beginning. An AnimationGroup has an OnLoop handler that allows you to call your own code back whenever a loop completes. The :Finish() method stops the animation after the current loop has completed, rather than immediately.<br>
	]======]

	------------------------------------------------------
	-- Event
	------------------------------------------------------
	doc [======[
		@name OnFinished
		@type event
		@desc Run when the animation group finishes animating
		@param requested boolean, true if animation finished because of a call to AnimationGroup:Finish(); false otherwise
	]======]
	event "OnFinished"

	doc [======[
		@name OnLoad
		@type event
		@desc Run when the frame is created, no use in IGAS
	]======]
	event "OnLoad"

	doc [======[
		@name OnLoop
		@type event
		@desc Run when the animation group's loop state changes
		@param loopState System.Widget.AnimLoopStateType, the animation group's loop state
	]======]
	event "OnLoop"

	doc [======[
		@name OnPause
		@type event
		@desc Run when the animation group is paused
	]======]
	event "OnPause"

	doc [======[
		@name OnPlay
		@type event
		@desc Run when the animation group begins to play
	]======]
	event "OnPlay"

	doc [======[
		@name OnStop
		@type event
		@desc Run when the animation group is stopped
		@param requested boolean true if the animation was stopped due to a call to the animation's or group's :Stop() method; false if the animation was stopped for other reasons
	]======]
	event "OnStop"

	doc [======[
		@name OnUpdate
		@type event
		@desc Run each time the screen is drawn by the game engine
		@param elapsed number, Number of seconds since the OnUpdate handlers were last run (likely a fraction of a second)
	]======]
	event "OnUpdate"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name CreateAnimation
		@type method
		@desc Creates an Animation as a child of this group
		@param animationType string, type of Animation object to be create
		@param name string, global name to use for the new animation
		@param inheritsFrom string, a template from which to inherit
		@return System.Widget.Animation
	]======]
	function CreateAnimation(self, animationType, name, inheritsFrom)
		return Widget[animationType] and Widget[animationType](name, self, inheritsFrom)
	end

	doc [======[
		@name Finish
		@type method
		@desc Causes animations within the group to complete and stop. If the group is playing, animations will continue until the current loop cycle is complete before stopping.
		@return nil
	]======]

	doc [======[
		@name GetAnimations
		@type method
		@desc Returns a list of animations belonging to the group
		@return ... A list of Animation objects belonging to the animation group
	]======]
	function GetAnimations(self)
		local tbl = {self.__UI:GetAnimations()}
		for i, v in ipairs(tbl) do
			tbl[i] = IGAS:GetWrapper(v)
		end

		return unpack(tbl)
	end

	doc [======[
		@name GetDuration
		@type method
		@desc Returns the duration of a single loop cycle for the group, as determined by its child animations.
		@return number Total duration of all child animations (in seconds)
	]======]

	doc [======[
		@name GetInitialOffset
		@type method
		@desc Returns the starting static translation for the animated region
		@return x number, horizontal distance to offset the animated region (in pixels)
		@return y number, vertical distance to offset the animated region (in pixels)
	]======]

	doc [======[
		@name GetLooping
		@type method
		@desc Returns the looping behavior of the group
		@return System.Widget.AnimLoopType Looping type for the animation group
	]======]

	doc [======[
		@name GetLoopState
		@type method
		@desc Returns the current loop state of the group
		@return System.Widget.AnimLoopStateType Loop state of the animation group
	]======]

	doc [======[
		@name GetMaxOrder
		@type method
		@desc Returns the highest order amongst the animations in the group
		@return number Highest ordering value
	]======]

	doc [======[
		@name GetProgress
		@type method
		@desc Returns the current state of the animation group's progress
		@return number Value indicating the current state of the group animation: between 0.0 (initial state, child animations not yet started) and 1.0 (final state, all child animations complete)
	]======]

	doc [======[
		@name IsDone
		@type method
		@desc Returns whether the group has finished playing. Only valid in the OnFinished and OnUpdate handlers, and only applies if the animation group does not loop.
		@return boolean True if the group has finished playing; false otherwise
	]======]

	doc [======[
		@name IsPaused
		@type method
		@desc Returns whether the group is paused
		@return boolean True if animation of the group is currently paused; false otherwise
	]======]

	doc [======[
		@name IsPendingFinish
		@type method
		@desc Returns whether or not the animation group is pending finish
		@return boolean Whether or not the animation group is currently pending a finish command.  Since the Finish() method does not immediately stop the animation group, this method can be used to test if Finish() has been called and the group will finish at the end of the current loop.
	]======]

	doc [======[
		@name IsPlaying
		@type method
		@desc Returns whether the group is playing
		@return boolean True if the group is currently animating; false otherwise
	]======]

	doc [======[
		@name Pause
		@type method
		@desc Pauses animation of the group. Unlike with AnimationGroup:Stop(), the animation is paused at its current progress state (e.g. in a fade-out-fade-in animation, the element will be at partial opacity) instead of reset to the initial state; animation can be resumed with AnimationGroup:Play().
		@return nil
	]======]

	doc [======[
		@name Play
		@type method
		@desc Starts animating the group. If the group has been paused, animation resumes from the paused state; otherwise animation begins at the initial state.
		@return nil
	]======]

	doc [======[
		@name SetInitialOffset
		@type method
		@desc Sets a static translation for the animated region. This translation is only used while the animation is playing.
		@param x number, horizontal distance to offset the animated region (in pixels)
		@param y number, vertical distance to offset the animated region (in pixels)
		@return nil
	]======]

	doc [======[
		@name SetLooping
		@type method
		@desc Sets the looping behavior of the group
		@param loopType System.Widget.AnimLoopType
		@return nil
	]======]

	doc [======[
		@name Stop
		@type method
		@desc Stops animation of the group. Unlike with AnimationGroup:Pause(), the animation is reset to the initial state (e.g. in a fade-out-fade-in animation, the element will be instantly returned to full opacity) instead of paused at its current progress state.
		@return nil
	]======]

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name Looping
		@type property
		@desc looping type for the animation group: BOUNCE , NONE  , REPEAT
	]======]
	property "Looping" {
		Set = function(self, loopType)
			self:SetLooping(loopType)
		end,
		Get = function(self)
			return self:GetLooping()
		end,
		Type = AnimLoopType,
	}

	doc [======[
		@name LoopState
		@type property
		@desc the current loop state of the group: FORWARD , NONE , REVERSE
	]======]
	property "LoopState" {
		Get = function(self)
			return self:GetLoopState()
		end,
		Type = AnimLoopStateType,
	}

	doc [======[
		@name InitialOffset
		@type property
		@desc the starting static translation for the animated region
	]======]
	property "InitialOffset" {
		Get = function(self)
			return Dimension(self:GetInitialOffset())
		end,
		Set = function(self, value)
			return self:SetInitialOffset(value.x, value.y)
		end,
		Type = Dimension,
	}

	doc [======[
		@name Playing
		@type property
		@desc whether the animationgroup is playing
	]======]
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

	doc [======[
		@name Paused
		@type property
		@desc whether the animationgroup is paused
	]======]
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

	doc [======[
		@name Stoped
		@type property
		@desc whether the animationgroup is stoped
	]======]
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

	doc [======[
		@name Duration
		@type property
		@desc duration of all child animations (in seconds)
	]======]
	property "Duration" {
		Get = function(self)
			return self:GetDuration()
		end
	}

	------------------------------------------------------
	-- Event Handler
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