-- Author      : Kurapica
-- Create Date : 8/03/2008 17:14
--              2011/03/13 Recode as class
--              2012/04/04 Row Number is added.
--              2012/04/04 Undo redo system added, plenty function added
--              2012/04/10 Fix the margin click
--              2012/05/13 Fix delete on double click selected multi-text
--              2013/02/07 Recode for scrollForm's change, and fix the double click error
--              2013/05/15 Auto complete function added
--              2013/05/19 Auto pairs function added

-- Check Version
local version = 19

if not IGAS:NewAddon("IGAS.Widget.MultiLineTextBox", version) then
	return
end

_GetCursorPosition = _G.GetCursorPosition

class "MultiLineTextBox"
	inherit "ScrollForm"

	import "System.Threading"

	doc [======[
		@name MultiLineTextBox
		@type class
		@desc MultiLineTextBox is used as a multi-line text editor.
	]======]

	------------------------------------------------------
	-- Local Settings
	------------------------------------------------------
	_DBL_CLK_CHK = 0.3
	_FIRST_WAITTIME = 0.3
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

	-- Auto Pairs
	_AutoPairs = {
		[_Byte.LEFTBRACKET] = _Byte.RIGHTBRACKET, -- []
		[_Byte.LEFTPAREN] = _Byte.RIGHTPAREN, -- ()
		[_Byte.LEFTWING] = _Byte.RIGHTWING, --()
		[_Byte.SINGLE_QUOTE] = true, -- ''
		[_Byte.DOUBLE_QUOTE] = true, -- ''
		[_Byte.RIGHTBRACKET] = false,
		[_Byte.RIGHTPAREN] = false,
		[_Byte.RIGHTWING] = false,
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
	--_KeyScan:ActiveThread("OnKeyDown")

	------------------------------------------------------
	-- Thread Helper
	------------------------------------------------------
	_Thread = System.Threading.Thread()

	------------------------------------------------------
	-- Code smart helper
	------------------------------------------------------
	_List = List("IGAS_MultiLineTextBox_AutoComplete", IGAS.WorldFrame)
	_List.FrameStrata = "TOOLTIP"
	_List.DisplayItemCount = 5
	_List.Width = 150
	_List.Visible = false

	_AutoCacheKeys = {}
	_AutoCacheItems = {}
	_AutoWordWeightCache = {}
	_AutoWordMap = {}

	_AutoCheckKey = ""
	_AutoCheckWord = ""

	_List.Keys = _AutoCacheKeys
	_List.Items = _AutoCacheItems

	_BackAutoCache = {}

	------------------------------------------------------
	-- Short Key Block
	------------------------------------------------------
	_BtnBlockUp = SecureButton("IGAS_MultiLineTextBox_UpBlock", IGAS.WorldFrame)
	_BtnBlockDown = SecureButton("IGAS_MultiLineTextBox_DownBlock", IGAS.WorldFrame)
	_BtnBlockUp.Visible = false
	_BtnBlockDown.Visible = false

	------------------------------------------------------
	-- Local functions
	------------------------------------------------------
	local function Compare(t1, t2)
		t1 = t1 or ""
		t2 = t2 or ""

		local ut1 = strupper(t1)
		local ut2 = strupper(t2)

		if ut1 == ut2 then
			return t1 < t2
		else
			return ut1 < ut2
		end
	end

	local function CompareWeight(t1, t2)
		return (_AutoWordWeightCache[t1] or 0) < (_AutoWordWeightCache[t2] or 0)
	end

	local function GetIndex(list, name, sIdx, eIdx)
		if not sIdx then
			if not next(list) then
				return 0
			end
			sIdx = 1
			eIdx = #list

			-- Border check
			if Compare(name, list[sIdx]) then
				return 0
			elseif Compare(list[eIdx], name) then
				return eIdx
			end
		end

		if sIdx == eIdx then
			return sIdx
		end

		local f = floor((sIdx + eIdx) / 2)

		if Compare(name, list[f+1]) then
			return GetIndex(list, name, sIdx, f)
		else
			return GetIndex(list, name, f+1, eIdx)
		end
	end

	local function TransMatchWord(w)
		return "(["..w:lower()..w:upper().."])([%w_]-)"
	end

	local function RemoveColor(str)
		local byte
		local pos = 1
		local ret = ""

		if not str or #str == 0 then return "" end

		byte = strbyte(str, pos)

		while true do
			if byte == _Byte.VERTICAL then
				-- handle the color code
				pos = pos + 1
				byte = strbyte(str, pos)

				if byte == _Byte.c then
					pos = pos + 9
				elseif byte == _Byte.r then
					pos = pos + 1
				else
					pos = pos - 1
					break
				end

				byte = strbyte(str, pos)
			else
				if not byte then
					break
				end

				ret = ret .. strchar(byte)

				pos = pos + 1
				byte = strbyte(str, pos)
			end
		end

		return ret
	end

	local function ApplyColor(...)
		local ret = ""
		local word = ""
		local pos = 0

		local weight = 0
		local n = select('#', ...)

		for i = 1, n do
			word = select(i, ...)

			if i % 2 == 1 then
				pos = floor((i+1)/2)
				ret = ret .. FontColor.WHITE .. word .. FontColor.CLOSE

				if word ~= _AutoCheckKey:sub(pos, pos) then
					weight = weight + 1
				end
			else
				ret = ret .. FontColor.GRAY .. word .. FontColor.CLOSE

				if i < n then
					weight = weight + word:len()
				end
			end
		end

		_AutoWordWeightCache[_AutoCheckWord] = weight

		_AutoWordMap[_AutoCheckWord] = ret

		return ret
	end

	local function ReplaceBlock(str, startp, endp, replace)
		return str:sub(1, startp - 1) .. replace .. str:sub(endp + 1, -1)
	end

	doc [======[
		@name AdjustCursorPosition
		@type method
		@desc Set the cursor position without change the operation list
		@param pos number, the position of the cursor inside the MultiLineTextBox
		@return nil
	]======]
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

			lineNum.Height = self.__Text.Height

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

	local function ApplyAutoComplete(self)
		_List.Visible = false
		_List:Clear()

		if next(self.AutoCompleteList) then
			-- Handle the auto complete
			local startp, endp, word = GetWord(self.__Text.Text, self.CursorPosition)

			word = RemoveColor(word)

			wipe(_AutoCacheKeys)
			wipe(_AutoCacheItems)
			wipe(_AutoWordMap)
			wipe(_AutoWordWeightCache)

			if word and word:match("^[%w_]+$") then
				_AutoCheckKey = word

				word = word:lower()

				-- Match the auto complete list
				local uword = "^" .. word:gsub("[%w_]", TransMatchWord) .. "$"
				local lst = self.AutoCompleteList
				local header = word:sub(1, 1)

				if not header or #header == 0 then return end

				local sIdx = GetIndex(lst, header)

				if sIdx == 0 then sIdx = 1 end

				for i = sIdx, #lst do
					if #(lst[i]) == 0 or Compare(header, lst[i]:sub(1, 1)) then break end

					_AutoCheckWord = lst[i]

					if _AutoCheckWord:match(uword) then
						_AutoCheckWord:gsub(uword, ApplyColor)

						tinsert(_AutoCacheKeys, _AutoCheckWord)
					end

					Array.Sort(_AutoCacheKeys, CompareWeight)

					for i, v in ipairs(_AutoCacheKeys) do
						_AutoCacheItems[i] = _AutoWordMap[v]
					end
				end

				if #_AutoCacheKeys == 1 and _AutoCacheKeys[1] == _AutoCheckKey then
					wipe(_AutoCacheKeys)
					wipe(_AutoCacheItems)
				end
			end
		end
	end

	local function BlockShortKey()
		SetOverrideBindingClick(IGAS:GetUI(_BtnBlockDown), false, "DOWN", _BtnBlockDown.Name, "LeftButton")
		SetOverrideBindingClick(IGAS:GetUI(_BtnBlockUp), false, "UP", _BtnBlockUp.Name, "LeftButton")
	end

	local function UnblockShortKey()
		ClearOverrideBindings(IGAS:GetUI(_BtnBlockDown))
		ClearOverrideBindings(IGAS:GetUI(_BtnBlockUp))
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

			-- Auto pairs check
			local char = str:sub(prevPos, pos)
			local offset = pos

			char = RemoveColor(char)

			if char and char:len() == 1 and _AutoPairs[strbyte(char)] then
				offset = offset + 1

				byte = strbyte(str, offset)

				while true do
					if byte == _Byte.VERTICAL then
						-- handle the color code
						offset = offset + 1
						byte = strbyte(str, offset)

						if byte == _Byte.c then
							offset = offset + 9
						elseif byte == _Byte.r then
							offset = offset + 1
						else
							offset = offset - 1
							break
						end

						byte = strbyte(str, offset)
					else
						break
					end
				end

				if (_AutoPairs[strbyte(char)] == true and byte == strbyte(char)) or _AutoPairs[strbyte(char)] == byte then
					-- pass
				else
					offset = pos
				end
			end

			-- Delete
			str = ReplaceBlock(str, prevPos, offset, "")

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

		ApplyAutoComplete(self)

		self:Fire("OnBackspaceFinished")
	end

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	doc [======[
		@name OnTextChanged
		@type script
		@desc Run when the edit box's text is changed
		@param isUserInput boolean
	]======]
	script "OnTextChanged"

	doc [======[
		@name OnCursorChanged
		@type script
		@desc Run when the position of the text insertion cursor in the edit box changes
		@param x number, horizontal position of the cursor relative to the top left corner of the edit box (in pixels)
		@param y number, vertical position of the cursor relative to the top left corner of the edit box (in pixels)
		@param width number, width of the cursor graphic (in pixels)
		@param height number, height of the cursor graphic (in pixels); matches the height of a line of text in the edit box
	]======]
	script "OnCursorChanged"

	doc [======[
		@name OnEditFocusGained
		@type script
		@desc Run when the edit box becomes focused for keyboard input
	]======]
	script "OnEditFocusGained"

	doc [======[
		@name OnEditFocusLost
		@type script
		@desc Run when the edit box loses keyboard input focus
	]======]
	script "OnEditFocusLost"

	doc [======[
		@name OnEnterPressed
		@type script
		@desc Run when the Enter (or Return) key is pressed while the edit box has keyboard focus
	]======]
	script "OnEnterPressed"

	doc [======[
		@name OnEscapePressed
		@type script
		@desc Run when the Escape key is pressed while the edit box has keyboard focus
	]======]
	script "OnEscapePressed"

	doc [======[
		@name OnInputLanguageChanged
		@type script
		@desc Run when the edit box's language input mode changes
		@param language string, name of the new input language
	]======]
	script "OnInputLanguageChanged"

	doc [======[
		@name OnSpacePressed
		@type script
		@desc Run when the space bar is pressed while the edit box has keyboard focus
	]======]
	script "OnSpacePressed"

	doc [======[
		@name OnTabPressed
		@type script
		@desc Run when the Tab key is pressed while the edit box has keyboard focus
	]======]
	script "OnTabPressed"

	doc [======[
		@name OnTextSet
		@type script
		@desc Run when the edit box's text is set programmatically
	]======]
	script "OnTextSet"

	doc [======[
		@name OnChar
		@type script
		@desc Run for each text character typed in the frame
		@param char string, the text character typed
	]======]
	script "OnChar"

	doc [======[
		@name OnCharComposition
		@type script
		@desc Run when the edit box's input composition mode changes
		@param text string, The text entered
	]======]
	script "OnCharComposition"

	doc [======[
		@name OnFunctionKey
		@type script
		@desc Run when the edit box's FunctionKey is pressed
		@param key string, the function key (like 'F5')
	]======]
	script "OnFunctionKey"

	doc [======[
		@name OnControlKey
		@type script
		@desc Run when the edit box's control key is pressed
		@param text string, The text entered
	]======]
	script "OnControlKey"

	doc [======[
		@name OnOperationListChanged
		@type script
		@desc Run when the edit box's operation list is changed
		@param startp number, the start position
		@param endp number, the end position
	]======]
	script "OnOperationListChanged"

	doc [======[
		@name OnDeleteFinished
		@type script
		@desc Run when the delete key is up
	]======]
	script "OnDeleteFinished"

	doc [======[
		@name OnBackspaceFinished
		@type script
		@desc Run when the backspace key is up
	]======]
	script "OnBackspaceFinished"

	doc [======[
		@name OnPasting
		@type script
		@desc Run when pasting finished
		@param startp number, the start position
		@param endp number, the end position
	]======]
	script "OnPasting"

	doc [======[
		@name OnCut
		@type script
		@desc Run when cut finished
		@param startp number, the start position
		@param endp number, the end position
		@param cutText string, the cut text
	]======]
	script "OnCut"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name GetFont
		@type method
		@desc Returns the font instance's basic font properties
		@return filename string, path to a font file (string)
		@return fontHeight number, height (point size) of the font to be displayed (in pixels) (number)
		@return flags string, additional properties for the font specified by one or more (separated by commas)
	]======]
	function GetFont(self, ...)
		return self.__Text:GetFont(...)
	end

	doc [======[
		@name GetFontObject
		@type method
		@desc Returns the Font object from which the font instance's properties are inherited
		@return System.Widget.Font the Font object from which the font instance's properties are inherited, or nil if the font instance has no inherited properties
	]======]
	function GetFontObject(self, ...)
		return self.__Text:GetFontObject(...)
	end

	doc [======[
		@name GetShadowColor
		@type method
		@desc Returns the color of the font's text shadow
		@return shadowR number, Red component of the shadow color (0.0 - 1.0)
		@return shadowG number, Green component of the shadow color (0.0 - 1.0)
		@return shadowB number, Blue component of the shadow color (0.0 - 1.0)
		@return shadowAlpha number, Alpha (opacity) of the text's shadow (0.0 = fully transparent, 1.0 = fully opaque)
	]======]
	function GetShadowColor(self, ...)
		return self.__Text:GetShadowColor(...)
	end

	doc [======[
		@name GetShadowOffset
		@type method
		@desc Returns the offset of the font instance's text shadow from its text
		@return xOffset number, Horizontal distance between the text and its shadow (in pixels)
		@return yOffset number, Vertical distance between the text and its shadow (in pixels)
	]======]
	function GetShadowOffset(self, ...)
		return self.__Text:GetShadowOffset(...)
	end

	doc [======[
		@name GetSpacing
		@type method
		@desc Returns the font instance's amount of spacing between lines
		@return number amount of space between lines of text (in pixels)
	]======]
	function GetSpacing(self, ...)
		return self.__Text:GetSpacing(...)
	end

	doc [======[
		@name GetTextColor
		@type method
		@desc Returns the font instance's default text color
		@return textR number, Red component of the text color (0.0 - 1.0)
		@return textG number, Green component of the text color (0.0 - 1.0)
		@return textB number, Blue component of the text color (0.0 - 1.0)
		@return textAlpha number, Alpha (opacity) of the text (0.0 = fully transparent, 1.0 = fully opaque)
	]======]
	function GetTextColor(self, ...)
		return self.__Text:GetTextColor(...)
	end

	doc [======[
		@name SetFont
		@type method
		@desc Sets the font instance's basic font properties
		@param filename string, path to a font file
		@param fontHeight number, height (point size) of the font to be displayed (in pixels)
		@param flags string, additional properties for the font specified by one or more (separated by commas) of the following tokens: MONOCHROME, OUTLINE, THICKOUTLINE
		@return boolean 1 if filename refers to a valid font file; otherwise nil
	]======]
	function SetFont(self, ...)
		self.__Text:SetFont(...)
		Ajust4Font(self)
	end

	doc [======[
		@name SetFontObject
		@type method
		@desc Sets the Font object from which the font instance's properties are inherited
		@format fontObject|fontName
		@param fontObject System.Widget.Font, a font object
		@param fontName string, global font object's name
		@return nil
	]======]
	function SetFontObject(self, ...)
		self.__Text:SetFontObject(...)
		Ajust4Font(self)
	end

	doc [======[
		@name SetShadowColor
		@type method
		@desc Sets the color of the font's text shadow
		@param shadowR number, Red component of the shadow color (0.0 - 1.0)
		@param shadowG number, Green component of the shadow color (0.0 - 1.0)
		@param shadowB number, Blue component of the shadow color (0.0 - 1.0)
		@param shadowAlpha number, Alpha (opacity) of the text's shadow (0.0 = fully transparent, 1.0 = fully opaque)
		@return nil
	]======]
	function SetShadowColor(self, ...)
		return self.__Text:SetShadowColor(...)
	end

	doc [======[
		@name SetShadowOffset
		@type method
		@desc Sets the offset of the font instance's text shadow from its text
		@param xOffset number, Horizontal distance between the text and its shadow (in pixels)
		@param yOffset number, Vertical distance between the text and its shadow (in pixels)
		@return nil
	]======]
	function SetShadowOffset(self, ...)
		return self.__Text:SetShadowOffset(...)
	end

	doc [======[
		@name SetSpacing
		@type method
		@desc Sets the font instance's amount of spacing between lines
		@param spacing number, amount of space between lines of text (in pixels)
		@return nil
	]======]
	function SetSpacing(self, ...)
		self.__Text:SetSpacing(...)
		Ajust4Font(self)
	end

	doc [======[
		@name SetTextColor
		@type method
		@desc Sets the font instance's default text color. This color is used for otherwise unformatted text displayed using the font instance
		@param textR number, Red component of the text color (0.0 - 1.0)
		@param textG number, Green component of the text color (0.0 - 1.0)
		@param textB number, Blue component of the text color (0.0 - 1.0)
		@param textAlpha number, Alpha (opacity) of the text (0.0 = fully transparent, 1.0 = fully opaque)
		@return nil
	]======]
	function SetTextColor(self, ...)
		return self.__Text:SetTextColor(...)
	end

	doc [======[
		@name CopyFontObject
		@type method
		@desc Sets the font's properties to match those of another Font object. Unlike Font:SetFontObject(), this method allows one-time reuse of another font object's properties without continuing to inherit future changes made to the other object's properties.
		@format object|name
		@param object System.Widget.Font, reference to a Font object
		@param name string, global name of a Font object
		@return nil
	]======]
	function CopyFontObject(self, ...)
		self.__Text:CopyFontObject(...)
		Ajust4Font(self)
	end

	doc [======[
		@name GetIndentedWordWrap
		@type method
		@desc Gets whether long lines of text are indented when wrapping
		@return boolean
	]======]
	function GetIndentedWordWrap(self, ...)
		return self.__Text:GetIndentedWordWrap(...)
	end

	doc [======[
		@name SetIndentedWordWrap
		@type method
		@desc Sets whether long lines of text are indented when wrapping
		@param boolean
		@return nil
	]======]
	function SetIndentedWordWrap(self, ...)
		self.__Text:SetIndentedWordWrap(...)
		Ajust4Font(self)
	end

	doc [======[
		@name ClearHistory
		@type method
		@desc Clear history
		@return nil
	]======]
	function ClearHistory(self, ...)
		return self.__Text:ClearHistory(...)
	end

	doc [======[
		@name GetUTF8CursorPosition
		@type method
		@desc Returns the cursor's numeric position in the edit box, taking UTF-8 multi-byte character into account. If the EditBox contains multi-byte Unicode characters, the GetCursorPosition() method will not return correct results, as it considers each eight byte character to count as a single glyph.  This method properly returns the position in the edit box from the perspective of the user.
		@return number The cursor's numeric position (leftmost position is 0), taking UTF8 multi-byte characters into account.
	]======]
	function GetUTF8CursorPosition(self, ...)
		return self.__Text:GetUTF8CursorPosition(...)
	end

	doc [======[
		@name IsCountInvisibleLetters
		@type method
		@desc
		@return boolean
	]======]
	function IsCountInvisibleLetters(self, ...)
		return self.__Text:IsCountInvisibleLetters(...)
	end

	doc [======[
		@name IsInIMECompositionMode
		@type method
		@desc Returns whether the edit box is in Input Method Editor composition mode. Character composition mode is used for input methods in which multiple keypresses generate one printed character. In such input methods, the edit box's OnChar script is run for each keypress
		@return boolean 1 if the edit box is in IME character composition mode; otherwise nil
	]======]
	function IsInIMECompositionMode(self, ...)
		return self.__Text:IsInIMECompositionMode(...)
	end

	doc [======[
		@name SetCountInvisibleLetters
		@type method
		@desc
		@param ...
		@return nil
	]======]
	function SetCountInvisibleLetters(self, ...)
		return self.__Text:SetCountInvisibleLetters(...)
	end

	doc [======[
		@name AddHistoryLine
		@type method
		@desc Add text to the edit history
		@param text string, text to be added to the edit box's list of history lines
		@return nil
	]======]
	function AddHistoryLine(self, ...)
		return self.__Text:AddHistoryLine(...)
	end

	doc [======[
		@name ClearFocus
		@type method
		@desc Releases keyboard input focus from the edit box
		@return nil
	]======]
	function ClearFocus(self, ...)
		return self.__Text:ClearFocus(...)
	end

	doc [======[
		@name GetAltArrowKeyMode
		@type method
		@desc Returns whether arrow keys are ignored by the edit box unless the Alt key is held
		@return boolean 1 if arrow keys are ignored by the edit box unless the Alt key is held; otherwise nil
	]======]
	function GetAltArrowKeyMode(self, ...)
		return self.__Text:GetAltArrowKeyMode(...)
	end

	doc [======[
		@name GetBlinkSpeed
		@type method
		@desc Returns the rate at which the text insertion blinks when the edit box is focused
		@return number Amount of time for which the cursor is visible during each "blink" (in seconds)
	]======]
	function GetBlinkSpeed(self, ...)
		return self.__Text:GetBlinkSpeed(...)
	end

	doc [======[
		@name GetCursorPosition
		@type method
		@desc Returns the current cursor position inside edit box
		@return number Current position of the keyboard input cursor (between 0, for the position before the first character, and editbox:GetNumLetters(), for the position after the last character)
	]======]
	function GetCursorPosition(self, ...)
		return self.__Text:GetCursorPosition(...)
	end

	doc [======[
		@name GetHistoryLines
		@type method
		@desc Returns the maximum number of history lines stored by the edit box
		@return number Maximum number of history lines stored by the edit box
	]======]
	function GetHistoryLines(self, ...)
		return self.__Text:GetHistoryLines(...)
	end

	doc [======[
		@name GetInputLanguage
		@type method
		@desc Returns the currently selected keyboard input language (character set / input method). Applies to keyboard input methods, not in-game languages or client locales.
		@return string the input language
	]======]
	function GetInputLanguage(self, ...)
		return self.__Text:GetInputLanguage(...)
	end

	doc [======[
		@name GetMaxBytes
		@type method
		@desc Returns the maximum number of bytes of text allowed in the edit box. Note: Unicode characters may consist of more than one byte each, so the behavior of a byte limit may differ from that of a character limit in practical use.
		@return number Maximum number of text bytes allowed in the edit box
	]======]
	function GetMaxBytes(self, ...)
		return self.__Text:GetMaxBytes(...)
	end

	doc [======[
		@name GetMaxLetters
		@type method
		@desc Returns the maximum number of text characters allowed in the edit box
		@return number Maximum number of text characters allowed in the edit box
	]======]
	function GetMaxLetters(self, ...)
		return self.__Text:GetMaxLetters(...)
	end

	doc [======[
		@name GetNumLetters
		@type method
		@desc Returns the number of text characters in the edit box
		@return number Number of text characters in the edit box
	]======]
	function GetNumLetters(self, ...)
		return self.__Text:GetNumLetters(...)
	end

	doc [======[
		@name GetNumber
		@type method
		@desc Returns the contents of the edit box as a number. Similar to tonumber(editbox:GetText()); returns 0 if the contents of the edit box cannot be converted to a number.
		@return number Contents of the edit box as a number
	]======]
	function GetNumber(self, ...)
		return self.__Text:GetNumber(...)
	end

	doc [======[
		@name GetText
		@type method
		@desc Returns the edit box's text contents
		@return string Text contained in the edit box
	]======]
	function GetText(self, ...)
		return self.__Text:GetText(...)
	end

	doc [======[
		@name GetTextInsets
		@type method
		@desc Returns the insets from the edit box's edges which determine its interactive text area
		@return left number, distance from the left edge of the edit box to the left edge of its interactive text area (in pixels)
		@return right number, distance from the right edge of the edit box to the right edge of its interactive text area (in pixels)
		@return top number, distance from the top edge of the edit box to the top edge of its interactive text area (in pixels)
		@return bottom number, distance from the bottom edge of the edit box to the bottom edge of its interactive text area (in pixels)
	]======]
	function GetTextInsets(self, ...)
		return self.__Text:GetTextInsets(...)
	end

	doc [======[
		@name HighlightText
		@type method
		@desc Selects all or a portion of the text in the edit box
		@param start number, character position at which to begin the selection (between 0, for the position before the first character, and editbox:GetNumLetters(), for the position after the last character); defaults to 0 if not specified
		@param end number, character position at which to end the selection; if not specified or if less than start, selects all characters after the start position; if equal to start, selects nothing and positions the cursor at the start position
		@return nil
	]======]
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

	doc [======[
		@name Insert
		@type method
		@desc Inserts text into the edit box at the current cursor position
		@param text string, text to be inserted
		@return nil
	]======]
	function Insert(self, ...)
		return self.__Text:Insert(...)
	end

	doc [======[
		@name IsAutoFocus
		@type method
		@desc Returns whether the edit box automatically acquires keyboard input focus
		@return boolean 1 if the edit box automatically acquires keyboard input focus; otherwise nil
	]======]
	function IsAutoFocus(self, ...)
		return self.__Text:IsAutoFocus(...)
	end

	doc [======[
		@name IsMultiLine
		@type method
		@desc Returns whether the edit box shows more than one line of text
		@return boolean 1 if the edit box shows more than one line of text; otherwise nil
	]======]
	function IsMultiLine(self, ...)
		return self.__Text:IsMultiLine(...)
	end

	doc [======[
		@name IsNumeric
		@type method
		@desc Returns whether the edit box only accepts numeric input
		@return boolean 1 if only numeric input is allowed; otherwise nil
	]======]
	function IsNumeric(self, ...)
		return self.__Text:IsNumeric(...)
	end

	doc [======[
		@name IsPassword
		@type method
		@desc Returns whether the text entered in the edit box is masked
		@return boolean 1 if text entered in the edit box is masked with asterisk characters (*); otherwise nil
	]======]
	function IsPassword(self, ...)
		return self.__Text:IsPassword(...)
	end

	doc [======[
		@name SetAltArrowKeyMode
		@type method
		@desc Sets whether arrow keys are ignored by the edit box unless the Alt key is held
		@param enable boolean, true to cause the edit box to ignore arrow key presses unless the Alt key is held; false to allow unmodified arrow key presses for cursor movement
		@return nil
	]======]
	function SetAltArrowKeyMode(self, ...)
		return self.__Text:SetAltArrowKeyMode(...)
	end

	doc [======[
		@name SetAutoFocus
		@type method
		@desc Sets whether the edit box automatically acquires keyboard input focus. If auto-focus behavior is enabled, the edit box automatically acquires keyboard focus when it is shown and when no other edit box is focused.
		@param enable boolean, true to enable the edit box to automatically acquire keyboard input focus; false to disable
		@return nil
	]======]
	function SetAutoFocus(self, ...)
		return self.__Text:SetAutoFocus(...)
	end

	doc [======[
		@name SetBlinkSpeed
		@type method
		@desc Sets the rate at which the text insertion blinks when the edit box is focused. The speed indicates how long the cursor stays in each state (shown and hidden); e.g. if the blink speed is 0.5 (the default, the cursor is shown for one half second and then hidden for one half second (thus, a one-second cycle); if the speed is 1.0, the cursor is shown for one second and then hidden for one second (a two-second cycle).
		@param duration number, Amount of time for which the cursor is visible during each "blink" (in seconds)
		@return nil
	]======]
	function SetBlinkSpeed(self, ...)
		return self.__Text:SetBlinkSpeed(...)
	end

	doc [======[
		@name SetCursorPosition
		@type method
		@desc Sets the cursor position in the edit box
		@param position number, new position for the keyboard input cursor (between 0, for the position before the first character, and editbox:GetNumLetters(), for the position after the last character)
		@return nil
	]======]
	function SetCursorPosition(self, position)
		if self.__OperationOnLine then
			SaveOperation(self)
		end

		return self.__Text:SetCursorPosition(position)
	end

	doc [======[
		@name SetFocus
		@type method
		@desc Focuses the edit box for keyboard input. Only one edit box may be focused at a time; setting focus to one edit box will remove it from the currently focused edit box.
		@return nil
	]======]
	function SetFocus(self, ...)
		return self.__Text:SetFocus(...)
	end

	doc [======[
		@name SetHistoryLines
		@type method
		@desc Sets the maximum number of history lines stored by the edit box. Lines of text can be added to the edit box's history by calling :AddHistoryLine(); once added, the user can quickly set the edit box's contents to one of these lines by pressing the up or down arrow keys. (History lines are only accessible via the arrow keys if the edit box is not in multi-line mode.)
		@param count number, Maximum number of history lines to be stored by the edit box
		@return nil
	]======]
	function SetHistoryLines(self, ...)
		return self.__Text:SetHistoryLines(...)
	end

	doc [======[
		@name SetMaxBytes
		@type method
		@desc Sets the maximum number of bytes of text allowed in the edit box
		@param maxBytes number, Maximum number of text bytes allowed in the edit box, or 0 for no limit
		@return nil
	]======]
	function SetMaxBytes(self, ...)
		return self.__Text:SetMaxBytes(...)
	end

	doc [======[
		@name SetMaxLetters
		@type method
		@desc Sets the maximum number of text characters allowed in the edit box.
		@param maxLetters number, Maximum number of text characters allowed in the edit box, or 0 for no limit
		@return nil
	]======]
	function SetMaxLetters(self, ...)
		return self.__Text:SetMaxLetters(...)
	end

	doc [======[
		@name SetMultiLine
		@type method
		@desc Sets whether the edit box shows more than one line of text. When in multi-line mode, the edit box's height is determined by the number of lines shown and cannot be set directly -- enclosing the edit box in a ScrollFrame may prove useful in such cases.
		@param multiLine boolean, true to allow the edit box to display more than one line of text; false for single-line display
		@return nil
	]======]
	function SetMultiLine(self, ...)
		error("This editbox must be multi-line", 2)
	end

	doc [======[
		@name SetNumber
		@type method
		@desc Sets the contents of the edit box to a number
		@param num number, new numeric content for the edit box
		@return nil
	]======]
	function SetNumber(self, ...)
		return self.__Text:SetNumber(...)
	end

	doc [======[
		@name SetNumeric
		@type method
		@desc Sets whether the edit box only accepts numeric input. Note: an edit box in numeric mode <em>only</em> accepts numeral input -- all other characters, including those commonly used in numeric representations (such as ., E, and -) are not allowed.
		@param enable boolean, true to allow only numeric input; false to allow any text
		@return nil
	]======]
	function SetNumeric(self, ...)
		return self.__Text:SetNumeric(...)
	end

	doc [======[
		@name SetPassword
		@type method
		@desc Sets whether the text entered in the edit box is masked
		@param enable boolean, true to mask text entered in the edit box with asterisk characters (*); false to show the actual text entered
		@return nil
	]======]
	function SetPassword(self, ...)
		return self.__Text:SetPassword(...)
	end

	doc [======[
		@name SetText
		@type method
		@desc Sets the edit box's text contents
		@param text string, text to be placed in the edit box
		@return nil
	]======]
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

	doc [======[
		@name AdjustText
		@type method
		@desc Sets the edit box's text contents without clear the operation list
		@param text string, text to be placed in the edit box
		@return nil
	]======]
	function AdjustText(self, text)
		self.__Text.Text = text
	end

	doc [======[
		@name SetTextInsets
		@type method
		@desc Sets the insets from the edit box's edges which determine its interactive text area
		@param left number, distance from the left edge of the edit box to the left edge of its interactive text area (in pixels)
		@param right number, distance from the right edge of the edit box to the right edge of its interactive text area (in pixels)
		@param top number, distance from the top edge of the edit box to the top edge of its interactive text area (in pixels)
		@param bottom number, distance from the bottom edge of the edit box to the bottom edge of its interactive text area (in pixels)
		@return nil
	]======]
	function SetTextInsets(self, ...)
		self.__Text:SetTextInsets(...)
		Ajust4Font(self)
	end

	doc [======[
		@name ToggleInputLanguage
		@type method
		@desc Switches the edit box's language input mode. If the edit box is in ROMAN mode and an alternate Input Method Editor composition mode is available (as determined by the client locale and system settings), switches to the alternate input mode. If the edit box is in IME composition mode, switches back to ROMAN.
		@return nil
	]======]
	function ToggleInputLanguage(self, ...)
		return self.__Text:ToggleInputLanguage(...)
	end

	doc [======[
		@name HasFocus
		@type method
		@desc Returns whether the edit box is currently focused for keyboard input
		@return boolean 1 if the edit box is currently focused for keyboard input; otherwise nil
	]======]
	function HasFocus(self, ...)
		return self.__Text:HasFocus(...)
	end

	doc [======[
		@name CanUndo
		@type method
		@desc Whether the MultiLineTextBox has operation can be undo
		@return boolean true if the MultiLineTextBox can undo operations
	]======]
	function CanUndo(self)
		return self.__OperationIndex > 0
	end

	doc [======[
		@name Undo
		@type method
		@desc Undo the operation
		@return nil
	]======]
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

	doc [======[
		@name CanRedo
		@type method
		@desc Whether the MultiLineTextBox has operation can be redo
		@return boolean true if the MultiLineTextBox can redo operations
	]======]
	function CanRedo(self)
		return self.__OperationIndex < self.__MaxOperationIndex
	end

	doc [======[
		@name Redo
		@type method
		@desc Redo the operation
		@return nil
	]======]
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

	doc [======[
		@name ResetModifiedState
		@type method
		@desc Reset the MultiLineTextBox's modified state
		@return nil
	]======]
	function ResetModifiedState(self)
		self.__DefaultText = self.__Text.Text
	end

	doc [======[
		@name IsModified
		@type method
		@desc Whether the MultiLineTextBox is modified
		@return boolean true if the MultiLineTextBox is modified
	]======]
	function IsModified(self)
		return self.__DefaultText ~= self.__Text.Text
	end

	doc [======[
		@name RegisterControlKey
		@type method
		@desc Register a short-key combied with ctrl
		@param key string, the short key
		@return nil
	]======]
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

	doc [======[
		@name UnRegisterControlKey
		@type method
		@desc UnRegister a short-key combied with ctrl
		@param key string, the short key
		@return nil
	]======]
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

	doc [======[
		@name SetTabWidth
		@type method
		@desc Set the tabwidth for the MultiLineTextBox
		@param tabWidth number, the tab's width
		@return nil
	]======]
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

	doc [======[
		@name GetTabWidth
		@type method
		@desc Get the tabwidth for the MultiLineTextBox
		@return number the tab's width
	]======]
	function GetTabWidth(self)
		return self.__TabWidth or _TabWidth
	end

	doc [======[
		@name ClearAutoCompleteList
		@type method
		@desc Clear the auto complete list
		@return nil
	]======]
	function ClearAutoCompleteList(self)
		wipe(self.AutoCompleteList)
	end

	doc [======[
		@name InsertAutoCompleteWord(self, word)
		@type method
		@desc Insert word to the auto complete list
		@param word string, the world that need for auto complete
		@return nil
	]======]
	function InsertAutoCompleteWord(self, word)
		if type(word) == "string" and strtrim(word) ~= "" then
			word = strtrim(word)
			word = RemoveColor(word)

			local lst = self.AutoCompleteList
			local idx = GetIndex(lst, word)

			if lst[idx] == word then
				return
			end

			tinsert(lst, idx + 1, word)
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name Font
		@type property
		@desc the font's defined table, contains font path, height and flags' settings
	]======]
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

	doc [======[
		@name FontObject
		@type property
		@desc the Font object
	]======]
	property "FontObject" {
		Get = function(self)
			return self:GetFontObject()
		end,
		Set = function(self, fontObject)
			self:SetFontObject(fontObject)
		end,
		Type = Font + String + nil,
	}

	doc [======[
		@name ShadowColor
		@type property
		@desc the color of the font's text shadow
	]======]
	property "ShadowColor" {
		Get = function(self)
			return ColorType(self:GetShadowColor())
		end,
		Set = function(self, color)
			self:SetShadowColor(color.r, color,g, color.b, color.a)
		end,
		Type = ColorType,
	}

	doc [======[
		@name ShadowOffset
		@type property
		@desc the offset of the fontstring's text shadow from its text
	]======]
	property "ShadowOffset" {
		Get = function(self)
			return Dimension(self:GetShadowOffset())
		end,
		Set = function(self, offset)
			self:SetShadowOffset(offset.x, offset.y)
		end,
		Type = Dimension,
	}

	doc [======[
		@name Spacing
		@type property
		@desc the fontstring's amount of spacing between lines
	]======]
	property "Spacing" {
		Get = function(self)
			return self:GetSpacing()
		end,
		Set = function(self, spacing)
			self:SetSpacing(spacing)
		end,
		Type = Number,
	}

	doc [======[
		@name TextColor
		@type property
		@desc the fontstring's default text color
	]======]
	property "TextColor" {
		Get = function(self)
			return ColorType(self:GetTextColor())
		end,
		Set = function(self, color)
			self:SetTextColor(color.r, color,g, color.b, color.a)
		end,
		Type = ColorType,
	}

	doc [======[
		@name NumericOnly
		@type property
		@desc true if the edit box only accepts numeric input
	]======]
	property "NumericOnly" {
		Set = function(self, state)
			self:SetNumeric(state)
		end,

		Get = function(self)
			return (self:IsNumeric() and true) or false
		end,

		Type = Boolean,
	}

	doc [======[
		@name Password
		@type property
		@desc true if the text entered in the edit box is masked
	]======]
	property "Password" {
		Set = function(self, state)
			self:SetPassword(state)
		end,

		Get = function(self)
			return (self:IsPassword() and true) or false
		end,

		Type = Boolean,
	}

	doc [======[
		@name AutoFocus
		@type property
		@desc true if the edit box automatically acquires keyboard input focus
	]======]
	property "AutoFocus" {
		Set = function(self, state)
			self:SetAutoFocus(state)
		end,

		Get = function(self)
			return (self:IsAutoFocus() and true) or false
		end,

		Type = Boolean,
	}

	doc [======[
		@name HistoryLines
		@type property
		@desc the maximum number of history lines stored by the edit box
	]======]
	property "HistoryLines" {
		Set = function(self, num)
			self:SetHistoryLines(num)
		end,

		Get = function(self)
			return self:GetHistoryLines()
		end,

		Type = Number,
	}

	doc [======[
		@name Focused
		@type property
		@desc true if the edit box is currently focused
	]======]
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

	doc [======[
		@name AltArrowKeyMode
		@type property
		@desc true if the arrow keys are ignored by the edit box unless the Alt key is held
	]======]
	property "AltArrowKeyMode" {
		Set = function(self, enable)
			self:SetAltArrowKeyMode(enable)
		end,

		Get = function(self)
			return (self:GetAltArrowKeyMode() and true) or false
		end,

		Type = Boolean,
	}

	doc [======[
		@name BlinkSpeed
		@type property
		@desc the rate at which the text insertion blinks when the edit box is focused
	]======]
	property "BlinkSpeed" {
		Set = function(self, speed)
			self:SetBlinkSpeed(speed)
		end,

		Get = function(self)
			return self:GetBlinkSpeed()
		end,

		Type = Number,
	}

	doc [======[
		@name CursorPosition
		@type property
		@desc the current cursor position inside edit box
	]======]
	property "CursorPosition" {
		Set = function(self, position)
			self:SetCursorPosition(position)
		end,

		Get = function(self)
			return self:GetCursorPosition()
		end,

		Type = Number,
	}

	doc [======[
		@name MaxBytes
		@type property
		@desc the maximum number of bytes of text allowed in the edit box, default is 0(Infinite)
	]======]
	property "MaxBytes" {
		Set = function(self, maxBytes)
			self:SetMaxBytes(maxBytes)
		end,

		Get = function(self)
			return self:GetMaxBytes()
		end,

		Type = Number,
	}

	doc [======[
		@name MaxLetters
		@type property
		@desc the maximum number of text characters allowed in the edit box
	]======]
	property "MaxLetters" {
		Set = function(self, maxLetters)
			self:SetMaxLetters(maxLetters)
		end,

		Get = function(self)
			return self:GetMaxLetters()
		end,

		Type = Number,
	}

	doc [======[
		@name Number
		@type property
		@desc the contents of the edit box as a number
	]======]
	property "Number" {
		Set = function(self, number)
			self:SetNumber(number)
		end,

		Get = function(self)
			return self:GetNumber()
		end,

		Type = Number,
	}

	doc [======[
		@name Text
		@type property
		@desc the edit box's text contents
	]======]
	property "Text" {
		Set = function(self, text)
			self:SetText(text)
		end,

		Get = function(self)
			return self:GetText()
		end,

		Type = String,
	}

	doc [======[
		@name TextInsets
		@type property
		@desc the insets from the edit box's edges which determine its interactive text area
	]======]
	property "TextInsets" {
		Set = function(self, RectInset)
			self:SetTextInsets(RectInset.left, RectInset.right, RectInset.top, RectInset.bottom)
		end,

		Get = function(self)
			return Inset(self:GetTextInsets())
		end,

		Type = Inset,
	}

	doc [======[
		@name Editable
		@type property
		@desc true if the edit box is editable
	]======]
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

	doc [======[
		@name ShowLineNumber
		@type property
		@desc Whether show line number or not
	]======]
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

	doc [======[
		@name TabWidth
		@type property
		@desc The tab's width
	]======]
	property "TabWidth" {
		Get = function(self)
			return self:GetTabWidth()
		end,
		Set = function(self, tabWidth)
			self:SetTabWidth(tabWidth)
		end,
		Type = Number + nil,
	}

	doc [======[
		@name AutoCompleteList
		@type property
		@desc The auto complete list like {"if", "then", "else"}
	]======]
	property "AutoCompleteList" {
		Get = function(self)
			self.__AutoCompleteList = self.__AutoCompleteList or {}
			return self.__AutoCompleteList
		end,
		Set = function(self, value)
			self.__AutoCompleteList = type(value) == "table" and value or {}
		end,
		Type = System.Table,
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

			if y < self.Value then
				self.Value = (y > 0) and (y) or 0
			elseif y + 2*h > self.Value + self.Height then
				self.Value = y + 2*h - self.Height
			end
		end

		-- Cusotm part
		if self.__InCharComposition then return end

		local cursorPos = self.CursorPosition

		if self.__OperationOnLine == _Operation.INPUTCHAR then
			ApplyAutoComplete(self)
		elseif self.__OperationOnLine ~= _Operation.BACKSPACE then
			_List:Clear()
		end

		if _List.ItemCount > 0 then
			-- Handle the auto complete
			_List:SetPoint("TOPLEFT", self, x + (self.__Margin.Visible and self.__Margin.Width or 0), - y - h + self.Value)
			_List.Visible = true
			_List.SelectedIndex = 1
		else
			_List.Visible = false
		end

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
		return self.ScrollChild:UpdateSize()
	end

    local function OnEditFocusGained(self, ...)
		self = self.__Container

		if _KeyScan.FocusEditor then
			EndPrevKey(_KeyScan.FocusEditor)
		end

		_KeyScan.FocusEditor = self
		_KeyScan.Visible = true

		IFNoCombatTaskHandler._RegisterNoCombatTask(BlockShortKey)

		return self:Fire("OnEditFocusGained", ...)
	end

    local function OnEditFocusLost(self, ...)
		self = self.__Container

		if _KeyScan.FocusEditor == self then
			EndPrevKey(self)
			_KeyScan.FocusEditor = nil
			_KeyScan.Visible = false
			_List.Visible = false
			_List:Clear()

			IFNoCombatTaskHandler._RegisterNoCombatTask(UnblockShortKey)
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

		if _List.Visible then
			wipe(_BackAutoCache)

			startp, endp, str = GetWord(text, self.CursorPosition)

			str = _List:GetSelectedItemValue()

			if str then
				for _, v in ipairs(_List.Keys) do
					tinsert(_BackAutoCache, v)
				end

				_BackAutoCache[0] = _List.SelectedIndex

				self.__Text.Text = ReplaceBlock(text, startp, endp, str)

				AdjustCursorPosition(self, startp + str:len() - 1)

				return self:Fire("OnPasting", startp, startp + str:len() - 1)
			else
				_List.Visible = false
				_List:Clear()
			end
		elseif #_BackAutoCache > 0 then
			startp, endp, str = GetWord(text, self.CursorPosition)

			str = RemoveColor(str)

			if str == _BackAutoCache[_BackAutoCache[0]] then
				_BackAutoCache[0] = _BackAutoCache[0] + 1

				if _BackAutoCache[0] > #_BackAutoCache then
					_BackAutoCache[0] = 1
				end

				str = _BackAutoCache[_BackAutoCache[0]]

				if str then
					self.__Text.Text = ReplaceBlock(text, startp, endp, str)

					AdjustCursorPosition(self, startp + str:len() - 1)

					return self:Fire("OnPasting", startp, startp + str:len() - 1)
				else
					wipe(_BackAutoCache)
				end
			end
		end

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
			return true
		end

		-- Auto paris
		local char = ...

		if char and _AutoPairs[strbyte(char)] ~= nil then
			local text = self.__Text.Text
			local cursorPos = self.CursorPosition

			local startp, endp, str = GetLines(text, cursorPos)

			-- Check if in string
			local pos = 1
			local byte = strbyte(str, pos)
			local cPos = cursorPos - startp + 1
			local isString = 0
			local preEscape = false

			while byte do
				if pos == cPos then
					break
				end

				if not preEscape then
					if byte == _Byte.SINGLE_QUOTE then
						if isString == 0 then
							isString = 1
						elseif isString == 1 then
							isString = 0
						end
					elseif byte == _Byte.DOUBLE_QUOTE then
						if isString == 0 then
							isString = 2
						elseif isString == 2 then
							isString = 0
						end
					end
				end

				if byte == _Byte.BACKSLASH then
					preEscape = not preEscape
				else
					preEscape = false
				end

				pos = pos + 1
				byte = strbyte(str,  pos)
			end

			startp, endp, str = GetWord(text, cursorPos)

			if str and str ~= "" then
				local header = str:sub(1, cursorPos + 1 - startp)
				local tail = str:sub(cursorPos + 2  - startp, -1)

				header = RemoveColor(header) or ""
				tail = RemoveColor(tail) or ""

				if header and header ~= "" then
					local byte = strbyte(char)
					local tbyte = tail ~= "" and strbyte(tail, 1) or 0
 
					if _AutoPairs[byte] == false then
						-- end pairs like ] ) }
						if isString == 0 and tail and tail ~= "" and tail:sub(1, 1) == char then
							str = header:sub(1, -2) .. tail

							self.__Text.Text = ReplaceBlock(text, startp, endp, str)
							AdjustCursorPosition(self, startp + header:len() - 1)
						end
					elseif _AutoPairs[byte] == true then
						-- ' "
						if tail and tail ~= "" and tail:sub(1, 1) == char then
							str = header:sub(1, -2) .. tail

							self.__Text.Text = ReplaceBlock(text, startp, endp, str)
							AdjustCursorPosition(self, startp + header:len() - 1)
						elseif isString == 0 and tail == "" or tbyte == _Byte.SPACE or tbyte == _Byte.TAB or (_AutoPairs[tbyte] == false) then
							str = header .. char .. tail
 
							self.__Text.Text =  ReplaceBlock(text, startp, endp, str)
							AdjustCursorPosition(self, startp + header:len() - 1)
						end
					else
						if tail == "" or tbyte == _Byte.SPACE or tbyte == _Byte.TAB or (_AutoPairs[tbyte] == false) then
							str = header .. strchar(_AutoPairs[byte]) .. tail	

							self.__Text.Text = ReplaceBlock(text, startp, endp, str)
							AdjustCursorPosition(self, startp + header:len() - 1)
						end
					end
				end
			end
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
						if _List.Visible then
							self.FocusEditor.AltArrowKeyMode = true

							if _List.SelectedIndex > 1 then
								_List.SelectedIndex = _List.SelectedIndex - 1
							end

							return
						else
							self.FocusEditor.AltArrowKeyMode = false
						end

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
						if _List.Visible then
							self.FocusEditor.AltArrowKeyMode = true

							if _List.SelectedIndex < _List.ItemCount then
								_List.SelectedIndex = _List.SelectedIndex + 1
							end

							return
						else
							self.FocusEditor.AltArrowKeyMode = false
						end

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

	function _List:OnItemChoosed(key, text)
		local editor = _KeyScan.FocusEditor
		if not editor then
			_List.Visible = false
			_List:Clear()
			return
		end

		local ct = editor.__Text.Text
		local startp, endp = GetWord(ct, editor.CursorPosition)

		wipe(_BackAutoCache)

		if key then
			for _, v in ipairs(_List.Keys) do
				tinsert(_BackAutoCache, v)
			end

			_BackAutoCache[0] = _List.SelectedIndex

			_List.Visible = false
			_List:Clear()

			editor.__Text.Text = ReplaceBlock(ct, startp, endp, key)

			AdjustCursorPosition(editor, startp + key:len() - 1)

			return editor:Fire("OnPasting", startp, startp + key:len() - 1)
		else
			_List.Visible = false
			_List:Clear()
		end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function MultiLineTextBox(self, name, parent)
		local container = self.ScrollChild

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

		container:UpdateSize()
	end
endclass "MultiLineTextBox"
