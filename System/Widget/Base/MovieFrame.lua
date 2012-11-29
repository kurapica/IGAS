-- Author      : Kurapica
-- Create Date : 2011/03/13
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- MovieFrame
-- <br><br>inherit <a href=".\Frame.html">Frame</a> For all methods, properties and scriptTypes
-- @name MovieFrame
-- @class table
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.MovieFrame", version) then
	return
end

class "MovieFrame"
	inherit "Frame"

	------------------------------------------------------
	-- Script
	-----------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	-----------------------------------
	--- Enables or disables subtitles for movies played in the frame. Subtitles are not automatically displayed by the MovieFrame; enabling subtitles causes the frame's OnMovieShowSubtitle and OnMovieHideSubtitle script handlers to be run when subtitle text should be displayed.
	-- @name MovieFrame:EnableSubtitles
	-- @class function
	-- @param enable True to enable display of movie subtitles; false to disable (boolean)
	------------------------------------
	-- EnableSubtitles

	------------------------------------
	--- Plays a specified movie in the frame. Note: Size and position of the movie display is unaffected by that of the MovieFrame -- movies are automatically centered and sized proportionally to fill the screen in their largest dimension (i.e. a widescreen movie will fill the width of the screen but not necessarily its full height).
	-- @name MovieFrame:StartMovie
	-- @class function
	-- @param filename Path to a movie file (excluding filename extension) (string)
	-- @param volume Audio volume for movie playback (0 = minimum, 255 = maximum) (number)
	-- @return enabled - 1 if a valid movie was loaded and playback begun; otherwise nil (1nil)
	------------------------------------
	-- StartMovie

	------------------------------------
	--- Stops the movie currently playing in the frame
	-- @name MovieFrame:StopMovie
	-- @class function
	------------------------------------
	-- StopMovie

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function MovieFrame(name, parent, ...)
		return UIObject(name, parent, CreateFrame("MovieFrame", nil, parent, ...))
	end
endclass "MovieFrame"

partclass "MovieFrame"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(MovieFrame)
endclass "MovieFrame"