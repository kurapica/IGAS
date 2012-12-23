-- Author      : Kurapica
-- Create Date : 8/03/2008 17:14
--              2011/03/13 Recode as class
--              2012/04/04 Row Number is added.
--              2012/04/04 Undo redo system added, plenty function added
--              2012/04/10 Fix the margin click
--              2012/05/13 Fix delete on double click selected multi-text

---------------------------------------------------------------------------------------------------------------------------------------
--- MultiLineTextBox is using to contains multi-text
-- <br><br>inherit <a href="..\Common\ScrollForm.html">ScrollForm</a> For all methods, properties and scriptTypes
-- @name MultiLineTextBox
-- @class table
-- @field NumericOnly true if the edit box only accepts numeric input
-- @field Password true if the text entered in the edit box is masked
-- @field AutoFocus true if the edit box automatically acquires keyboard input focus
-- @field HistoryLines the maximum number of history lines stored by the edit box
-- @field Focused true if the edit box is currently focused
-- @field AltArrowKeyMode true if the arrow keys are ignored by the edit box unless the Alt key is held
-- @field BlinkSpeed the rate at which the text insertion blinks when the edit box is focused
-- @field CursorPosition the current cursor position inside edit box
-- @field MaxBytes the maximum number of bytes of text allowed in the edit box, default is 0(Infinite)
-- @field MaxLetters the maximum number of text characters allowed in the edit box
-- @field Number the contents of the edit box as a number
-- @field Text the edit box's text contents
-- @field TextInsets the insets from the edit box's edges which determine its interactive text area
-- @field Editable true if the edit box is editable
-- @field ShowLineNumber true if show the row number margin
-- @field TabWidth the tab's width
---------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 14

if not IGAS:NewAddon("IGAS.Widget.MultiLineTextBox", version) then
	return
end

_GetCursorPosition = _G.GetCursorPosition

class "MultiLineTextBox"
	inherit "ScrollForm"

	import "System.Threading"

	------------------------------------------------------
	-- Local Settings
	------------------------------------------------------
	_DBL_CLK_CHK = 0.3
	_FIRST_WAITTIME = 0.5
	_CONTINUE_WAITTIME = 0.1
	_ConcatReturn = nil

	_UTF8_Three_Char = 224
	_UTF8_Two_Char = 192

	_TabWidth = 4

	-- Bytes
	_Byte = setmetatable({
		-- LineBreak
		LINEBREAK_N = strbyte("\n"),
		LINEBREAK_R = strbyte("\r"),

		-- Space
		SPACE = strbyte(" "),
		TAB = strbyte("\t"),

		-- UnderLine
		UNDERLINE = strbyte("_"),

		-- Number
		ZERO = strbyte("0"),
		NINE = strbyte("9"),
		E = strbyte("E"),
		e = strbyte("e"),
		x = strbyte("x"),
		a = strbyte("a"),
		f = strbyte("f"),

		-- String
		SINGLE_QUOTE = strbyte("'"),
		DOUBLE_QUOTE = strbyte('"'),

		-- Operator
		PLUS = strbyte("+"),
		MINUS = strbyte("-"),
		ASTERISK = strbyte("*"),
		SLASH = strbyte("/"),
		PERCENT = strbyte("%"),

		-- Compare
		LESSTHAN = strbyte("<"),
		GREATERTHAN = strbyte(">"),
		EQUALS = strbyte("="),

		-- Parentheses
		LEFTBRACKET = strbyte("["),
		RIGHTBRACKET = strbyte("]"),
		LEFTPAREN = strbyte("("),
		RIGHTPAREN = strbyte(")"),
		LEFTWING = strbyte("{"),
		RIGHTWING = strbyte("}"),

		-- Punctuation
		PERIOD = strbyte("."),
		BACKSLASH = strbyte("\\"),
		COMMA = strbyte(","),
		SEMICOLON = strbyte(";"),
		COLON = strbyte(":"),
		TILDE = strbyte("~"),
		HASH = strbyte("#"),

		-- WOW
		VERTICAL = strbyte("|"),
		r = strbyte("r"),
		c = strbyte("c"),
	}, {
		__index = function(self, key)
			if type(key) == "string" and key:len() == 1 then
				rawset(self, key, strbyte(key))
			end

			return rawget(self, key)
		end,
	})

	-- Special
	_Special = {
		-- LineBreak
		[_Byte.LINEBREAK_N] = 1,
		[_Byte.LINEBREAK_R] = 1,

		-- Space
		[_Byte.SPACE] = 1,
		[_Byte.TAB] = 1,

		-- String
		[_Byte.SINGLE_QUOTE] = 1,
		[_Byte.DOUBLE_QUOTE] = 1,

		-- Operator
		[_Byte.MINUS] = 1,
		[_Byte.PLUS] = 1,
		[_Byte.SLASH] = 1,
		[_Byte.ASTERISK] = 1,
		[_Byte.PERCENT] = 1,

		-- Compare
		[_Byte.LESSTHAN] = 1,
		[_Byte.GREATERTHAN] = 1,
		[_Byte.EQUALS] = 1,

		-- Parentheses
		[_Byte.LEFTBRACKET] = 1,
		[_Byte.RIGHTBRACKET] = 1,
		[_Byte.LEFTPAREN] = 1,
		[_Byte.RIGHTPAREN] = 1,
		[_Byte.LEFTWING] = 1,
		[_Byte.RIGHTWING] = 1,

		-- Punctuation
		[_Byte.PERIOD] = 1,
		[_Byte.COMMA] = 1,
		[_Byte.SEMICOLON] = 1,
		[_Byte.COLON] = 1,
		[_Byte.TILDE] = 1,
		[_Byte.HASH] = 1,

		-- WOW
		[_Byte.VERTICAL] = 1,
	}

	-- Operation
	_Operation = {
		CHANGE_CURSOR = 1,
		INPUTCHAR = 2,
		INPUTTAB = 3,
		DELETE = 4,
		BACKSPACE = 5,
		ENTER = 6,
		PASTE = 7,
		CUT = 8,
	}

	_KEY_OPER = {
		PAGEUP = _Operation.CHANGE_CURSOR,
		PAGEDOWN = _Operation.CHANGE_CURSOR,
		HOME = _Operation.CHANGE_CURSOR,
		END = _Operation.CHANGE_CURSOR,
		UP = _Operation.CHANGE_CURSOR,
		DOWN = _Operation.CHANGE_CURSOR,
		RIGHT = _Operation.CHANGE_CURSOR,
		LEFT = _Operation.CHANGE_CURSOR,
		TAB = _Operation.INPUTTAB,
		DELETE = _Operation.DELETE,
		BACKSPACE = _Operation.BACKSPACE,
		ENTER = _Operation.ENTER,
	}

	-- SkipKey
	_SkipKey = {
		-- Control keys
		LALT = true,
		LCTRL = true,
		LSHIFT = true,
		RALT = true,
		RCTRL = true,
		RSHIFT = true,
		-- other nouse keys
		ESCAPE = true,
		CAPSLOCK = true,
		PRINTSCREEN = true,
		INSERT = true,
		UNKNOWN = true,
	}

	-- Temp list
	_BackSpaceList = {}

	------------------------------------------------------
	-- Test FontString
	------------------------------------------------------
	_TestFontString = FontString("IGAS_MultiLineTextBox_TestFontString")
	_TestFontString.Visible = false
	_TestFontString:SetWordWrap(true)

	------------------------------------------------------
	-- Key Scanner
	------------------------------------------------------
	_KeyScan = Frame("IGAS_MultiLineTextBox_KeyScan", IGAS.WorldFrame)
	_KeyScan:SetPropagateKeyboardInput(true)
	_KeyScan.KeyboardEnabled = true
	_KeyScan.FrameStrata = "TOOLTIP"
	_KeyScan.Visible = false
	_KeyScan:ActiveThread("OnKeyDown")

	------------------------------------------------------
	-- Thread Helper
	------------------------------------------------------
	_Thread = System.Threading.Thread()

	------------------------------------------------------
	-- Local functions
	------------------------------------------------------
	local function ReplaceBlock(str, startp, endp, replace)
		return str:sub(1, startp - 1) .. replace .. str:sub(endp + 1, -1)
	end

	------------------------------------
	--- Set the cursor position without change the operation list
	-- @name  MultiLineTextBox:AdjustCursorPosition
	-- @class function
	-- @return the position of the cursor inside the EditBox
	-- @usage  MultiLineTextBox:AdjustCursorPosition(1)
	------------------------------------
	function AdjustCursorPosition(self, pos)
		self.__OldCursorPosition = pos
		self.__Text:SetCursorPosition(pos)
		return self:HighlightText(pos, pos)
	end

	local function UpdateLineNum(self)
		if self.__LineNum.Visible then
			local inset = self.__Text.TextInsets
			local lineWidth = self.__Text.Width - inset.left - inset.right
			local lineHeight = self.__Text.Font.height + self.__Text.Spacing

			local endPos

			local text = self.__Text.Text
			local index = 0
			local count = 0
			local extra = 0

			local lineNum = self.__LineNum

			lineNum.Lines = lineNum.Lines or {}
			local Lines = lineNum.Lines

			if self.__Text.Height > self.Height then
				lineNum.Height = self.__Text.Height
			else
				lineNum.Height = self.Height
			end

			_TestFontString:SetFontObject(self.__Text:GetFontObject())
			_TestFontString:SetSpacing(self.__Text:GetSpacing())
			_TestFontString:SetIndentedWordWrap(self.__Text:GetIndentedWordWrap())
			_TestFontString.Width = lineWidth

			if not _ConcatReturn then
				if text:find("\n") then
					_ConcatReturn = "\n"
				elseif text:find("\r") then
					_ConcatReturn = "\r"
				end
			end

			for line, endp in text:gmatch( "([^\r\n]*)()" ) do
				if endp ~= endPos then
					-- skip empty match
					endPos = endp

					index = index + 1
					count = count + 1

					Lines[count] = index

					_TestFontString.Text = line

					extra = _TestFontString:GetStringHeight() / lineHeight

					extra = floor(extra) - 1

					for i = 1, extra do
						count = count + 1

						Lines[count] = ""
					end
				end
			end

			for i = #Lines, count + 1, -1 do
				Lines[i] = nil
			end

			if _ConcatReturn then
				lineNum.Text = tblconcat(Lines, _ConcatReturn)
			else
				lineNum.Text = tostring(Lines[1] or "")
			end
		end
	end

	local function Ajust4Font(self)
		self.__LineNum:SetFontObject(self.__Text:GetFontObject())
		self.__LineNum:SetSpacing(self.__Text:GetSpacing())

		_TestFontString:SetFontObject(self.__Text:GetFontObject())
		_TestFontString.Text = "XXXX"

		self.__LineNum.Width = _TestFontString:GetStringWidth() + 8
		self.__LineNum.Text = ""

		local inset = self.__Text.TextInsets

		if self.__LineNum.Visible then
			if inset.left < self.__LineNum.Width then
				inset.left = self.__LineNum.Width + inset.left
			end

			if inset.left < self.__LineNum.Width + 5 then
				inset.left = self.__LineNum.Width + 5
			end

			self.__Text.TextInsets = inset

			self.__LineNum:SetPoint("TOP", self.__Text, "TOP", 0, - (inset.top))
		else
			if inset.left > self.__LineNum.Width then
				inset.left = inset.left - self.__LineNum.Width
			end

			if inset.left < 5 then
				inset.left = 5
			end

			self.__Text.TextInsets = inset

			self.__LineNum:SetPoint("TOP", self.__Text, "TOP", 0, - (inset.top))
		end

		self.ValueStep = self.__Text.Font.height + self.__Text.Spacing

		UpdateLineNum(self)
	end

	local function GetLines4Line(self, line)
		if not _ConcatReturn then
			return 0, self.__Text.Text:len()
		end

		local startp, endp = 0, 0
		local str = self.__Text.Text
		local count = 0

		while count < line and endp do
			startp = endp
			endp = endp + 1

			endp = str:find(_ConcatReturn, endp)
			count = count + 1
		end

		if not endp then
			endp = str:len()
		end

		return startp, endp
	end

	local function GetLines(str, startp, endp)
		local byte

		endp = (endp and (endp + 1)) or startp + 1

		-- get prev LineBreak
		while startp > 0 do
			byte = strbyte(str, startp)

			if not byte or byte == _Byte.LINEBREAK_N or byte == _Byte.LINEBREAK_R then
				break
			end

			startp = startp - 1
		end

		startp = startp + 1

		-- get next LineBreak
		while true do
			byte = strbyte(str, endp)

			if not byte or byte == _Byte.LINEBREAK_N or byte == _Byte.LINEBREAK_R then
				break
			end

			endp = endp + 1
		end

		endp = endp - 1

		-- get block
		return startp, endp, str:sub(startp, endp)
	end

	local function GetLinesByReturn(str, startp, returnCnt)
		local byte
		local handledReturn = 0
		local endp = startp + 1

		returnCnt = returnCnt or 0

		-- get prev LineBreak
		while startp > 0 do
			byte = strbyte(str, startp)

			if not byte or byte == _Byte.LINEBREAK_N or byte == _Byte.LINEBREAK_R then
				break
			end

			startp = startp - 1
		end

		startp = startp + 1

		-- get next LineBreak
		while true do
			byte = strbyte(str, endp)

			if not byte then
				break
			elseif byte == _Byte.LINEBREAK_N or byte == _Byte.LINEBREAK_R then
				returnCnt = returnCnt - 1

				if returnCnt < 0 then
					break
				end

				handledReturn = handledReturn + 1
			end

			endp = endp + 1
		end

		endp = endp - 1

		-- get block
		return startp, endp, str:sub(startp, endp), handledReturn
	end

	local function GetPrevLinesByReturn(str, startp, returnCnt)
		local byte
		local handledReturn = 0
		local endp = startp + 1

		returnCnt = returnCnt or 0

		-- get prev LineBreak
		while true do
			byte = strbyte(str, endp)

			if not byte or byte == _Byte.LINEBREAK_N or byte == _Byte.LINEBREAK_R then
				break
			end

			endp = endp + 1
		end

		endp = endp - 1

		local prevReturn

		-- get prev LineBreak
		while startp > 0 do
			byte = strbyte(str, startp)

			if not byte then
				break
			elseif byte == _Byte.LINEBREAK_N or byte == _Byte.LINEBREAK_R then
				returnCnt = returnCnt - 1

				if returnCnt < 0 then
					break
				end

				prevReturn = startp

				handledReturn = handledReturn + 1
			end

			startp = startp - 1
		end

		if not prevReturn or prevReturn >  startp + 1 then
			startp = startp + 1
		end

		-- get block
		return startp, endp, str:sub(startp, endp), handledReturn
	end

	local function GetOffsetByCursorPos(str, startp, cursorPos)
		if not cursorPos or cursorPos < 0 then
			return 0
		end

		startp = startp or cursorPos

		while startp > 0 do
			byte = strbyte(str, startp)

			if not byte or byte == _Byte.LINEBREAK_N or byte == _Byte.LINEBREAK_R then
				break
			end

			startp = startp - 1
		end

		startp = startp + 1

		local byte = strbyte(str, startp)
		local byteCnt = 0

		while startp <= cursorPos do
			if byte == _Byte.VERTICAL then
				-- handle the color code
				startp = startp + 1
				byte = strbyte(str, startp)

				if byte == _Byte.c then
					startp = startp + 9
				elseif byte == _Byte.r then
					startp = startp + 1
				end

				byte = strbyte(str, startp)
			else
				if not byte or byte == _Byte.LINEBREAK_N or byte == _Byte.LINEBREAK_R then
					break
				end

				byteCnt = byteCnt + 1
				startp = startp + 1
				byte = strbyte(str, startp)
			end
		end

		return byteCnt
	end

	local function GetCursorPosByOffset(str, startp, offset)
		startp = startp or 1
		offset = offset or 0

		while startp > 0 do
			byte = strbyte(str, startp)

			if not byte or byte == _Byte.LINEBREAK_N or byte == _Byte.LINEBREAK_R then
				break
			end

			startp = startp - 1
		end

		local byte
		local byteCnt = 0

		while byteCnt < offset do
			startp  = startp  + 1
			byte = strbyte(str, startp)

			if byte == _Byte.VERTICAL then
				-- handle the color code
				startp = startp + 1
				byte = strbyte(str, startp)

				if byte == _Byte.c then
					startp = startp + 8
				end
			else
				if not byte or byte == _Byte.LINEBREAK_N or byte == _Byte.LINEBREAK_R then
					startp = startp - 1
					break
				end

				byteCnt = byteCnt + 1
			end
		end

		return startp
	end

	local function GetWord(str, cursorPos)
		local startp, endp = GetLines(str, cursorPos)

		if startp > endp then return end

		_BackSpaceList.LastIndex = 0

		local prevPos = startp
		local byte
		local curIndex = -1

		while prevPos <= endp do
			byte = strbyte(str, prevPos)

			if byte == _Byte.VERTICAL then
				prevPos = prevPos + 1
				byte = strbyte(str, prevPos)

				if byte == _Byte.c then
					-- color start
					_BackSpaceList.LastIndex = _BackSpaceList.LastIndex + 1
					_BackSpaceList[_BackSpaceList.LastIndex] = prevPos - 1

					if cursorPos == prevPos - 2 then
						curIndex = _BackSpaceList.LastIndex
					end

					prevPos = prevPos + 9
				elseif byte == _Byte.r then
					-- color end
					_BackSpaceList.LastIndex = _BackSpaceList.LastIndex + 1
					_BackSpaceList[_BackSpaceList.LastIndex] = prevPos - 1

					if cursorPos == prevPos - 2 then
						curIndex = _BackSpaceList.LastIndex
					end

					prevPos = prevPos + 1
				else
					-- only mean "||"
					_BackSpaceList.LastIndex = _BackSpaceList.LastIndex + 1
					_BackSpaceList[_BackSpaceList.LastIndex] = prevPos - 1

					if cursorPos == prevPos - 2 then
						curIndex = _BackSpaceList.LastIndex
					end

					prevPos = prevPos + 1
				end
			elseif _Special[byte] then
				_BackSpaceList.LastIndex = _BackSpaceList.LastIndex + 1
				_BackSpaceList[_BackSpaceList.LastIndex] = prevPos

				if cursorPos == prevPos - 1 then
					curIndex = _BackSpaceList.LastIndex
				end

				prevPos = prevPos + 1
			else
				_BackSpaceList.LastIndex = _BackSpaceList.LastIndex + 1
				_BackSpaceList[_BackSpaceList.LastIndex] = prevPos

				if cursorPos == prevPos - 1 then
					curIndex = _BackSpaceList.LastIndex
				end

				if byte >= _UTF8_Three_Char then
					prevPos = prevPos + 3
				elseif byte >= _UTF8_Two_Char then
					prevPos = prevPos + 2
				else
					prevPos = prevPos + 1
				end
			end
		end

		if cursorPos == endp then
			curIndex = _BackSpaceList.LastIndex + 1
		end

		if curIndex > 0 then
			local prevIndex = curIndex - 1
			local isSpecial = nil
			local isColor

			while prevIndex > 0 do
				prevPos = _BackSpaceList[prevIndex]
				byte = strbyte(str, prevPos)

				isColor = false

				if byte == _Byte.VERTICAL then
					prevPos = prevPos + 1
					byte = strbyte(str, prevPos)

					if byte == _Byte.c or byte == _Byte.r then
						isColor = true
					end
				end

				if isColor then
					-- skip
				elseif isSpecial == nil then
					isSpecial = _Special[byte] and true or false
				elseif isSpecial then
					if not _Special[byte] then
						break
					end
				else
					if _Special[byte] then
						break
					end
				end

				prevIndex = prevIndex - 1
			end

			prevIndex = prevIndex + 1

			local nextIndex = curIndex

			isSpecial = nil

			while nextIndex <= _BackSpaceList.LastIndex do
				prevPos = _BackSpaceList[nextIndex]
				byte = strbyte(str, prevPos)

				isColor = false

				if byte == _Byte.VERTICAL then
					prevPos = prevPos + 1
					byte = strbyte(str, prevPos)

					if byte == _Byte.c or byte == _Byte.r then
						isColor = true
					end
				end

				if isColor then
					-- skip
				elseif isSpecial == nil then
					isSpecial = _Special[byte] and true or false
				elseif isSpecial then
					if not _Special[byte] then
						break
					end
				else
					if _Special[byte] then
						break
					end
				end

				nextIndex = nextIndex + 1
			end

			nextIndex = nextIndex - 1

			startp = _BackSpaceList[prevIndex]
			if _BackSpaceList.LastIndex > nextIndex and _BackSpaceList[nextIndex + 1] then
				endp = _BackSpaceList[nextIndex + 1] - 1
			end

			return startp, endp, str:sub(startp, endp)
		end
	end

	local function SaveOperation(self)
		if not self.__OperationOnLine then
			return
		end

		local nowText = self.__Text.Text

		-- check change
		if nowText == self.__OperationBackUpOnLine then
			self.__OperationOnLine = nil
			self.__OperationBackUpOnLine = nil
			self.__OperationStartOnLine = nil
			self.__OperationEndOnLine = nil

			return
		end

		self.__OperationIndex = self.__OperationIndex + 1
		self.__MaxOperationIndex = self.__OperationIndex

		local index = self.__OperationIndex

		-- Modify some oper var
		if self.__OperationOnLine == _Operation.DELETE then
			local _, oldLineCnt, newLineCnt

			_, oldLineCnt = self.__OperationBackUpOnLine:gsub("\n", "\n")
			_, newLineCnt = nowText:gsub("\n", "\n")

			_, self.__OperationEndOnLine = GetLinesByReturn(self.__OperationBackUpOnLine, self.__OperationStartOnLine, oldLineCnt - newLineCnt)
		end

		if self.__OperationOnLine == _Operation.BACKSPACE then
			local _, oldLineCnt, newLineCnt

			_, oldLineCnt = self.__OperationBackUpOnLine:gsub("\n", "\n")
			_, newLineCnt = nowText:gsub("\n", "\n")

			self.__OperationStartOnLine = GetPrevLinesByReturn(self.__OperationBackUpOnLine, self.__OperationEndOnLine, oldLineCnt - newLineCnt)
		end

		-- keep operation data
		self.__Operation[index] = self.__OperationOnLine

		self.__OperationBackUp[index] = select(3, GetLines(self.__OperationBackUpOnLine, self.__OperationStartOnLine, self.__OperationEndOnLine))
		self.__OperationStart[index] = self.__OperationStartOnLine
		self.__OperationEnd[index] = self.__OperationEndOnLine

		self.__OperationData[index] = select(3, GetLines(nowText, self.__HighlightTextStart, self.__HighlightTextEnd))
		self.__OperationFinalStart[index] = self.__HighlightTextStart
		self.__OperationFinalEnd[index] = self.__HighlightTextEnd

		-- special operation
		if self.__OperationOnLine == _Operation.ENTER then
			local realStart = GetLines(self.__OperationBackUpOnLine, self.__OperationStartOnLine, self.__OperationEndOnLine)
			if realStart > self.__OperationStartOnLine then
				realStart = self.__OperationStartOnLine
			end
			self.__OperationData[index] = select(3, GetLines(nowText, realStart, self.__HighlightTextEnd))
			self.__OperationFinalStart[index] = realStart
			self.__OperationFinalEnd[index] = self.__HighlightTextEnd
		end

		if self.__OperationOnLine == _Operation.PASTE then
			self.__OperationData[index] = select(3, GetLines(nowText, self.__OperationStartOnLine, self.__HighlightTextEnd))
			self.__OperationFinalStart[index] = self.__OperationStartOnLine
			self.__OperationFinalEnd[index] = self.__HighlightTextEnd
		end

		if self.__OperationOnLine == _Operation.CUT then
			self.__OperationData[index] = select(3, GetLines(nowText, self.__HighlightTextStart, self.__HighlightTextStart))
			self.__OperationFinalStart[index] = self.__HighlightTextStart
			self.__OperationFinalEnd[index] = self.__HighlightTextStart
		end

		self.__OperationOnLine = nil
		self.__OperationBackUpOnLine = nil
		self.__OperationStartOnLine = nil
		self.__OperationEndOnLine = nil

		return self:Fire("OnOperationListChanged")
	end

	local function NewOperation(self, oper)
		if self.__OperationOnLine == oper then
			return
		end

		-- save last operation
		SaveOperation(self)

		self.__OperationOnLine = oper

		self.__OperationBackUpOnLine = self.__Text.Text
		self.__OperationStartOnLine = self.__HighlightTextStart
		self.__OperationEndOnLine = self.__HighlightTextEnd
	end

	local function EndPrevKey(self)
		if self.__SKIPCURCHGARROW then
			self.__SKIPCURCHG = nil
			self.__SKIPCURCHGARROW = nil
		end

		self.__InPasting = nil
	end

	_IndentFunc = _IndentFunc or {}
	_ShiftIndentFunc = _ShiftIndentFunc or {}

	do
		setmetatable(_IndentFunc, {
			__index = function(self, key)
				if tonumber(key) then
					local tab = floor(tonumber(key))

					if tab > 0 then
						if not rawget(self, key) then
							rawset(self, key, function(str)
								return strrep(" ", tab) .. str
							end)
						end

						return rawget(self, key)
					end
				end
			end,
		})

		setmetatable(_ShiftIndentFunc, {
			__index = function(self, key)
				if tonumber(key) then
					local tab = floor(tonumber(key))

					if tab > 0 then
						if not rawget(self, key) then
							rawset(self, key, function(str)
								local _, len = str:find("^%s+")

								if len and len > 0 then
									return strrep(" ", len - tab) .. str:sub(len + 1, -1)
								end
							end)
						end

						return rawget(self, key)
					end
				end
			end,
		})

		wipe(_IndentFunc)
		wipe(_ShiftIndentFunc)
	end

	local function Search2Next(self)
		if not self.__InSearch then
			return
		end

		local text = self.__Text.Text

		local startp, endp = text:find(self.__InSearch, self.CursorPosition)

		if not startp then
			startp, endp = text:find(self.__InSearch, 0)
		end

		local s, e

		s = startp
		e = endp

		if s and e then
			SaveOperation(self)

			AdjustCursorPosition(self, e)

			self:HighlightText(s - 1, e)
		else
			IGAS:MsgBox(L"'%s' can't be found in the content.":format(self.__InSearch))

			self:SetFocus()
		end
	end

	local function GoLineByNo(self, no)
		local text = self.__Text.Text
		local lineBreak

		if text:find("\n") then
			lineBreak = "\n"
		elseif text:find("\r") then
			lineBreak = "\r"
		else
			lineBreak = false
		end

		no = no - 1

		local pos = 0
		local newPos

		if not lineBreak then
			return
		end

		SaveOperation(self)

		while no > 0 do
			newPos = text:find(lineBreak, pos + 1)

			if newPos then
				no = no - 1
				pos = newPos
			else
				break
			end
		end

		return AdjustCursorPosition(self, pos)
	end

	local function Thread_FindText(self)
		local searchText = IGAS:MsgBox(L"Please input the search content", "ic")

		self:SetFocus()

		searchText = searchText and strtrim(searchText)

		if searchText and searchText ~= "" then
			-- Prepare the search
			self.__InSearch = searchText

			Search2Next(self)
		end
	end

	local function Thread_GoLine(self)
		local goLine = IGAS:MsgBox(L"Please input the line number", "ic")

		self:SetFocus()

		goLine = goLine and tonumber(goLine)

		if goLine and goLine >= 1 then
			GoLineByNo(self, floor(goLine))
		end
	end

	local function Thread_DELETE(self)
		local first = true
		local str = self.__Text.Text
		local pos = self.CursorPosition + 1
		local byte
		local isSpecial = nil
		local nextPos

		while self.__DELETE do
			isSpecial = nil

			if first and self.__HighlightTextStart ~= self.__HighlightTextEnd then
				pos = self.__HighlightTextStart + 1
				nextPos = self.__HighlightTextEnd + 1
			else
				nextPos = pos
				byte = strbyte(str, nextPos)

				-- yap, I should do this myself
				if IsControlKeyDown() then
					-- delete words
					while true do
						if not byte then
							break
						elseif byte == _Byte.VERTICAL then
							nextPos = nextPos + 1
							byte = strbyte(str, nextPos)

							if byte == _Byte.c then
								-- skip color start
								nextPos = nextPos + 8
							elseif byte == _Byte.r then
								-- skip color end
							else
								-- only mean "||"
								if isSpecial == nil then
									isSpecial = true
								elseif not isSpecial then
									nextPos = nextPos - 1
									break
								end
							end
						else
							if isSpecial == nil then
								isSpecial = _Special[byte] and true or false
							elseif not isSpecial then
								if _Special[byte] then
									break
								end
							else
								if not _Special[byte] then
									break
								end
							end
						end

						nextPos = nextPos + 1
						byte = strbyte(str, nextPos)
					end
				else
					-- delete char
					while true do
						if not byte then
							break
						elseif byte == _Byte.VERTICAL then
							nextPos = nextPos + 1
							byte = strbyte(str, nextPos)

							if byte == _Byte.c then
								-- skip color start
								nextPos = nextPos + 8
							elseif byte == _Byte.r then
								-- skip color end
							else
								-- only mean "||"
								nextPos = nextPos + 1
								break
							end
						else
							if byte >= _UTF8_Three_Char then
								nextPos = nextPos + 3
							elseif byte >= _UTF8_Two_Char then
								nextPos = nextPos + 2
							else
								nextPos = nextPos + 1
							end
							break
						end

						nextPos = nextPos + 1
						byte = strbyte(str, nextPos)
					end
				end
			end

			if pos == nextPos then
				break
			end

			str = ReplaceBlock(str, pos, nextPos - 1, "")

			self.__Text.Text = str

			AdjustCursorPosition(self, pos - 1)

			-- Do for long press
			if first then
				Threading.Sleep(_FIRST_WAITTIME)
				first = false
			else
				Threading.Sleep(_CONTINUE_WAITTIME)
			end
		end

		self:Fire("OnDeleteFinished")
	end

	local function Thread_BACKSPACE(self)
		local first = true
		local str = self.__Text.Text
		local pos = self.CursorPosition
		local byte
		local isSpecial = nil
		local prevPos
		local prevIndex
		local prevColorStart = nil
		local prevWhite = 0
		local whiteIndex = 0

		_BackSpaceList.LastIndex = 0

		while self.__BACKSPACE do
			isSpecial = nil

			if first and self.__HighlightTextStart ~= self.__HighlightTextEnd then
				pos = self.__HighlightTextEnd
				prevPos = self.__HighlightTextStart + 1
			else
				-- prepare char list
				if _BackSpaceList.LastIndex == 0 then
					-- index the prev return char
					prevPos = pos
					byte = strbyte(str, prevPos)
					prevWhite = 0
					whiteIndex = 0

					while true do
						if not byte or byte == _Byte.LINEBREAK_N or byte == _Byte.LINEBREAK_R then
							break
						end

						prevPos = prevPos - 1
						byte = strbyte(str, prevPos)
					end

					if byte then
						-- record the newline
						_BackSpaceList.LastIndex = _BackSpaceList.LastIndex + 1
						_BackSpaceList[_BackSpaceList.LastIndex] = prevPos
					end

					prevPos = prevPos + 1

					-- Check prev space
					if prevPos <= pos then
						byte = strbyte(str, prevPos)

						if byte == _Byte.SPACE then
							_BackSpaceList.LastIndex = _BackSpaceList.LastIndex + 1
							_BackSpaceList[_BackSpaceList.LastIndex] = prevPos
							whiteIndex = _BackSpaceList.LastIndex

							while prevPos <= pos do
								prevWhite = prevWhite + 1
								prevPos = prevPos + 1
								byte = strbyte(str, prevPos)

								if byte ~= _Byte.SPACE then
									break
								end
							end
						end
					end

					while prevPos <= pos do
						byte = strbyte(str, prevPos)

						if byte == _Byte.VERTICAL then
							prevPos = prevPos + 1
							byte = strbyte(str, prevPos)

							if byte == _Byte.c then
								prevColorStart = prevColorStart or (prevPos - 1)
								-- skip color start
								prevPos = prevPos + 9
							elseif byte == _Byte.r then
								prevColorStart = prevColorStart or (prevPos - 1)
								-- skip color end
								prevPos = prevPos + 1
							else
								-- only mean "||"
								_BackSpaceList.LastIndex = _BackSpaceList.LastIndex + 1
								_BackSpaceList[_BackSpaceList.LastIndex] = prevColorStart or prevPos - 1
								prevColorStart = nil

								prevPos = prevPos + 1
							end
						elseif _Special[byte] then
							_BackSpaceList.LastIndex = _BackSpaceList.LastIndex + 1
							_BackSpaceList[_BackSpaceList.LastIndex] = prevColorStart or prevPos
							prevColorStart = nil

							prevPos = prevPos + 1
						else
							_BackSpaceList.LastIndex = _BackSpaceList.LastIndex + 1
							_BackSpaceList[_BackSpaceList.LastIndex] = prevColorStart or prevPos
							prevColorStart = nil

							if byte >= _UTF8_Three_Char then
								prevPos = prevPos + 3
							elseif byte >= _UTF8_Two_Char then
								prevPos = prevPos + 2
							else
								prevPos = prevPos + 1
							end
						end
					end
				end

				if _BackSpaceList.LastIndex == 0 then
					break
				end

				prevIndex = _BackSpaceList.LastIndex

				-- yap, I should do this myself
				if IsControlKeyDown() then
					-- delete words
					while prevIndex > 0 do
						prevPos = _BackSpaceList[prevIndex]
						byte = strbyte(str, prevPos)

						while byte == _Byte.VERTICAL do
							prevPos = prevPos + 1
							byte = strbyte(str, prevPos)

							if byte == _Byte.c then
								-- skip color start
								prevPos = prevPos + 9
								byte = strbyte(str, prevPos)
							elseif byte == _Byte.r then
								-- skip color end
								prevPos = prevPos + 1
								byte = strbyte(str, prevPos)
							else
								prevPos = prevPos - 1
								byte = strbyte(str, prevPos)
								break
							end
						end

						if isSpecial == nil then
							isSpecial = _Special[byte] and true or false
						elseif isSpecial then
							if not _Special[byte] then
								break
							end
						else
							if _Special[byte] then
								break
							end
						end

						prevIndex = prevIndex - 1
					end

					prevIndex = prevIndex + 1
					prevPos = _BackSpaceList[prevIndex]

					_BackSpaceList.LastIndex = prevIndex - 1
				else
					if prevIndex ~= whiteIndex or (prevIndex == whiteIndex and prevWhite == 0) then
						-- delete char
						prevPos = _BackSpaceList[prevIndex]

						_BackSpaceList.LastIndex = prevIndex - 1
					else
						prevPos = _BackSpaceList[prevIndex]

						prevWhite = (ceil(prevWhite / self.TabWidth) - 1) * self.TabWidth
						if prevWhite < 0 then prevWhite = 0 end

						prevPos = prevPos + prevWhite

						if prevWhite <= 0 then
							_BackSpaceList.LastIndex = prevIndex - 1
						end
					end
				end
			end

			str = ReplaceBlock(str, prevPos, pos, "")

			self.__Text.Text = str

			AdjustCursorPosition(self, prevPos - 1)

			pos = prevPos - 1

			-- Do for long press
			if first then
				Threading.Sleep(_FIRST_WAITTIME)
				first = false
			else
				Threading.Sleep(_CONTINUE_WAITTIME)
			end
		end

		-- shift tab
		pos = self.CursorPosition
		local startp, endp, line = GetLines(str, pos)

		local _, len = line:find("^%s+")

		if len and len > 1 and startp + len - 1 >= pos then
			if len % self.TabWidth ~= 0 then
				line = line:sub(len + 1, -1)
				len = floor(len/self.TabWidth) * self.TabWidth

				line = strrep(" ", len) .. line

				str = ReplaceBlock(str, startp, endp, line)

				self.__Text.Text = str

				AdjustCursorPosition(self, startp - 1 + len)
			end
		end

		self:Fire("OnBackspaceFinished")
	end

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	------------------------------------
	--- ScriptType, Run when the edit box's text is changed
	-- @name MultiLineTextBox:OnTextChanged
	-- @class function
	-- @param isUserInput
	-- @usage function MultiLineTextBox:OnTextChanged(isUserInput)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnTextChanged"

	------------------------------------
	--- ScriptType, Run when the position of the text insertion cursor in the edit box changes
	-- @name MultiLineTextBox:OnCursorChanged
	-- @class function
	-- @param x Horizontal position of the cursor relative to the top left corner of the edit box (in pixels)
	-- @param y Vertical position of the cursor relative to the top left corner of the edit box (in pixels)
	-- @param width Width of the cursor graphic (in pixels)
	-- @param height Height of the cursor graphic (in pixels); matches the height of a line of text in the edit box
	-- @usage function MultiLineTextBox:OnCursorChanged(x, y, width, height)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnCursorChanged"

	------------------------------------
	--- ScriptType, Run when the edit box becomes focused for keyboard input
	-- @name MultiLineTextBox:OnEditFocusGained
	-- @class function
	-- @usage function MultiLineTextBox:OnEditFocusGained()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnEditFocusGained"

	------------------------------------
	--- ScriptType, Run when the edit box loses keyboard input focus
	-- @name MultiLineTextBox:OnEditFocusLost
	-- @class function
	-- @usage function MultiLineTextBox:OnEditFocusLost()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnEditFocusLost"

	------------------------------------
	--- ScriptType, Run when the Enter (or Return) key is pressed while the edit box has keyboard focus
	-- @name MultiLineTextBox:OnEnterPressed
	-- @class function
	-- @usage function MultiLineTextBox:OnEnterPressed()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnEnterPressed"

	------------------------------------
	--- ScriptType, Run when the Escape key is pressed while the edit box has keyboard focus
	-- @name MultiLineTextBox:OnEscapePressed
	-- @class function
	-- @usage function MultiLineTextBox:OnEscapePressed()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnEscapePressed"

	------------------------------------
	--- ScriptType, Run when the edit box's language input mode changes
	-- @name MultiLineTextBox:OnInputLanguageChanged
	-- @class function
	-- @param language Name of the new input language
	-- @usage function MultiLineTextBox:OnInputLanguageChanged("language")<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnInputLanguageChanged"

	------------------------------------
	--- ScriptType, Run when the space bar is pressed while the edit box has keyboard focus
	-- @name MultiLineTextBox:OnSpacePressed
	-- @class function
	-- @usage function MultiLineTextBox:OnSpacePressed()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnSpacePressed"

	------------------------------------
	--- ScriptType, Run when the Tab key is pressed while the edit box has keyboard focus
	-- @name MultiLineTextBox:OnTabPressed
	-- @class function
	-- @usage function MultiLineTextBox:OnTabPressed()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnTabPressed"

	------------------------------------
	--- ScriptType, Run when the edit box's text is set programmatically
	-- @name MultiLineTextBox:OnTextSet
	-- @class function
	-- @usage function MultiLineTextBox:OnTextSet()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnTextSet"

	------------------------------------
	--- ScriptType, Run for each text character typed in the MultiLineTextBox
	-- @name MultiLineTextBox:OnChar
	-- @class function
	-- @param text The text entered
	-- @usage function MultiLineTextBox:OnChar(text)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnChar"

	------------------------------------
	--- ScriptType, Run when the edit box's input composition mode changes
	-- @name MultiLineTextBox:OnCharComposition
	-- @class function
	-- @param text The text entered
	-- @usage function MultiLineTextBox:OnCharComposition(text)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnCharComposition"

	------------------------------------
	--- ScriptType, Run when the edit box's FunctionKey is pressed
	-- @name MultiLineTextBox:OnFunctionKey
	-- @class function
	-- @param key The key (like 'F5')
	-- @usage function MultiLineTextBox:OnFunctionKey(key)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnFunctionKey"

	------------------------------------
	--- ScriptType, Run when the edit box's control key is pressed
	-- @name MultiLineTextBox:OnControlKey
	-- @class function
	-- @param text The text entered
	-- @usage function MultiLineTextBox:OnControlKey(key)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnControlKey"

	------------------------------------
	--- ScriptType, Run when the edit box's operation list is changed
	-- @name MultiLineTextBox:OnOperationListChanged
	-- @class function
	-- @param startp optional
	-- @param endp optional
	-- @usage function MultiLineTextBox:OnOperationListChanged(startp, endp)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnOperationListChanged"

	------------------------------------
	--- ScriptType, Run when the delete key is up
	-- @name MultiLineTextBox:OnDeleteFinished
	-- @class function
	-- @usage function MultiLineTextBox:OnDeleteFinished()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnDeleteFinished"

	------------------------------------
	--- ScriptType, Run when the backspace key is up
	-- @name MultiLineTextBox:OnBackspaceFinished
	-- @class function
	-- @usage function MultiLineTextBox:OnBackspaceFinished()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnBackspaceFinished"

	------------------------------------
	--- ScriptType, Run when pasting finished
	-- @name MultiLineTextBox:OnPasting
	-- @class function
	-- @param startp
	-- @param endp
	-- @usage function MultiLineTextBox:OnPasting(starp, endp)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnPasting"

	------------------------------------
	--- ScriptType, Run when cut finished
	-- @name MultiLineTextBox:OnCut
	-- @class function
	-- @param startp
	-- @param endp
	-- @param cutText
	-- @usage function MultiLineTextBox:OnCut(startp, endp, cutText)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnCut"

	------------------------------------------------------
	-- Method
	------------------------------------------------------

	------------------------------------
	--- Returns the font instance's basic font properties
	-- @name Font:GetFont
	-- @class function
	-- @return filename - Path to a font file (string)
	-- @return fontHeight - Height (point size) of the font to be displayed (in pixels) (number)
	-- @return flags - Additional properties for the font specified by one or more (separated by commas) of the following tokens: (string) <ul><li>MONOCHROME - Font is rendered without antialiasing
	-- @return OUTLINE - Font is displayed with a black outline
	-- @return THICKOUTLINE - Font is displayed with a thick black outline
	------------------------------------
	-- GetFont
	function GetFont(self, ...)
		return self.__Text:GetFont(...)
	end

	------------------------------------
	--- Returns the Font object from which the font instance's properties are inherited. See Font:SetFontObject() for details.
	-- @name Font:GetFontObject
	-- @class function
	-- @return font - Reference to the Font object from which the font instance's properties are inherited, or nil if the font instance has no inherited properties (font)
	------------------------------------
	function GetFontObject(self, ...)
		return self.__Text:GetFontObject(...)
	end

	------------------------------------
	--- Returns the color of the font's text shadow
	-- @name Font:GetShadowColor
	-- @class function
	-- @return shadowR - Red component of the shadow color (0.0 - 1.0) (number)
	-- @return shadowG - Green component of the shadow color (0.0 - 1.0) (number)
	-- @return shadowB - Blue component of the shadow color (0.0 - 1.0) (number)
	-- @return shadowAlpha - Alpha (opacity) of the text's shadow (0.0 = fully transparent, 1.0 = fully opaque) (number)
	------------------------------------
	-- GetShadowColor
	function GetShadowColor(self, ...)
		return self.__Text:GetShadowColor(...)
	end

	------------------------------------
	--- Returns the offset of the font instance's text shadow from its text
	-- @name Font:GetShadowOffset
	-- @class function
	-- @return xOffset - Horizontal distance between the text and its shadow (in pixels) (number)
	-- @return yOffset - Vertical distance between the text and its shadow (in pixels) (number)
	------------------------------------
	-- GetShadowOffset
	function GetShadowOffset(self, ...)
		return self.__Text:GetShadowOffset(...)
	end

	------------------------------------
	--- Returns the font instance's amount of spacing between lines
	-- @name Font:GetSpacing
	-- @class function
	-- @return spacing - Amount of space between lines of text (in pixels) (number)
	------------------------------------
	-- GetSpacing
	function GetSpacing(self, ...)
		return self.__Text:GetSpacing(...)
	end

	------------------------------------
	--- Returns the font instance's default text color
	-- @name Font:GetTextColor
	-- @class function
	-- @return textR - Red component of the text color (0.0 - 1.0) (number)
	-- @return textG - Green component of the text color (0.0 - 1.0) (number)
	-- @return textB - Blue component of the text color (0.0 - 1.0) (number)
	-- @return textAlpha - Alpha (opacity) of the text (0.0 = fully transparent, 1.0 = fully opaque) (number)
	------------------------------------
	-- GetTextColor
	function GetTextColor(self, ...)
		return self.__Text:GetTextColor(...)
	end

	------------------------------------
	--- Sets the font instance's basic font properties. Font files included with the default WoW client:</p>
	--- <ul>
	--- <li>Fonts\\FRIZQT__.TTF - Friz Quadrata, used by default for player names and most UI text</li>
	--- <li>Fonts\\ARIALN.TTF - Arial Narrow, used by default for chat windows, action button numbers, etc.</li>
	--- <li>Fonts\\skurri.ttf - Skurri, used by default for incoming damage/parry/miss/etc indicators on the Player and Pet frames</li>
	--- <li>Fonts\\MORPHEUS.ttf - Morpheus, used by default for quest title headers, mail, and readable in-game objects.</li>
	--- </ul>
	--- <p>Font files can also be included in addons.
	-- @name Font:SetFont
	-- @class function
	-- @param filename Path to a font file (string)
	-- @param fontHeight Height (point size) of the font to be displayed (in pixels) (number)
	-- @param flags Additional properties for the font specified by one or more (separated by commas) of the following tokens: (string) <ul><li>MONOCHROME - Font is rendered without antialiasing
	-- @param OUTLINE Font is displayed with a black outline
	-- @param THICKOUTLINE Font is displayed with a thick black outline
	-- @return isValid - 1 if filename refers to a valid font file; otherwise nil (1nil)
	------------------------------------
	-- SetFont
	function SetFont(self, ...)
		self.__Text:SetFont(...)
		Ajust4Font(self)
	end

	------------------------------------
	--- Sets the Font object from which the font instance's properties are inherited. This method allows for easy standardization and reuse of font styles. For example, a button's normal font can be set to appear in the same style as many default UI elements by setting its font to "GameFontNormal" -- if Blizzard changes the main UI font in a future patch, or if the user installs another addon which changes the main UI font, the button's font will automatically change to match.
	-- @name Font:SetFontObject
	-- @class function
	-- @param object Reference to a Font object (font)
	-- @param name Global name of a Font object (string)
	------------------------------------
	-- SetFontObject
	function SetFontObject(self, ...)
		self.__Text:SetFontObject(...)
		Ajust4Font(self)
	end

	------------------------------------
	--- Sets the color of the font's text shadow
	-- @name Font:SetShadowColor
	-- @class function
	-- @param shadowR Red component of the shadow color (0.0 - 1.0) (number)
	-- @param shadowG Green component of the shadow color (0.0 - 1.0) (number)
	-- @param shadowB Blue component of the shadow color (0.0 - 1.0) (number)
	-- @param shadowAlpha Alpha (opacity) of the text's shadow (0.0 = fully transparent, 1.0 = fully opaque) (number)
	------------------------------------
	-- SetShadowColor
	function SetShadowColor(self, ...)
		return self.__Text:SetShadowColor(...)
	end

	------------------------------------
	--- Sets the offset of the font instance's text shadow from its text
	-- @name Font:SetShadowOffset
	-- @class function
	-- @param xOffset Horizontal distance between the text and its shadow (in pixels) (number)
	-- @param yOffset Vertical distance between the text and its shadow (in pixels) (number)
	------------------------------------
	-- SetShadowOffset
	function SetShadowOffset(self, ...)
		return self.__Text:SetShadowOffset(...)
	end

	------------------------------------
	--- Sets the font instance's amount of spacing between lines
	-- @name Font:SetSpacing
	-- @class function
	-- @param spacing Amount of space between lines of text (in pixels) (number)
	------------------------------------
	-- SetSpacing
	function SetSpacing(self, ...)
		self.__Text:SetSpacing(...)
		Ajust4Font(self)
	end

	------------------------------------
	--- Sets the font instance's default text color. This color is used for otherwise unformatted text displayed using the font instance; however, portions of the text may be colored differently using the colorString format (commonly seen in hyperlinks).
	-- @name Font:SetTextColor
	-- @class function
	-- @param textR Red component of the text color (0.0 - 1.0) (number)
	-- @param textG Green component of the text color (0.0 - 1.0) (number)
	-- @param textB Blue component of the text color (0.0 - 1.0) (number)
	-- @param textAlpha Alpha (opacity) of the text (0.0 = fully transparent, 1.0 = fully opaque) (number)
	------------------------------------
	-- SetTextColor
	function SetTextColor(self, ...)
		return self.__Text:SetTextColor(...)
	end

	------------------------------------
	--- Sets the font's properties to match those of another Font object. Unlike Font:SetFontObject(), this method allows one-time reuse of another font object's properties without continuing to inherit future changes made to the other object's properties.
	-- @name Font:CopyFontObject
	-- @class function
	-- @param object Reference to a Font object (font)
	-- @param name Global name of a Font object (string)
	------------------------------------
	-- CopyFontObject
	function CopyFontObject(self, ...)
		self.__Text:CopyFontObject(...)
		Ajust4Font(self)
	end

	------------------------------------
	--- Gets whether long lines of text are indented when wrapping
	-- @name Font:GetIndentedWordWrap
	-- @class function
	------------------------------------
	-- GetIndentedWordWrap
	function GetIndentedWordWrap(self, ...)
		return self.__Text:GetIndentedWordWrap(...)
	end

	------------------------------------
	--- Sets whether long lines of text are indented when wrapping
	-- @name Font:SetIndentedWordWrap
	-- @class function
	------------------------------------
	-- SetIndentedWordWrap
	function SetIndentedWordWrap(self, ...)
		self.__Text:SetIndentedWordWrap(...)
		Ajust4Font(self)
	end

	------------------------------------
	---
	-- @name EditBox:ClearHistory
	-- @class function
	------------------------------------
	function ClearHistory(self, ...)
		return self.__Text:ClearHistory(...)
	end

	------------------------------------
	--- Returns the cursor's numeric position in the edit box, taking UTF-8 multi-byte character into account. If the EditBox contains multi-byte Unicode characters, the GetCursorPosition() method will not return correct results, as it considers each eight byte character to count as a single glyph.  This method properly returns the position in the edit box from the perspective of the user.
	-- @name EditBox:GetUTF8CursorPosition
	-- @class function
	-- @return position - The cursor's numeric position (leftmost position is 0), taking UTF8 multi-byte characters into account. (number)
	------------------------------------
	function GetUTF8CursorPosition(self, ...)
		return self.__Text:GetUTF8CursorPosition(...)
	end

	------------------------------------
	---
	-- @name EditBox:IsCountInvisibleLetters
	-- @class function
	------------------------------------
	function IsCountInvisibleLetters(self, ...)
		return self.__Text:IsCountInvisibleLetters(...)
	end

	------------------------------------
	--- Returns whether the edit box is in Input Method Editor composition mode. Character composition mode is used for input methods in which multiple keypresses generate one printed character. In such input methods, the edit box's OnChar script is run for each keypress -- if the OnChar script should act only when a complete character is entered in the edit box, :IsInIMECompositionMode() can be used to test for such cases.</p>
	--- <p>This mode is common in clients for languages using non-Roman characters (such as Chinese or Korean), but can still occur in client languages using Roman scripts (e.g. English) -- such as when typing accented characters on the Mac client (e.g. typing "option-u" then "e" to insert the character "?").
	-- @name EditBox:IsInIMECompositionMode
	-- @class function
	-- @return enabled - 1 if the edit box is in IME character composition mode; otherwise nil (1nil)
	------------------------------------
	function IsInIMECompositionMode(self, ...)
		return self.__Text:IsInIMECompositionMode(...)
	end

	------------------------------------
	---
	-- @name EditBox:SetCountInvisibleLetters
	-- @class function
	------------------------------------
	function SetCountInvisibleLetters(self, ...)
		return self.__Text:SetCountInvisibleLetters(...)
	end

	------------------------------------
	--- Add text to the edit history.
	-- @name  MultiLineTextBox:AddHistoryLine
	-- @class function
	-- @param text Text to be added to the edit box's list of history lines
	-- @usage  MultiLineTextBox:AddHistoryLine("This is a line")
	------------------------------------
	function AddHistoryLine(self, ...)
		return self.__Text:AddHistoryLine(...)
	end

	------------------------------------
	--- Releases keyboard input focus from the edit box
	-- @name  MultiLineTextBox:ClearFocus
	-- @class function
	-- @usage  MultiLineTextBox:ClearFocus()
	------------------------------------
	function ClearFocus(self, ...)
		return self.__Text:ClearFocus(...)
	end

	------------------------------------
	--- Return whether only alt+arrow keys work for navigating the edit box, not arrow keys alone.
	-- @name  MultiLineTextBox:GetAltArrowKeyMode
	-- @class function
	-- @return true if only alt+arrow keys work for navigating the edit box, not arrow keys alone
	-- @usage  MultiLineTextBox:GetAltArrowKeyMode()
	------------------------------------
	function GetAltArrowKeyMode(self, ...)
		return self.__Text:GetAltArrowKeyMode(...)
	end

	------------------------------------
	--- Gets the blink speed of the EditBox in seconds
	-- @name  MultiLineTextBox:GetBlinkSpeed
	-- @class function
	-- @return the blink speed of the EditBox in seconds
	-- @usage  MultiLineTextBox:GetBlinkSpeed()
	------------------------------------
	function GetBlinkSpeed(self, ...)
		return self.__Text:GetBlinkSpeed(...)
	end

	------------------------------------
	--- Gets the position of the cursor inside the EditBox
	-- @name  MultiLineTextBox:GetCursorPosition
	-- @class function
	-- @return the position of the cursor inside the EditBox
	-- @usage  MultiLineTextBox:GetCursorPosition()
	------------------------------------
	function GetCursorPosition(self, ...)
		return self.__Text:GetCursorPosition(...)
	end

	------------------------------------
	--- Get the number of history lines for this edit box
	-- @name  MultiLineTextBox:GetHistoryLines
	-- @class function
	-- @return the number of history lines for this edit box
	-- @usage  MultiLineTextBox:GetHistoryLines()
	------------------------------------
	function GetHistoryLines(self, ...)
		return self.__Text:GetHistoryLines(...)
	end

	------------------------------------
	--- Get the input language (locale based not in-game)
	-- @name  MultiLineTextBox:GetInputLanguage
	-- @class function
	-- @return the input language (locale based not in-game)
	-- @usage  MultiLineTextBox:GetInputLanguage()
	------------------------------------
	function GetInputLanguage(self, ...)
		return self.__Text:GetInputLanguage(...)
	end

	------------------------------------
	--- Gets the maximum number bytes allowed in the EditBox
	-- @name  MultiLineTextBox:GetMaxBytes
	-- @class function
	-- @return the maximum number bytes allowed in the EditBox
	-- @usage  MultiLineTextBox:GetMaxBytes()
	------------------------------------
	function GetMaxBytes(self, ...)
		return self.__Text:GetMaxBytes(...)
	end

	------------------------------------
	--- Gets the maximum number of letters allowed in the EditBox
	-- @name  MultiLineTextBox:GetMaxLetters
	-- @class function
	-- @return the maximum number of letters allowed in the EditBox
	-- @usage  MultiLineTextBox:GetMaxLetters()
	------------------------------------
	function GetMaxLetters(self, ...)
		return self.__Text:GetMaxLetters(...)
	end

	------------------------------------
	--- Gets the number of letters in the box.
	-- @name  MultiLineTextBox:GetNumLetters
	-- @class function
	-- @return he number of letters in the box
	-- @usage  MultiLineTextBox:GetNumLetters()
	------------------------------------
	function GetNumLetters(self, ...)
		return self.__Text:GetNumLetters(...)
	end

	------------------------------------
	--- Get the contents of the edit box as a number
	-- @name  MultiLineTextBox:GetNumber
	-- @class function
	-- @return the contents of the edit box as a number
	-- @usage  MultiLineTextBox:GetNumber()
	------------------------------------
	function GetNumber(self, ...)
		return self.__Text:GetNumber(...)
	end

	------------------------------------
	--- Get the current text contained in the edit box.
	-- @name  MultiLineTextBox:GetText
	-- @class function
	-- @return the current text contained in the edit box
	-- @usage  MultiLineTextBox:GetText()
	------------------------------------
	function GetText(self, ...)
		return self.__Text:GetText(...)
	end

	------------------------------------
	--- Gets the insets from the edit box's edges which determine its interactive text area
	-- @name  MultiLineTextBox:GetTextInsets
	-- @class function
	-- @return left - Distance from the left edge of the edit box to the left edge of its interactive text area (in pixels)
	-- @return right - Distance from the right edge of the edit box to the right edge of its interactive text area (in pixels)
	-- @return top - Distance from the top edge of the edit box to the top edge of its interactive text area (in pixels)
	-- @return bottom - Distance from the bottom edge of the edit box to the bottom edge of its interactive text area (in pixels)
	-- @usage  MultiLineTextBox:GetTextInsets()
	------------------------------------
	function GetTextInsets(self, ...)
		return self.__Text:GetTextInsets(...)
	end

	------------------------------------
	--- Selects all or a portion of the text in the edit box
	-- @name  MultiLineTextBox:HighlightText
	-- @class function
	-- @param start Optional,Character position at which to begin the selection (between 0, for the position before the first character, and  MultiLineTextBox:GetNumLetters(), for the position after the last character); defaults to 0 if not specified
	-- @param end Optional,Character position at which to end the selection; if not specified or if less than start, selects all characters after the start  position; if equal to start, selects nothing and positions the cursor at the start position
	-- @usage  MultiLineTextBox:HighlightText(1, 10)
	------------------------------------
	function HighlightText(self, ...)
		local startp, endp = ...

		if not startp then
			startp = 0
		end

		if not endp then
			endp = self.__Text.Text:len()
		end

		if endp < startp then
			startp, endp = endp, startp
		end

		if startp ~= endp and self.__OperationOnLine then
			SaveOperation(self)
		end

		self.__HighlightTextStart, self.__HighlightTextEnd = startp, endp

		return self.__Text:HighlightText(startp, endp)
	end

	------------------------------------
	--- Insert text into the edit box.
	-- @name  MultiLineTextBox:Insert
	-- @class function
	-- @param text Text to be inserted
	-- @usage  MultiLineTextBox:Insert("    ")
	------------------------------------
	function Insert(self, ...)
		return self.__Text:Insert(...)
	end

	------------------------------------
	--- Determine if the EditBox has autofocus enabled
	-- @name  MultiLineTextBox:IsAutoFocus
	-- @class function
	-- @return true if the EditBox has autofocus enabled
	-- @usage  MultiLineTextBox:IsAutoFocus()
	------------------------------------
	function IsAutoFocus(self, ...)
		return self.__Text:IsAutoFocus(...)
	end

	------------------------------------
	--- Determine if the EditBox accepts multiple lines
	-- @name  MultiLineTextBox:IsMultiLine
	-- @class function
	-- @return true if the EditBox accepts multiple lines
	-- @usage  MultiLineTextBox:IsMultiLine()
	------------------------------------
	function IsMultiLine(self, ...)
		return self.__Text:IsMultiLine(...)
	end

	------------------------------------
	--- Determine if the EditBox only accepts numeric input
	-- @name  MultiLineTextBox:IsNumeric
	-- @class function
	-- @return true if the EditBox only accepts numeric input
	-- @usage  MultiLineTextBox:IsNumeric()
	------------------------------------
	function IsNumeric(self, ...)
		return self.__Text:IsNumeric(...)
	end

	------------------------------------
	--- Determine if the EditBox performs password masking
	-- @name  MultiLineTextBox:IsPassword
	-- @class function
	-- @return true if the EditBox performs password masking
	-- @usage  MultiLineTextBox:IsPassword()
	------------------------------------
	function IsPassword(self, ...)
		return self.__Text:IsPassword(...)
	end

	------------------------------------
	--- Make only alt+arrow keys work for navigating the edit box, not arrow keys alone.
	-- @name  MultiLineTextBox:SetAltArrowKeyMode
	-- @class function
	-- @param enable True to cause the edit box to ignore arrow key presses unless the Alt key is held; false to allow unmodified arrow key presses for cursor movement
	-- @usage  MultiLineTextBox:SetAltArrowKeyMode(true)
	------------------------------------
	function SetAltArrowKeyMode(self, ...)
		return self.__Text:SetAltArrowKeyMode(...)
	end

	------------------------------------
	--- Set whether or not the editbox will attempt to get input focus when it gets shown (default: true)
	-- @name  MultiLineTextBox:SetAutoFocus
	-- @class function
	-- @param enable True to enable the edit box to automatically acquire keyboard input focus; false to disable
	-- @usage  MultiLineTextBox:SetAutoFocus()
	------------------------------------
	function SetAutoFocus(self, ...)
		return self.__Text:SetAutoFocus(...)
	end

	------------------------------------
	--- Sets the rate at which the text insertion blinks when the edit box is focused
	-- @name  MultiLineTextBox:SetBlinkSpeed
	-- @class function
	-- @param duration Amount of time for which the cursor is visible during each "blink" (in seconds)
	-- @usage  MultiLineTextBox:SetBlinkSpeed(2)
	------------------------------------
	function SetBlinkSpeed(self, ...)
		return self.__Text:SetBlinkSpeed(...)
	end

	------------------------------------
	--- Set the position of the cursor within the EditBox
	-- @name  MultiLineTextBox:SetCursorPosition
	-- @class function
	-- @param position New position for the keyboard input cursor (between 0, for the position before the first character, and  MultiLineTextBox:GetNumLetters(), for the position after the last character)
	-- @usage  MultiLineTextBox:SetCursorPosition(123)
	------------------------------------
	function SetCursorPosition(self, position)
		if self.__OperationOnLine then
			SaveOperation(self)
		end

		return self.__Text:SetCursorPosition(position)
	end

	------------------------------------
	--- Move input focus (the cursor) to this editbox
	-- @name  MultiLineTextBox:SetFocus
	-- @class function
	-- @usage  MultiLineTextBox:SetFocus()
	------------------------------------
	function SetFocus(self, ...)
		return self.__Text:SetFocus(...)
	end

	------------------------------------
	--- Sets the maximum number of history lines stored by the edit box
	-- @name  MultiLineTextBox:SetHistoryLines
	-- @class function
	-- @param count Maximum number of history lines to be stored by the edit box
	-- @usage  MultiLineTextBox:SetHistoryLines(12)
	------------------------------------
	function SetHistoryLines(self, ...)
		return self.__Text:SetHistoryLines(...)
	end

	------------------------------------
	--- Sets the maximum number of bytes of text allowed in the edit box
	-- @name  MultiLineTextBox:SetMaxBytes
	-- @class function
	-- @param maxBytes Maximum number of text bytes allowed in the edit box, or 0 for no limit
	-- @usage  MultiLineTextBox:SetMaxBytes(1024)
	------------------------------------
	function SetMaxBytes(self, ...)
		return self.__Text:SetMaxBytes(...)
	end

	------------------------------------
	--- Sets the maximum number of text characters allowed in the edit box
	-- @name  MultiLineTextBox:SetMaxLetters
	-- @class function
	-- @param maxLetters Maximum number of text characters allowed in the edit box, or 0 for no limit
	-- @usage  MultiLineTextBox:SetMaxLetters(1024)
	------------------------------------
	function SetMaxLetters(self, ...)
		return self.__Text:SetMaxLetters(...)
	end

	------------------------------------
	--- Sets whether the edit box shows more than one line of text, no use
	-- @name  MultiLineTextBox:SetMultiLine
	-- @class function
	-- @param multiLine True to allow the edit box to display more than one line of text; false for single-line display
	-- @usage  MultiLineTextBox:SetMultiLine(true)
	------------------------------------
	function SetMultiLine(self, ...)
		error("This editbox must be multi-line", 2)
	end

	------------------------------------
	--- Sets the contents of the edit box to a number
	-- @name  MultiLineTextBox:SetNumber
	-- @class function
	-- @param num New numeric content for the edit box
	-- @usage  MultiLineTextBox:SetNumber(1234)
	------------------------------------
	function SetNumber(self, ...)
		return self.__Text:SetNumber(...)
	end

	------------------------------------
	--- Sets whether the edit box only accepts numeric input
	-- @name  MultiLineTextBox:SetNumeric
	-- @class function
	-- @param enable True to allow only numeric input; false to allow any text
	-- @usage  MultiLineTextBox:SetNumeric(false)
	------------------------------------
	function SetNumeric(self, ...)
		return self.__Text:SetNumeric(...)
	end

	------------------------------------
	--- Sets whether the text entered in the edit box is masked
	-- @name  MultiLineTextBox:SetPassword
	-- @class function
	-- @param enable True to mask text entered in the edit box with asterisk characters (*); false to show the actual text entered
	-- @usage  MultiLineTextBox:SetPassword(false)
	------------------------------------
	function SetPassword(self, ...)
		return self.__Text:SetPassword(...)
	end

	------------------------------------
	--- Sets the edit box's text contents
	-- @name  MultiLineTextBox:SetText
	-- @class function
	-- @param text Text to be placed in the edit box
	-- @usage  MultiLineTextBox:SetText("Hello World")
	------------------------------------
	function SetText(self, text)
		text = tostring(text) or ""

		-- Clear operation history
		wipe(self.__Operation)

		wipe(self.__OperationStart)
		wipe(self.__OperationEnd)
		wipe(self.__OperationBackUp)

		wipe(self.__OperationFinalStart)
		wipe(self.__OperationFinalEnd)
		wipe(self.__OperationData)

		self.__OperationIndex = 0

		-- Clear now operation
		self.__OperationOnLine = nil
		self.__OperationBackUpOnLine = nil
		self.__OperationStartOnLine = nil
		self.__OperationEndOnLine = nil

		self.__Text.Text = text

		AdjustCursorPosition(self, 0)
	end

	------------------------------------
	--- Sets the edit box's text contents without clear the operation list
	-- @name  MultiLineTextBox:SetText
	-- @class function
	-- @param text Text to be placed in the edit box
	-- @usage  MultiLineTextBox:SetText("Hello World")
	------------------------------------
	function AdjustText(self, text)
		self.__Text.Text = text
	end

	------------------------------------
	--- Sets the insets from the edit box's edges which determine its interactive text area
	-- @name  MultiLineTextBox:SetTextInsets
	-- @class function
	-- @param left Distance from the left edge of the edit box to the left edge of its interactive text area (in pixels)
	-- @param right Distance from the right edge of the edit box to the right edge of its interactive text area (in pixels)
	-- @param top Distance from the top edge of the edit box to the top edge of its interactive text area (in pixels)
	-- @param bottom Distance from the bottom edge of the edit box to the bottom edge of its interactive text area (in pixels)
	-- @usage  MultiLineTextBox:SetTextInsets(4, 4, 6, 6)
	------------------------------------
	function SetTextInsets(self, ...)
		self.__Text:SetTextInsets(...)
		Ajust4Font(self)
	end

	------------------------------------
	--- Switches the edit box's language input mode
	-- @name  MultiLineTextBox:ToggleInputLanguage
	-- @class function
	-- @usage  MultiLineTextBox:ToggleInputLanguage()
	------------------------------------
	function ToggleInputLanguage(self, ...)
		return self.__Text:ToggleInputLanguage(...)
	end

	------------------------------------
	--- Returns whether the edit box is currently focused for keyboard input
	-- @name  MultiLineTextBox:HasFocus
	-- @class function
	-- @return True if the edit box is currently focused for keyboard input
	-- @usage  MultiLineTextBox:HasFocus()
	------------------------------------
	function HasFocus(self, ...)
		return self.__Text:HasFocus(...)
	end

	------------------------------------
	--- Whether the MultiLineTextBox has operation can be undo.
	-- @name  MultiLineTextBox:CanUndo
	-- @class function
	-- @return true if the MultiLineTextBox can undo operations
	-- @usage  MultiLineTextBox:CanUndo()
	------------------------------------
	function CanUndo(self)
		return self.__OperationIndex > 0
	end

	------------------------------------
	--- Undo the operation.
	-- @name  MultiLineTextBox:Undo
	-- @class function
	-- @usage  MultiLineTextBox:Undo()
	------------------------------------
	function Undo(self)
		SaveOperation(self)

		if self.__OperationIndex > 0 then
			local idx = self.__OperationIndex
			local text = self.__Text.Text
			local startp, endp = GetLines(text, self.__OperationFinalStart[idx], self.__OperationFinalEnd[idx])

			self.__Text.Text = ReplaceBlock(text, startp, endp, self.__OperationBackUp[idx])

			startp, endp = self.__OperationStart[idx], self.__OperationEnd[idx]

			if self.__Operation[idx] == _Operation.DELETE then
				AdjustCursorPosition(self, self.__OperationStart[idx])

				self:HighlightText(self.__OperationStart[idx], self.__OperationStart[idx])
			elseif self.__Operation[idx] == _Operation.BACKSPACE then
				AdjustCursorPosition(self, self.__OperationEnd[idx])

				self:HighlightText(self.__OperationEnd[idx], self.__OperationEnd[idx])
			else
				AdjustCursorPosition(self, self.__OperationEnd[idx])

				self:HighlightText(self.__OperationStart[idx], self.__OperationEnd[idx])
			end

			self.__OperationIndex = self.__OperationIndex - 1

			return self:Fire("OnOperationListChanged", startp, endp)
		end
	end

	------------------------------------
	--- Whether the MultiLineTextBox has operation can be redo.
	-- @name  MultiLineTextBox:CanRedo
	-- @class function
	-- @return true if the MultiLineTextBox can redo operations
	-- @usage  MultiLineTextBox:CanRedo()
	------------------------------------
	function CanRedo(self)
		return self.__OperationIndex < self.__MaxOperationIndex
	end

	------------------------------------
	--- Redo the operation.
	-- @name  MultiLineTextBox:Redo
	-- @class function
	-- @usage  MultiLineTextBox:Redo()
	------------------------------------
	function Redo(self)
		if self.__OperationIndex < self.__MaxOperationIndex then
			local idx = self.__OperationIndex + 1
			local text = self.__Text.Text

			local startp, endp = GetLines(text, self.__OperationStart[idx], self.__OperationEnd[idx])

			self.__Text.Text = ReplaceBlock(text, startp, endp, self.__OperationData[idx])

			startp, endp = self.__OperationFinalStart[idx], self.__OperationFinalEnd[idx]

			AdjustCursorPosition(self, self.__OperationFinalEnd[idx])

			self:HighlightText(self.__OperationFinalEnd[idx], self.__OperationFinalEnd[idx])

			self.__OperationIndex = self.__OperationIndex + 1

			return self:Fire("OnOperationListChanged", startp, endp)
		end
	end

	------------------------------------
	--- Reset the MultiLineTextBox's modified state
	-- @name  MultiLineTextBox:ResetModifiedState
	-- @class function
	-- @usage  MultiLineTextBox:ResetModifiedState()
	------------------------------------
	function ResetModifiedState(self)
		self.__DefaultText = self.__Text.Text
	end

	------------------------------------
	--- Whether the MultiLineTextBox is modified
	-- @name  MultiLineTextBox:IsModified
	-- @class function
	-- @return true if the MultiLineTextBox is modified
	-- @usage  MultiLineTextBox:IsModified()
	------------------------------------
	function IsModified(self)
		return self.__DefaultText ~= self.__Text.Text
	end

	------------------------------------
	--- Register a short-key combied with ctrl
	-- @name  MultiLineTextBox:RegisterControlKey
	-- @class function
	-- @param key the short key
	-- @usage  MultiLineTextBox:RegisterControlKey('a')
	------------------------------------
	function RegisterControlKey(self, key)
		if type(key) ~= "string" or strlen(key) ~= 1 then
			error("Usage : MultiLineTextBox:RegisterControlKey(key) - 'key' must be [0-9] or [A-Z], got nil.", 2)
		end

		key = strupper(key)

		if not key:match("%w") then
			error("Usage : MultiLineTextBox:RegisterControlKey(key) - 'key' must be [0-9] or [A-Z].", 2)
		end

		self.__RegisterControl = self.__RegisterControl or {}
		self.__RegisterControl[key] = true
	end

	------------------------------------
	--- UnRegister a short-key combied with ctrl
	-- @name  MultiLineTextBox:UnRegisterControlKey
	-- @class function
	-- @param key the short key
	-- @usage  MultiLineTextBox:UnRegisterControlKey('a')
	------------------------------------
	function UnRegisterControlKey(self, key)
		if type(key) ~= "string" or strlen(key) ~= 1 then
			return
		end

		key = strupper(key)

		if not key:match("%w") then
			return
		end

		self.__RegisterControl = self.__RegisterControl or {}
		self.__RegisterControl[key] = nil
	end

	------------------------------------
	--- Set the tabwidth for the MultiLineTextBox
	-- @name  MultiLineTextBox:SetTabWidth
	-- @class function
	-- @param tabWidth the tab's width
	-- @usage  MultiLineTextBox:SetTabWidth(3)
	------------------------------------
	function SetTabWidth(self, tabWidth)
		tabWidth = tonumber(tabWidth) and floor(tonumber(tabWidth)) or _TabWidth

		if tabWidth < 1 then
			error("The TabWidth must be greater than 0.", 2)
		end

		local oldTab = self:GetTabWidth()

		if oldTab ~= tabWidth then
			self.__TabWidth = tabWidth

			-- modify the line head space
			local text = self.__Text.Text
			local lineBreak

			if text == "" then return end

			if text:find("\n") then
				lineBreak = "\n"
			elseif text:find("\r") then
				lineBreak = "\r"
			else
				lineBreak = false
			end

			local headSpace = text:match("^%s+")

			if headSpace and headSpace ~= "" then
				local len = headSpace:len()

				text = strrep(" ", floor(len / oldTab) * tabWidth) .. text:sub(len + 1)
			end

			if lineBreak then
				text = text:gsub(lineBreak .. "(%s+)", function(str)
					local len = str:len()

					len = floor(len / oldTab) * tabWidth
					return lineBreak .. strrep(" ", len)
				end)
			end

			self.__Text.Text = text

			AdjustCursorPosition(self, 0)

			-- Clear operation history
			wipe(self.__Operation)

			wipe(self.__OperationStart)
			wipe(self.__OperationEnd)
			wipe(self.__OperationBackUp)

			wipe(self.__OperationFinalStart)
			wipe(self.__OperationFinalEnd)
			wipe(self.__OperationData)

			self.__OperationIndex = 0

			-- Clear now operation
			self.__OperationOnLine = nil
			self.__OperationBackUpOnLine = nil
			self.__OperationStartOnLine = nil
			self.__OperationEndOnLine = nil
		end
	end

	------------------------------------
	--- Get the tabwidth for the MultiLineTextBox
	-- @name  MultiLineTextBox:GetTabWidth
	-- @class function
	-- @return tabWidth the tab's width
	-- @usage  MultiLineTextBox:GetTabWidth()
	------------------------------------
	function GetTabWidth(self)
		return self.__TabWidth or _TabWidth
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- Font
	property "Font" {
		Get = function(self)
			return self.__Text.Font
		end,
		Set = function(self, font)
			self.__Text.Font = font

			Ajust4Font(self)
		end,
		Type = FontType,
	}
	-- FontObject
	property "FontObject" {
		Get = function(self)
			return self:GetFontObject()
		end,
		Set = function(self, fontObject)
			self:SetFontObject(fontObject)
		end,
		Type = Font + String + nil,
	}
	-- ShadowColor
	property "ShadowColor" {
		Get = function(self)
			return ColorType(self:GetShadowColor())
		end,
		Set = function(self, color)
			self:SetShadowColor(color.r, color,g, color.b, color.a)
		end,
		Type = ColorType,
	}
	-- ShadowOffset
	property "ShadowOffset" {
		Get = function(self)
			return Dimension(self:GetShadowOffset())
		end,
		Set = function(self, offset)
			self:SetShadowOffset(offset.x, offset.y)
		end,
		Type = Dimension,
	}
	-- Spacing
	property "Spacing" {
		Get = function(self)
			return self:GetSpacing()
		end,
		Set = function(self, spacing)
			self:SetSpacing(spacing)
		end,
		Type = Number,
	}
	-- TextColor
	property "TextColor" {
		Get = function(self)
			return ColorType(self:GetTextColor())
		end,
		Set = function(self, color)
			self:SetTextColor(color.r, color,g, color.b, color.a)
		end,
		Type = ColorType,
	}
	-- NumericOnly
	property "NumericOnly" {
		Set = function(self, state)
			self:SetNumeric(state)
		end,

		Get = function(self)
			return (self:IsNumeric() and true) or false
		end,

		Type = Boolean,
	}
	-- Password
	property "Password" {
		Set = function(self, state)
			self:SetPassword(state)
		end,

		Get = function(self)
			return (self:IsPassword() and true) or false
		end,

		Type = Boolean,
	}
	-- AutoFocus
	property "AutoFocus" {
		Set = function(self, state)
			self:SetAutoFocus(state)
		end,

		Get = function(self)
			return (self:IsAutoFocus() and true) or false
		end,

		Type = Boolean,
	}
	-- HistoryLines
	property "HistoryLines" {
		Set = function(self, num)
			self:SetHistoryLines(num)
		end,

		Get = function(self)
			return self:GetHistoryLines()
		end,

		Type = Number,
	}
	-- Focus
	property "Focused" {
		Set = function(self, focus)
			if focus then
				self:SetFocus()
			else
				self:ClearFocus()
			end
		end,

		Get = function(self)
			return (self:HasFocus() and true) or false
		end,

		Type = Boolean,
	}
	-- AltArrowKeyMode
	property "AltArrowKeyMode" {
		Set = function(self, enable)
			self:SetAltArrowKeyMode(enable)
		end,

		Get = function(self)
			return (self:GetAltArrowKeyMode() and true) or false
		end,

		Type = Boolean,
	}
	-- BlinkSpeed
	property "BlinkSpeed" {
		Set = function(self, speed)
			self:SetBlinkSpeed(speed)
		end,

		Get = function(self)
			return self:GetBlinkSpeed()
		end,

		Type = Number,
	}
	-- CursorPosition
	property "CursorPosition" {
		Set = function(self, position)
			self:SetCursorPosition(position)
		end,

		Get = function(self)
			return self:GetCursorPosition()
		end,

		Type = Number,
	}
	-- MaxBytes
	property "MaxBytes" {
		Set = function(self, maxBytes)
			self:SetMaxBytes(maxBytes)
		end,

		Get = function(self)
			return self:GetMaxBytes()
		end,

		Type = Number,
	}
	-- MaxLetters
	property "MaxLetters" {
		Set = function(self, maxLetters)
			self:SetMaxLetters(maxLetters)
		end,

		Get = function(self)
			return self:GetMaxLetters()
		end,

		Type = Number,
	}
	-- Number
	property "Number" {
		Set = function(self, number)
			self:SetNumber(number)
		end,

		Get = function(self)
			return self:GetNumber()
		end,

		Type = Number,
	}
	-- Text
	property "Text" {
		Set = function(self, text)
			self:SetText(text)
		end,

		Get = function(self)
			return self:GetText()
		end,

		Type = String,
	}
	-- TextInsets
	property "TextInsets" {
		Set = function(self, RectInset)
			self:SetTextInsets(RectInset.left, RectInset.right, RectInset.top, RectInset.bottom)
		end,

		Get = function(self)
			return Inset(self:GetTextInsets())
		end,

		Type = Inset,
	}
	-- Editable
	property "Editable" {
		Set = function(self, flag)
			self.MouseEnabled = flag
			self.__Text.MouseEnabled = flag
			if not flag then
				self.__Text.AutoFocus = false
				if self.__Text:HasFocus() then
					self.__Text:ClearFocus()
				end
			end
		end,

		Get = function(self)
			return self.__Text.MouseEnabled
		end,

		Type = Boolean,
	}
	-- ShowLineNumber
	property "ShowLineNumber" {
		Set = function(self, flag)
			self.__LineNum.Visible = flag
			self.__Margin.Visible = flag

			Ajust4Font(self)
		end,

		Get = function(self)
			return self.__LineNum.Visible
		end,

		Type = Boolean,
	}
	-- TabWidth
	property "TabWidth" {
		Get = function(self)
			return self:GetTabWidth()
		end,
		Set = function(self, tabWidth)
			self:SetTabWidth(tabWidth)
		end,
		Type = Number + nil,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	local function Frame_OnMouseUp(self)
		if not self.__Text:HasFocus() then
			self.__Text:SetFocus()
		end
	end

    local function Margin_OnMouseDown(self)
		local l, b, w, h = self:GetRect()
		local e = self:GetEffectiveScale()

		self = self.__Container

		self.__MarginMouseDown = true

		local x, y, offsetX, offsetY, line, startp, endp
		local lineHeight = self.__LineNum.Font.height + self.__LineNum.Spacing
		local prevLine = nil

		local startLinep, endLinep, startLine

		while self.__MarginMouseDown do
			-- check if need select line
			x, y = _GetCursorPosition()

			x, y = x / e, y /e
			x = x - l

			offsetY = self.__LineNum:GetTop() -  y

			line = floor(offsetY  / lineHeight + 1)

			if x >= 0 and x <= w and y >= b and y <= b+h and self.__LineNum.Lines and self.__LineNum.Lines[line] then
				if not prevLine then
					first = false

					EndPrevKey(self)

					SaveOperation(self)
				end

				while self.__LineNum.Lines[line] == "" and line > 1 do
					line = line - 1
				end

				if line ~= prevLine then
					startp, endp = GetLines4Line(self, self.__LineNum.Lines[line])

					if not prevLine then
						self:SetFocus()

						startLine = line
						startLinep, endLinep = startp, endp
					end

					self.__HighlightTextStart, self.__HighlightTextEnd = nil, nil

					if line >= startLine then
						self.__MouseDownCur = startLinep
						self.CursorPosition = endp
					else
						self.__MouseDownCur = endLinep
						self.CursorPosition = startp
					end

					prevLine = line
				end
			end

			Threading.Sleep(0.1)
		end
    end

    local function Margin_OnMouseUp(self)
		self = self.__Container

		self.__MarginMouseDown = nil
    end

    local function OnCursorChanged(self, x, y, w, h)
		self = self.__Container

		-- Scroll
		if y and h then
			y = -y

			if y - h < self.Value then
				self.Value = (y - h > 0) and (y - h) or 0
			elseif y + h > self.Value + self.Height then
				self.Value = y + h - self.Height
			end
		end

		-- Cusotm part
		if self.__InCharComposition then return end

		local cursorPos = self.CursorPosition

		if cursorPos == self.__OldCursorPosition and self.__OperationOnLine ~= _Operation.CUT then
			return
		end

		self.__OldCursorPosition = cursorPos

		if self.__InPasting then
			self.__InPasting = nil
			local startp, endp = self.__HighlightTextStart, cursorPos
			self:HighlightText(cursorPos, cursorPos)

			return self:Fire("OnPasting", startp, endp)
		elseif self.__DBLCLKSELTEXT then
			local str = self.__Text.Text
			local startp, endp = GetWord(str, cursorPos)

			if startp and endp then
				AdjustCursorPosition(self, endp)

				self:HighlightText(startp - 1, endp)
			end

			self.__DBLCLKSELTEXT = nil
		elseif self.__MouseDownShift == false then
			-- First CursorChanged after mouse down if not press shift
			self:HighlightText(cursorPos, cursorPos)

			self.__MouseDownCur = cursorPos
			self.__MouseDownShift = nil
		elseif self.__MouseDownCur then
			if self.__MouseDownCur ~= cursorPos then
				-- Hightlight all
				if self.__HighlightTextStart and self.__HighlightTextEnd and self.__HighlightTextStart ~= self.__HighlightTextEnd then
					if self.__HighlightTextStart == self.__MouseDownCur then
						self:HighlightText(cursorPos, self.__HighlightTextEnd)
					elseif self.__HighlightTextEnd == self.__MouseDownCur then
						self:HighlightText(cursorPos, self.__HighlightTextStart)
					else
						self:HighlightText(self.__MouseDownCur, cursorPos)
					end
				else
					self:HighlightText(self.__MouseDownCur, cursorPos)
				end

				self.__MouseDownCur = cursorPos
			end
		elseif self.__BACKSPACE then

		elseif self.__DELETE then

		elseif self.__SKIPCURCHG then
			if tonumber(self.__SKIPCURCHG) then
				if self.__HighlightTextStart and self.__HighlightTextEnd and self.__HighlightTextStart ~= self.__HighlightTextEnd then
					if self.__HighlightTextStart == self.__SKIPCURCHG then
						self:HighlightText(cursorPos, self.__HighlightTextEnd)
					elseif self.__HighlightTextEnd == self.__SKIPCURCHG then
						self:HighlightText(cursorPos, self.__HighlightTextStart)
					else
						self:HighlightText(self.__SKIPCURCHG, cursorPos)
					end
				else
					self:HighlightText(self.__SKIPCURCHG, cursorPos)
				end
			end

			if not self.__SKIPCURCHGARROW then
				self.__SKIPCURCHG = nil
			else
				self.__SKIPCURCHG = cursorPos
			end
		else
			self:HighlightText(cursorPos, cursorPos)
		end

		if self.__OperationOnLine == _Operation.CUT then
			self:Fire("OnCut", self.__OperationStartOnLine, self.__OperationEndOnLine, self.__OperationBackUpOnLine:sub(self.__OperationStartOnLine, self.__OperationEndOnLine))
			SaveOperation(self)
		end

		return self:Fire("OnCursorChanged", x, y, w, h)
    end

	local function OnMouseDown(self, ...)
		self = self.__Container

		EndPrevKey(self)

		SaveOperation(self)

		self.__MouseDownCur = self.CursorPosition

		if IsShiftKeyDown() then
			self.__MouseDownShift = true
			self.__MouseDownTime = nil
		else
			self.__MouseDownShift = false
			if self.__MouseDownTime and GetTime() - self.__MouseDownTime < _DBL_CLK_CHK then
				-- mean double click
				self.__DBLCLKSELTEXT = true
				self.__OldCursorPosition = nil
			else
				self.__MouseDownTime = GetTime()
			end
		end

		return self:Fire("OnMouseDown", ...)
	end

	local function OnMouseUp(self, ...)
		self = self.__Container

		self.__MouseDownCur = nil
		self.__MouseDownShift = nil

		if self.__MouseDownTime and GetTime() - self.__MouseDownTime < _DBL_CLK_CHK then
			self.__MouseDownTime = GetTime()
		else
			self.__MouseDownTime = nil
		end

		return self:Fire("OnMouseUp", ...)
	end

    local function OnEscapePressed(self, ...)
        self:ClearFocus()
		self = self.__Container
		return self:Fire("OnEscapePressed", ...)
    end

    local function OnTextChanged(self, ...)
		self = self.__Container

		return self:Fire("OnTextChanged", ...)
	end

	local function OnSizeChanged(self)
		self = self.__Container
		UpdateLineNum(self)
		return self:FixHeight()
	end

    local function OnEditFocusGained(self, ...)
		self = self.__Container

		if _KeyScan.FocusEditor then
			EndPrevKey(_KeyScan.FocusEditor)
		end

		_KeyScan.FocusEditor = self
		_KeyScan.Visible = true

		return self:Fire("OnEditFocusGained", ...)
	end

    local function OnEditFocusLost(self, ...)
		self = self.__Container

		if _KeyScan.FocusEditor == self then
			EndPrevKey(self)
			_KeyScan.FocusEditor = nil
			_KeyScan.Visible = false
		end

		return self:Fire("OnEditFocusLost", ...)
	end

    local function OnEnterPressed(self, ...)
		self:Insert("\n")	-- Added for 3.3

		self = self.__Container

		return self:Fire("OnEnterPressed", ...)
	end

    local function OnInputLanguageChanged(self, ...)
		self = self.__Container
		return self:Fire("OnInputLanguageChanged", ...)
	end

    local function OnSpacePressed(self, ...)
		self = self.__Container
		return self:Fire("OnSpacePressed", ...)
	end

    local function OnTabPressed(self, ...)
		self = self.__Container

		local text = self.__Text.Text

		if self.__HighlightTextStart == 0 and self.__HighlightTextStart ~= self.__HighlightTextEnd and self.__HighlightTextEnd == self.__Text.Text:len() then
			-- just reload text
			self:SetText(self:GetText())
			return AdjustCursorPosition(self, 0)
		end

		local startp, endp, str, lineBreak
		local shiftDown = IsShiftKeyDown()
		local cursorPos = self.CursorPosition

		if self.__HighlightTextStart and self.__HighlightTextEnd and self.__HighlightTextEnd > self.__HighlightTextStart then
			startp, endp, str = GetLines(text, self.__HighlightTextStart, self.__HighlightTextEnd)

			if str:find("\n") then
				lineBreak = "\n"
			elseif str:find("\r") then
				lineBreak = "\r"
			else
				lineBreak = false
			end

			if lineBreak then
				if shiftDown then
					str = str:gsub("[^".. lineBreak .."]+", _ShiftIndentFunc[self.TabWidth])
				else
					str = str:gsub("[^".. lineBreak .."]+", _IndentFunc[self.TabWidth])
				end

				self.__Text.Text = ReplaceBlock(text, startp, endp, str)

				AdjustCursorPosition(self, startp + str:len() - 1)

				self:HighlightText(startp - 1, startp + str:len() - 1)
			else
				if shiftDown then
					cursorPos = startp - 1 + floor((cursorPos - startp) / self.TabWidth) * self.TabWidth

					AdjustCursorPosition(self, cursorPos)
				else
					cursorPos = self.TabWidth - (self.__HighlightTextStart - startp) % self.TabWidth

					str = str:sub(1, self.__HighlightTextStart - startp) .. strrep(" ", cursorPos) .. str:sub(self.__HighlightTextEnd + 2 - startp, -1)

					self.__Text.Text = ReplaceBlock(text, startp, endp, str)

					cursorPos = self.__HighlightTextStart + cursorPos - 1

					AdjustCursorPosition(self, cursorPos)
				end
			end
		else
			startp, endp, str = GetLines(text, cursorPos)

			if shiftDown then
				local _, len = str:find("^%s+")

				if len and len > 0 then
					if startp + len - 1 >= cursorPos then
						str = strrep(" ", len - self.TabWidth) .. str:sub(len + 1, -1)

						self.__Text.Text = ReplaceBlock(text, startp, endp, str)

						if cursorPos - self.TabWidth >= startp - 1 then
							AdjustCursorPosition(self, cursorPos - self.TabWidth)
						else
							AdjustCursorPosition(self, startp - 1)
						end
					else
						cursorPos = startp - 1 + floor((cursorPos - startp) / self.TabWidth) * self.TabWidth

						AdjustCursorPosition(self, cursorPos)
					end
				end
			else
				local byte = strbyte(text, cursorPos + 1)

				if byte == _Byte.RIGHTBRACKET or byte == _Byte.RIGHTPAREN then
					SaveOperation(self)

					AdjustCursorPosition(self, cursorPos + 1)
				else
					local len = self.TabWidth - (cursorPos - startp + 1) % self.TabWidth

					str = str:sub(1, cursorPos - startp + 1) .. strrep(" ", len) .. str:sub(cursorPos - startp + 2, -1)

					self.__Text.Text = ReplaceBlock(text, startp, endp, str)

					AdjustCursorPosition(self, cursorPos + len)
				end
			end
		end

		return self:Fire("OnTabPressed", ...)
	end

    local function OnTextSet(self, ...)
		self = self.__Container
		return self:Fire("OnTextSet", ...)
	end

	local function OnChar(self, ...)
		self = self.__Container

		if self.__InPasting or not self:HasFocus() then
			return
		end

		self.__InCharComposition = nil

		return self:Fire("OnChar", ...)
	end

	local function OnCharComposition(self, ...)
		self = self.__Container

		self.__InCharComposition = true

		return self:Fire("OnCharComposition", ...)
	end

	function _KeyScan:OnKeyDown(key)
		if _SkipKey[key] then return end

		if self.FocusEditor and key then
			local editor = self.FocusEditor
			local cursorPos = editor.CursorPosition

			local oper = _KEY_OPER[key]

			if oper then
				if oper == _Operation.CHANGE_CURSOR then

					if key == "PAGEUP" then
						local text = editor.__Text.Text
						local skipLine = floor(editor.Height / editor.ValueStep)
						local startp, endp, _, line = GetPrevLinesByReturn(text, cursorPos, skipLine)

						if line == 0 then
							return
						end

                        EndPrevKey(editor)

						SaveOperation(editor)

						if editor.Value > editor.Height then
							editor.Value = editor.Value - editor.Height
						else
							editor.Value = 0
						end

						if IsShiftKeyDown() then
							editor.__SKIPCURCHG = cursorPos
						end

						editor.CursorPosition = GetCursorPosByOffset(text, startp, GetOffsetByCursorPos(text, nil, cursorPos))

						return
					end

					if key == "PAGEDOWN" then
						local text = editor.__Text.Text
						local skipLine = floor(editor.Height / editor.ValueStep)
						local startp, endp, _, line = GetLinesByReturn(text, cursorPos, skipLine)

						if line == 0 then
							return
                        end

                        EndPrevKey(editor)

						SaveOperation(editor)

						local maxValue = editor.Container.Height - editor.Height

						if editor.Value + editor.Height < maxValue then
							editor.Value = editor.Value + editor.Height
						else
							editor.Value = maxValue
						end

						if IsShiftKeyDown() then
							editor.__SKIPCURCHG = cursorPos
						end

						editor.CursorPosition = GetCursorPosByOffset(text, endp, GetOffsetByCursorPos(text, nil, cursorPos))

						return
					end

					if key == "HOME" then
						local text = editor.__Text.Text
						local startp, endp = GetLines(text, cursorPos)
						local byte

						if startp - 1 == cursorPos then
							return
						end

                        EndPrevKey(editor)

						SaveOperation(editor)

						if IsShiftKeyDown() then
							editor.__SKIPCURCHG = cursorPos
						end

						return
					end

					if key == "END" then
						local startp, endp = GetLines(editor.__Text.Text, cursorPos)

						if endp == cursorPos then
							return
						end

                        EndPrevKey(editor)

						SaveOperation(editor)

						if IsShiftKeyDown() then
							editor.__SKIPCURCHG = cursorPos
						end

						return
					end

					if key == "UP" then
						local _, _, _, line = GetPrevLinesByReturn(editor.__Text.Text, cursorPos, 1)

						if line > 0 then
                            EndPrevKey(editor)

							SaveOperation(editor)

							if IsShiftKeyDown() then
								editor.__SKIPCURCHG = cursorPos
								editor.__SKIPCURCHGARROW = true
							end
						end

						return
					end

					if key == "DOWN" then
						local _, _, _, line = GetLinesByReturn(editor.__Text.Text, cursorPos, 1)

						if line > 0 then
                            EndPrevKey(editor)

							SaveOperation(editor)

							if IsShiftKeyDown()  then
								editor.__SKIPCURCHG = cursorPos
								editor.__SKIPCURCHGARROW = true
							end
						end

						return
					end

					if key == "RIGHT" then
						if cursorPos < editor.__Text.Text:len() then
                            EndPrevKey(editor)

							SaveOperation(editor)

							if IsShiftKeyDown() then
								editor.__SKIPCURCHG = cursorPos
								editor.__SKIPCURCHGARROW = true
							end
						end

						return
					end

					if key == "LEFT" then
						if cursorPos > 0 then
                            EndPrevKey(editor)

							SaveOperation(editor)

							if IsShiftKeyDown() then
								editor.__SKIPCURCHG = cursorPos
								editor.__SKIPCURCHGARROW = true
							end
						end

						return
					end
				end

				if key == "TAB" then
                    EndPrevKey(editor)
					return NewOperation(editor, _Operation.INPUTTAB)
				end

				if key == "DELETE" then
					if not editor.__DELETE and not IsShiftKeyDown() and (editor.__HighlightTextStart ~= editor.__HighlightTextEnd or cursorPos < editor.__Text.Text:len()) then
                        EndPrevKey(editor)
						editor.__DELETE = true
						NewOperation(editor, _Operation.DELETE)
						self:SetPropagateKeyboardInput(false)

						_Thread.Thread = Thread_DELETE
						return _Thread(editor)
					end
					return
				end

				if key == "BACKSPACE" then
					if not editor.__BACKSPACE and cursorPos > 0 then
                        EndPrevKey(editor)
						editor.__BACKSPACE = cursorPos
						NewOperation(editor, _Operation.BACKSPACE)
						self:SetPropagateKeyboardInput(false)

						_Thread.Thread = Thread_BACKSPACE
						return _Thread(editor)
					end
					return
				end

				if key == "ENTER" then
                    EndPrevKey(editor)
					-- editor.__SKIPCURCHG = true
					return NewOperation(editor, _Operation.ENTER)
				end
			end

            EndPrevKey(editor)

			if key:find("^F%d+") == 1 then
				if key == "F3" and editor.__InSearch then
					-- Continue Search
					Search2Next(editor)

					return
				end

				return editor:Fire("OnFunctionKey", key)
			end

			-- Don't consider multi-modified keys
			if IsShiftKeyDown() then
				-- shift+
			elseif IsAltKeyDown() then
				-- alt+
				return
			elseif IsControlKeyDown() then
				if key == "A" then
					editor:HighlightText()
					return
				elseif key == "V" then
					editor.__InPasting = true
					return NewOperation(editor, _Operation.PASTE)
				elseif key == "C" then
					-- do nothing
					return
				elseif key == "Z" then
					return editor:Undo()
				elseif key == "Y" then
					return editor:Redo()
				elseif key == "X" then
					if editor.__HighlightTextStart ~= editor.__HighlightTextEnd then
						NewOperation(editor, _Operation.CUT)
					end
					return
				elseif key == "F" then
					_Thread.Thread = Thread_FindText
					return _Thread(editor)
				elseif key == "G" then
					_Thread.Thread = Thread_GoLine
					return _Thread(editor)
				elseif editor.__RegisterControl and editor.__RegisterControl[key] then
					return editor:Fire("OnControlKey", key)
				else
					return
				end
			end

			return NewOperation(editor, _Operation.INPUTCHAR)
		end
	end

	function _KeyScan:OnKeyUp(key)
		self:SetPropagateKeyboardInput(true)

		if self.FocusEditor then
			if key == "DELETE" then
				self.FocusEditor.__DELETE = nil
			end
			if key == "BACKSPACE" then
				self.FocusEditor.__BACKSPACE = nil
			end
		end

		if _Thread:IsSuspended() then
			_Thread:Resume()
		end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function MultiLineTextBox(self, name, parent)
		local container = self.Container

		local editbox = EditBox("Text", container)
		editbox:SetPoint("TOPLEFT", container, "TOPLEFT", 0, 0)
		editbox:SetPoint("TOPRIGHT", container, "TOPRIGHT", 0, 0)
		editbox:SetMultiLine(true)
		editbox:SetTextInsets(5, 5, 3, 3)
		editbox:EnableMouse(true)
		editbox:SetAutoFocus(false)
		editbox:SetFontObject("GameFontNormal")
		editbox.Text = ""
		editbox:ClearFocus()

		local lineNum = FontString("LineNum", container)
		lineNum:SetPoint("LEFT", container, "LEFT", 0, 0)
		lineNum:SetPoint("TOP", editbox, "TOP", 0, 0)
		lineNum.Visible = false
		lineNum.JustifyV = "TOP"
		lineNum.JustifyH = "CENTER"

		local margin = Frame("Margin", self)
		margin:SetPoint("TOPLEFT", self, "TOPLEFT", 5, -5)
		margin:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 5, 5)
		margin:SetPoint("RIGHT", lineNum, "RIGHT")
		margin.MouseEnabled = true
		margin.Visible = false

		local texture = Texture("LineNumBack", margin)
		texture:SetAllPoints(margin)
		texture.Color = ColorType(0.12, 0.12, 0.12, 0.8)
		texture.BlendMode = "ADD"

		margin.FrameStrata = "FULLSCREEN"

		self.__LineNum = lineNum
        self.__Text = editbox
		self.__Margin = margin
        editbox.__Container = self
        margin.__Container = self

		-- Operation Keep List
		self.__Operation = {}

		self.__OperationStart = {}
		self.__OperationEnd = {}
		self.__OperationBackUp = {}

		self.__OperationFinalStart = {}
		self.__OperationFinalEnd = {}
		self.__OperationData = {}

		self.__OperationIndex = 0
		self.__MaxOperationIndex = 0

		-- Settings
		Ajust4Font(self)

		self.OnMouseUp = self.OnMouseUp + Frame_OnMouseUp

		margin:ActiveThread("OnMouseUp", "OnMouseDown")
		margin.OnMouseDown = Margin_OnMouseDown
		margin.OnMouseUp = Margin_OnMouseUp

		editbox:ActiveThread("OnTabPressed")

		editbox.OnEscapePressed = editbox.OnEscapePressed + OnEscapePressed
		editbox.OnTextChanged = editbox.OnTextChanged + OnTextChanged
	    editbox.OnCursorChanged = editbox.OnCursorChanged + OnCursorChanged
	    editbox.OnEditFocusGained = editbox.OnEditFocusGained + OnEditFocusGained
	    editbox.OnEditFocusLost = editbox.OnEditFocusLost + OnEditFocusLost
	    editbox.OnEnterPressed = editbox.OnEnterPressed + OnEnterPressed
		editbox.OnSizeChanged = editbox.OnSizeChanged + OnSizeChanged
	    editbox.OnInputLanguageChanged = editbox.OnInputLanguageChanged + OnInputLanguageChanged
	    editbox.OnSpacePressed = editbox.OnSpacePressed + OnSpacePressed
	    editbox.OnTabPressed = editbox.OnTabPressed + OnTabPressed
	    editbox.OnTextSet = editbox.OnTextSet + OnTextSet
		editbox.OnCharComposition = editbox.OnCharComposition + OnCharComposition
		editbox.OnChar = editbox.OnChar + OnChar
		editbox.OnMouseDown = editbox.OnMouseDown + OnMouseDown
		editbox.OnMouseUp = editbox.OnMouseUp + OnMouseUp

		self:FixHeight()
	end
endclass "MultiLineTextBox"
