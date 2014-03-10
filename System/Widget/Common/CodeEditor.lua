-- Author      : Kurapica
-- Create Date : 7/27/2011
--               2012.05.14 Fix cursor position after format color

-- Check Version
local version = 10

if not IGAS:NewAddon("IGAS.Widget.CodeEditor", version) then
	return
end

__Doc__[[CodeEditor object is used as a lua code editor]]
class "CodeEditor"
	inherit "MultiLineTextBox"

	_IndentNone = 0
	_IndentRight = 1
	_IndentLeft = 2
	_IndentBoth = 3

	_DefaultColor = System.Widget.ColorType(1, 1, 1, 1)
	_CommentColor = System.Widget.ColorType(0, 1, 0, 1)
	_StringColor = System.Widget.ColorType(0, 1, 0, 1)
	_NumberColor = System.Widget.ColorType(1, 1, 0, 1)
	_InstructionColor = System.Widget.ColorType(1, 0.39, 0.09, 1)
	_EndColor = "|r"

	-- Token
	_Token = {
		UNKNOWN = 0,
		LINEBREAK = 1,
		SPACE = 2,
		OPERATOR = 3,
		LEFTBRACKET = 4,
		RIGHTBRACKET = 5,
		LEFTPAREN = 6,
		RIGHTPAREN = 7,
		LEFTWING = 8,
		RIGHTWING = 9,
		COMMA = 10,
		SEMICOLON = 11,
		COLON = 12,
		HASH = 13,
		NUMBER = 14,
		COLORCODE_START = 15,
		COLORCODE_END = 16,
		COMMENT = 17,
		STRING = 18,
		ASSIGNMENT = 19,
		EQUALITY = 20,
		PERIOD = 21,
		DOUBLEPERIOD = 22,
		TRIPLEPERIOD = 23,
		LT = 24,
		LTE = 25,
		GT = 26,
		GTE = 27,
		NOTEQUAL = 28,
		TILDE = 29,
		IDENTIFIER = 30,
		VERTICAL = 31,
	}

	_WordWrap = {
		[0] = _IndentNone,	-- UNKNOWN
		_IndentNone,		-- LINEBREAK
		_IndentNone,		-- SPACE
		_IndentBoth,		-- OPERATOR
		_IndentNone,		-- LEFTBRACKET
		_IndentNone,		-- RIGHTBRACKET
		_IndentNone,		-- LEFTPAREN
		_IndentNone,		-- RIGHTPAREN
		_IndentNone,		-- LEFTWING
		_IndentNone,		-- RIGHTWING
		_IndentRight,		-- COMMA
		_IndentNone,		-- SEMICOLON
		_IndentNone,		-- COLON
		_IndentLeft,		-- HASH
		_IndentNone,		-- NUMBER
		_IndentNone,		-- COLORCODE_START
		_IndentNone,		-- COLORCODE_END
		_IndentNone,		-- COMMENT
		_IndentNone,		-- STRING
		_IndentBoth,		-- ASSIGNMENT
		_IndentBoth,		-- EQUALITY
		_IndentNone,		-- PERIOD
		_IndentBoth,		-- DOUBLEPERIOD
		_IndentNone,		-- TRIPLEPERIOD
		_IndentBoth,		-- LT
		_IndentBoth,		-- LTE
		_IndentBoth,		-- GT
		_IndentBoth,		-- GTE
		_IndentBoth,		-- NOTEQUAL
		_IndentNone,		-- TILDE
		_IndentNone,		-- IDENTIFIER
		_IndentNone,		-- VERTICAL
	}

	-- Words
	_KeyWord = {
		["and"] = _IndentNone,
		["break"] = _IndentNone,
		["do"] = _IndentRight,
		["else"] = _IndentBoth,
		["elseif"] = _IndentLeft,
		["end"] = _IndentLeft,
		["false"] = _IndentNone,
		["for"] = _IndentNone,
		["function"] = _IndentRight,
		["if"] = _IndentNone,
		["in"] = _IndentNone,
		["local"] = _IndentNone,
		["nil"] = _IndentNone,
		["not"] = _IndentNone,
		["or"] = _IndentNone,
		["repeat"] = _IndentRight,
		["return"] = _IndentNone,
		["then"] = _IndentRight,
		["true"] = _IndentNone,
		["until"] = _IndentLeft,
		["while"] = _IndentNone,
		-- Loop
		["class"] = _IndentRight,
		["inherit"] = _IndentNone,
		["import"] = _IndentNone,
		["endclass"] = _IndentLeft,
		["event"] = _IndentNone,
		["property"] = _IndentNone,
		["namespace"] = _IndentNone,
		["enum"] = _IndentNone,
		["struct"] = _IndentRight,
		["endstruct"] = _IndentLeft,
		["interface"] = _IndentRight,
		["endinterface"] = _IndentLeft,
		["extend"] = _IndentNone,
	}

	-- Bytes
	_Byte = {
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
	}

	-- Special
	_Special = {
		-- LineBreak
		[_Byte.LINEBREAK_N] = _Token.LINEBREAK,
		[_Byte.LINEBREAK_R] = _Token.LINEBREAK,

		-- Space
		[_Byte.SPACE] = _Token.SPACE,
		[_Byte.TAB] = _Token.SPACE,

		-- String
		[_Byte.SINGLE_QUOTE] = -1,
		[_Byte.DOUBLE_QUOTE] = -1,

		-- Operator
		[_Byte.MINUS] = -1,	-- need check
		[_Byte.PLUS] = _Token.OPERATOR,
		[_Byte.SLASH] = _Token.OPERATOR,
		[_Byte.ASTERISK] = _Token.OPERATOR,
		[_Byte.PERCENT] = _Token.OPERATOR,

		-- Compare
		[_Byte.LESSTHAN] = -1,
		[_Byte.GREATERTHAN] = -1,
		[_Byte.EQUALS] = -1,

		-- Parentheses
		[_Byte.LEFTBRACKET] = -1,
		[_Byte.RIGHTBRACKET] = _Token.RIGHTBRACKET,
		[_Byte.LEFTPAREN] = _Token.LEFTPAREN,
		[_Byte.RIGHTPAREN] = _Token.RIGHTPAREN,
		[_Byte.LEFTWING] = _Token.LEFTWING,
		[_Byte.RIGHTWING] = _Token.RIGHTWING,

		-- Punctuation
		[_Byte.PERIOD] = -1,
		[_Byte.COMMA] = _Token.COMMA,
		[_Byte.SEMICOLON] = _Token.SEMICOLON,
		[_Byte.COLON] = _Token.COLON,
		[_Byte.TILDE] = -1,
		[_Byte.HASH] = _Token.HASH,

		-- WOW
		[_Byte.VERTICAL] = -1,
	}

    -- Help functions
	local function ReplaceBlock(str, startp, endp, replace)
		return str:sub(1, startp - 1) .. replace .. str:sub(endp + 1, -1)
	end

	local superAdjustCursorPosition = MultiLineTextBox.AdjustCursorPosition
	local function AdjustCursorPosition(self, pos)
		superAdjustCursorPosition(self, pos)
	end

	local function InitDefinition(self)
		self.__IdentifierCache = self.__IdentifierCache or {}
		wipe(self.__IdentifierCache)

		self:ClearAutoCompleteList()

		for k in pairs(_KeyWord) do
			self.__IdentifierCache[k] = true
			self:InsertAutoCompleteWord(k)
		end
	end

	-- Token
	local function nextNumber(str, pos, noPeriod, cursorPos, trueWord, newPos)
		pos = pos or 1
		newPos = newPos or 0
		cursorPos = cursorPos or 0

		-- just match, don't care error
		local e = 0
		local startPos = pos

		local byte = strbyte(str, pos)

		-- Number
		while true do
			if byte == _Byte.VERTICAL then
				-- handle the color code
				pos = pos + 1
				byte = strbyte(str, pos)

				if byte == _Byte.c then
					trueWord = trueWord and trueWord .. str:sub(startPos, pos - 2)
					pos = pos + 9
				elseif byte == _Byte.r then
					trueWord = trueWord and trueWord .. str:sub(startPos, pos - 2)
					pos = pos + 1
				else
					pos = pos - 1
					break
				end

				startPos = pos
				byte = strbyte(str, pos)
			else
				if not byte then
					break
				elseif byte >= _Byte.ZERO and byte <= _Byte.NINE then
					if e == 1 then e = 2 end
				elseif byte == _Byte.E or byte == _Byte.e then
					if e == 0 then
						e = 1
					end
				elseif byte >= _Byte.a and byte <= _Byte.f then
					if e == 1 then e = 2 end
				elseif not noPeriod and e == 0 and byte == _Byte.PERIOD then
					-- '.' only work before 'e'
					noPeriod = true
				elseif e == 1 and (byte == _Byte.MINUS or byte == _Byte.PLUS) then
					e = 2
				else
					break
				end

				if pos <= cursorPos then
					newPos = newPos + 1
				end

				pos = pos + 1
				byte = strbyte(str, pos)
			end
		end

		trueWord = trueWord and trueWord .. str:sub(startPos, pos - 1)

		return pos, trueWord, newPos
	end

	local function nextComment(str, pos, cursorPos, trueWord, newPos)
		pos = pos or 1
		newPos = newPos or 0
		cursorPos = cursorPos or 0

		local markLen = 0
		local dblBrak = false
		local startPos = pos

		local byte = strbyte(str, pos)

		while byte == _Byte.VERTICAL do
			-- handle the color code
			pos = pos + 1
			byte = strbyte(str, pos)

			if byte == _Byte.c then
				trueWord = trueWord and trueWord .. str:sub(startPos, pos - 2)
				pos = pos + 9
			elseif byte == _Byte.r then
				trueWord = trueWord and trueWord .. str:sub(startPos, pos - 2)
				pos = pos + 1
			else
				pos = pos - 1
				break
			end

			startPos = pos
			byte = strbyte(str, pos)
		end

		if byte == _Byte.LEFTBRACKET then
			if pos <= cursorPos then
				newPos = newPos + 1
			end

			pos = pos + 1
			byte = strbyte(str, pos)

			while true do
				if byte == _Byte.VERTICAL then
					-- handle the color code
					pos = pos + 1
					byte = strbyte(str, pos)

					if byte == _Byte.c then
						trueWord = trueWord and trueWord .. str:sub(startPos, pos - 2)
						pos = pos + 9
					elseif byte == _Byte.r then
						trueWord = trueWord and trueWord .. str:sub(startPos, pos - 2)
						pos = pos + 1
					else
						pos = pos - 1
						break
					end

					startPos = pos
					byte = strbyte(str, pos)
				else
					if not byte then
						break
					elseif byte == _Byte.EQUALS then
						markLen = markLen + 1
					elseif byte == _Byte.LEFTBRACKET then
						dblBrak = true
					else
						break
					end

					if pos <= cursorPos then
						newPos = newPos + 1
					end

					pos = pos + 1
					byte = strbyte(str, pos)

					if dblBrak then
						break
					end
				end
			end
		end

		if dblBrak then
			--[==[...]==]
			while true do
				if byte == _Byte.VERTICAL then
					-- handle the color code
					pos = pos + 1
					byte = strbyte(str, pos)

					if byte == _Byte.c then
						trueWord = trueWord and trueWord .. str:sub(startPos, pos - 2)
						pos = pos + 9
					elseif byte == _Byte.r then
						trueWord = trueWord and trueWord .. str:sub(startPos, pos - 2)
						pos = pos + 1
					elseif byte == _Byte.VERTICAL then
						if pos <= cursorPos then
							newPos = newPos + 2
						end
						trueWord = trueWord and trueWord .. str:sub(startPos, pos)
						pos = pos + 1
					else
						pos = pos - 1
						break
					end

					startPos = pos
					byte = strbyte(str, pos)
				else
					if not byte then
						break
					elseif byte == _Byte.RIGHTBRACKET then
						local len = 0

						if pos <= cursorPos then
							newPos = newPos + 1
						end

						pos = pos + 1
						byte = strbyte(str, pos)

						while true do
							if byte == _Byte.VERTICAL then
								-- handle the color code
								pos = pos + 1
								byte = strbyte(str, pos)

								if byte == _Byte.c then
									trueWord = trueWord and trueWord .. str:sub(startPos, pos - 2)
									pos = pos + 9
								elseif byte == _Byte.r then
									trueWord = trueWord and trueWord .. str:sub(startPos, pos - 2)
									pos = pos + 1
								elseif byte == _Byte.VERTICAL then
									if pos <= cursorPos then
										newPos = newPos + 2
									end
									trueWord = trueWord and trueWord .. str:sub(startPos, pos)
									pos = pos + 1
								else
									pos = pos - 1
									break
								end

								startPos = pos
								byte = strbyte(str, pos)
							else
								if byte == _Byte.EQUALS then
									len = len + 1
								else
									break
								end

								if pos <= cursorPos then
									newPos = newPos + 1
								end

								pos = pos + 1
								byte = strbyte(str, pos)
							end
						end

						if not byte then
							break
						elseif len == markLen and byte == _Byte.RIGHTBRACKET then
							if pos <= cursorPos then
								newPos = newPos + 1
							end

							pos = pos + 1
							byte = strbyte(str, pos)

							break
						end
					end

					if pos <= cursorPos then
						newPos = newPos + 1
					end

					pos = pos + 1
					byte = strbyte(str, pos)
				end
			end
		else
			--...
			while true do
				if byte == _Byte.VERTICAL then
					-- handle the color code
					pos = pos + 1
					byte = strbyte(str, pos)

					if byte == _Byte.c then
						trueWord = trueWord and trueWord .. str:sub(startPos, pos - 2)
						pos = pos + 9
					elseif byte == _Byte.r then
						trueWord = trueWord and trueWord .. str:sub(startPos, pos - 2)
						pos = pos + 1
					elseif byte == _Byte.VERTICAL then
						if pos <= cursorPos then
							newPos = newPos + 2
						end
						trueWord = trueWord and trueWord .. str:sub(startPos, pos)
						pos = pos + 1
					else
						pos = pos - 1
						break
					end

					startPos = pos
					byte = strbyte(str, pos)
				else
					if not byte or byte == _Byte.LINEBREAK_N or byte == _Byte.LINEBREAK_R then
						break
					end

					if pos <= cursorPos then
						newPos = newPos + 1
					end

					pos = pos + 1
					byte = strbyte(str, pos)
				end
			end
		end

		trueWord = trueWord and trueWord .. str:sub(startPos, pos - 1)

		return pos, trueWord, newPos
	end

	local function nextString(str, pos, mark, cursorPos, trueWord, newPos)
		pos = pos or 1
		cursorPos = cursorPos or 0
		newPos = newPos or 0

		local byte
		local preEscape = false

		local startPos = pos

		if pos <= cursorPos then
			newPos = newPos + 1
		end

		pos = pos + 1
		byte = strbyte(str, pos)

		while true do
			if byte == _Byte.VERTICAL then
				-- handle the color code
				pos = pos + 1
				byte = strbyte(str, pos)

				if byte == _Byte.c then
					trueWord = trueWord and trueWord .. str:sub(startPos, pos - 2)
					pos = pos + 9
				elseif byte == _Byte.r then
					trueWord = trueWord and trueWord .. str:sub(startPos, pos - 2)
					pos = pos + 1
				elseif byte == _Byte.VERTICAL then
					if pos <= cursorPos then
						newPos = newPos + 2
					end
					trueWord = trueWord and trueWord .. str:sub(startPos, pos)
					pos = pos + 1
				else
					pos = pos - 1
					break
				end

				startPos = pos
				byte = strbyte(str, pos)
			else
				if not byte or byte == _Byte.LINEBREAK_N or byte == _Byte.LINEBREAK_R then
					break
				end

				if not preEscape and byte == mark then
					if pos <= cursorPos then
						newPos = newPos + 1
					end

					pos = pos + 1
					break
				end

				if byte == _Byte.BACKSLASH then
					preEscape = not preEscape
				else
					preEscape = false
				end

				if pos <= cursorPos then
					newPos = newPos + 1
				end

				pos = pos + 1
				byte = strbyte(str, pos)
			end
		end

		trueWord = trueWord and trueWord .. str:sub(startPos, pos - 1)

		return pos, trueWord, newPos
	end

	local function nextIdentifier(str, pos, cursorPos, trueWord, newPos)
		pos = pos or 1
		cursorPos = cursorPos or 0
		newPos = newPos or 0

		local byte
		local startPos = pos

		if pos <= cursorPos then
			newPos = newPos + 1
		end

		pos = pos + 1
		byte = strbyte(str, pos)

		while true do
			if byte == _Byte.VERTICAL then
				-- handle the color code
				pos = pos + 1
				byte = strbyte(str, pos)

				if byte == _Byte.c then
					trueWord = trueWord and trueWord .. str:sub(startPos, pos - 2)
					pos = pos + 9
				elseif byte == _Byte.r then
					trueWord = trueWord and trueWord .. str:sub(startPos, pos - 2)
					pos = pos + 1
				else
					pos = pos - 1
					break
				end

				startPos = pos
				byte = strbyte(str, pos)
			else
				if not byte then
					break
				elseif byte == _Byte.SPACE or byte == _Byte.TAB then
					break
				elseif _Special[byte] then
					break
				end

				if pos <= cursorPos then
					newPos = newPos + 1
				end

				pos = pos + 1
				byte = strbyte(str, pos)
			end
		end

		trueWord = trueWord and trueWord .. str:sub(startPos, pos - 1)

		return pos, trueWord, newPos
	end

	local function nextToken(str, pos, cursorPos, needTrueWord)
		pos = pos or 1
		cursorPos = cursorPos or 0

		local byte = strbyte(str, pos)
		local start

		if not byte then return nil, pos end

		start = pos

		-- Space
		if byte == _Byte.SPACE or byte == _Byte.TAB then
			while true do
				pos = pos + 1
				byte = strbyte(str, pos)

				if not byte or (byte ~= _Byte.SPACE and byte ~= _Byte.TAB) then
					return _Token.SPACE, pos, needTrueWord and str:sub(start, pos - 1)
				end
			end
		end

		-- Special character
		if _Special[byte] then
			if _Special[byte] >= 0 then
				return _Special[byte], pos + 1, needTrueWord and str:sub(start, pos)
			elseif _Special[byte] == -1 then
				if byte == _Byte.VERTICAL then
					-- '|'
					pos = pos + 1
					byte = strbyte(str, pos)

					if byte == _Byte.c then
						--[[for i = pos + 1, pos + 8 do
							byte = strbyte(str, i)

							if i <= pos + 2 then
								if byte ~= _Byte.f then
									return _Token.UNKNOWN, pos
								end
							else
								if not ( ( byte >= _Byte.ZERO and byte <= _Byte.NINE ) or ( byte >= _Byte.a and byte <= _Byte.f ) ) then
									return  _Token.UNKNOWN, pos
								end
							end
						end--]]

						-- mark as '|cff20ff20'
						return _Token.COLORCODE_START, pos + 9
					elseif byte == _Byte.r then
						-- mark '|r'
						return _Token.COLORCODE_END, pos + 1
					elseif byte == _Byte.VERTICAL then
						return _Token.VERTICAL, pos + 1
					else
						-- don't know
						return _Token.UNKNOWN, pos
					end
				elseif byte == _Byte.MINUS then
					-- '-'
					pos = pos + 1
					byte = strbyte(str, pos)

					while byte == _Byte.VERTICAL do
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
					end

					if byte == _Byte.MINUS then
						-- '--'
						return _Token.COMMENT, nextComment(str, pos + 1, cursorPos, needTrueWord and "--", 2)
					else
						-- '-'
						return _Token.OPERATOR, pos, "-", 1
					end
				elseif byte == _Byte.SINGLE_QUOTE or byte == _Byte.DOUBLE_QUOTE then
					-- ' || "
					return _Token.STRING, nextString(str, pos, byte, cursorPos, needTrueWord and "")
				elseif byte == _Byte.LEFTBRACKET then
					local chkPos = pos
					local dblBrak = false

					-- '['
					pos = pos + 1
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
							elseif byte == _Byte.EQUALS then
							elseif byte == _Byte.LEFTBRACKET then
								dblBrak = true
								break
							else
								break
							end

							pos = pos + 1
							byte = strbyte(str, pos)
						end
					end

					if dblBrak then
						return _Token.STRING, nextComment(str, chkPos, cursorPos, needTrueWord and "")
					else
						return _Token.LEFTBRACKET, chkPos + 1, "[", 1
					end
				elseif byte == _Byte.EQUALS then
					-- '='
					pos = pos + 1
					byte = strbyte(str, pos)

					while byte == _Byte.VERTICAL do
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
					end

					if byte == _Byte.EQUALS then
						return _Token.EQUALITY, pos + 1, "==", 2
					else
						return _Token.ASSIGNMENT, pos, "=", 1
					end
				elseif byte == _Byte.PERIOD then
					-- '.'
					pos = pos + 1
					byte = strbyte(str, pos)

					while byte == _Byte.VERTICAL do
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
					end

					if not byte then
						return _Token.PERIOD, pos, ".", 1
					elseif byte == _Byte.PERIOD then
						pos = pos + 1
						byte = strbyte(str, pos)

						while byte == _Byte.VERTICAL do
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
						end

						if byte == _Byte.PERIOD then
							return _Token.TRIPLEPERIOD, pos + 1, "...", 3
						else
							return _Token.DOUBLEPERIOD, pos, "..", 2
						end
					elseif byte >= _Byte.ZERO and byte <= _Byte.NINE then
						return _Token.NUMBER, nextNumber(str, pos, true, cursorPos, needTrueWord and ".", 1)
					else
						return _Token.PERIOD, pos, ".", 1
					end
				elseif byte == _Byte.LESSTHAN then
					-- '<'
					pos = pos + 1
					byte = strbyte(str, pos)

					while byte == _Byte.VERTICAL do
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
					end

					if byte == _Byte.EQUALS then
						return _Token.LTE, pos + 1, "<=", 2
					else
						return _Token.LT, pos, "<", 1
					end
				elseif byte == _Byte.GREATERTHAN then
					-- '>'
					pos = pos + 1
					byte = strbyte(str, pos)

					while byte == _Byte.VERTICAL do
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
					end

					if byte == _Byte.EQUALS then
						return _Token.GTE, pos + 1, ">=", 2
					else
						return _Token.GT, pos, ">", 1
					end
				elseif byte == _Byte.TILDE then
					-- '~'
					pos = pos + 1
					byte = strbyte(str, pos)

					while byte == _Byte.VERTICAL do
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
					end

					if byte == _Byte.EQUALS then
						return _Token.NOTEQUAL, pos + 1, "~=", 2
					else
						return _Token.TILDE, pos, "~", 1
					end
				else
					return _Token.UNKNOWN, pos
				end
			end
		end

		-- Number
		if byte >= _Byte.ZERO and byte <= _Byte.NINE then
			return _Token.NUMBER, nextNumber(str, pos, nil, cursorPos, needTrueWord and "")
		end

		-- Identifier
		return _Token.IDENTIFIER, nextIdentifier(str, pos, cursorPos, needTrueWord and "")
	end

	-- Color
	local function FormatColor(str, colorTable, cursorPos)
		local pos = 1

		local token
		local content = {}
		local nextPos
		local trueWord
		local word
		local newPos

		local defaultColor = colorTable.DefaultColor.code
		local commentColor = colorTable.CommentColor.code
		local stringColor = colorTable.StringColor.code
		local numberColor = colorTable.NumberColor.code
		local instructionColor = colorTable.InstructionColor.code

		cursorPos = cursorPos or 0

		local chkLength = 0
		local newCurPos = 0

		local skipNextColorEnd = false

		while true do
			token, nextPos, trueWord, newPos = nextToken(str, pos, cursorPos, true)

			if not token then
				break
			end

			word = trueWord or str:sub(pos, nextPos - 1)
			newPos = newPos or word:len()

			if token == _Token.COLORCODE_START or token == _Token.COLORCODE_END then
				-- clear prev colorcode
				tinsert(content, "")
			elseif token == _Token.IDENTIFIER then
				if _KeyWord[word] then
					tinsert(content, instructionColor .. word .. _EndColor)
				else
					tinsert(content, defaultColor .. word .. _EndColor)
				end
			elseif token == _Token.NUMBER then
				tinsert(content, numberColor .. word .. _EndColor)
			elseif token == _Token.STRING then
				tinsert(content, stringColor .. word .. _EndColor)
			elseif token == _Token.COMMENT then
				tinsert(content, commentColor .. word .. _EndColor)
			else
				tinsert(content, word)
			end

			-- Check cursor position
			if chkLength < cursorPos then
				chkLength = chkLength + nextPos - pos

				if chkLength >= cursorPos then
					if content[#content]:len() > 0 and strbyte(content[#content], 1) == _Byte.VERTICAL then
						if chkLength == cursorPos then
							newCurPos = newCurPos + newPos + 12
						else
							newCurPos = newCurPos + newPos + 10
						end
					elseif token == _Token.COLORCODE_END then
						-- skip
					else
						newCurPos = newCurPos + newPos
					end
				else
					newCurPos = newCurPos + content[#content]:len()
				end
			end

			pos = nextPos
		end

		return tblconcat(content), newCurPos
	end

	-- Indent
	local function FormatIndent(str, self)
		local pos = 1

		local token
		local content = {}
		local indent = 0
		local nextPos
		local word
		local rightSpace = false
		local index
		local prevIndent = 0
		local startIndent = 0
		local prevToken
		local trueWord

		local tab = self.TabWidth

		while true do
			prevToken = token
			token, nextPos, trueWord = nextToken(str, pos, nil, true)

			if not token then
				break
			end

			word = str:sub(pos, nextPos - 1)
			trueWord = trueWord or word

			-- Format Indent
			if token == _Token.LEFTWING then
				indent = indent + 1
				startIndent = startIndent + 1
				tinsert(content, word)
				rightSpace = false
			elseif token == _Token.RIGHTWING then
				indent = indent - 1
				if startIndent > 0 then
					startIndent = startIndent - 1
				else
					prevIndent = prevIndent + 1
				end
				index = #content
				if content[index] == strrep(" ", tab * (indent+1)) then
					content[index] = strrep(" ", tab * indent)
				end
				tinsert(content, word)
				rightSpace = false
			elseif token == _Token.LINEBREAK then
				if rightSpace then
					index = #content
					content[index] = content[index]:gsub("^(.-)%s*$", "%1")
					if content[index] == "" then
						content[index] = strrep(" ", tab * indent)
						-- tremove(content, index)
					end
				end
				tinsert(content, word)
				tinsert(content, strrep(" ", tab * indent))
				rightSpace = true
			elseif token == _Token.SPACE then
				if not rightSpace then
					tinsert(content, " ")
				end
				rightSpace = true
			elseif token == _Token.IDENTIFIER then
				if _KeyWord[trueWord] then
					if _KeyWord[trueWord] == _IndentNone then
						indent = indent
					elseif _KeyWord[trueWord] == _IndentRight then
						indent = indent + 1
						startIndent = startIndent + 1
					elseif _KeyWord[trueWord] == _IndentLeft then
						indent = indent - 1
						if startIndent > 0 then
							startIndent = startIndent - 1
						else
							prevIndent = prevIndent + 1
						end

						if prevToken == _Token.COLORCODE_START then
							index = #content - 1
						else
							index = #content
						end

						if content[index] == strrep(" ", tab * (indent+1)) then
							content[index] = strrep(" ", tab * indent)
						end
					elseif _KeyWord[trueWord] == _IndentBoth then
						indent = indent
						if startIndent == 0 then
							prevIndent = prevIndent + 1
							startIndent = startIndent + 1
						end

						if prevToken == _Token.COLORCODE_START then
							index = #content - 1
						else
							index = #content
						end

						if content[index] == strrep(" ", tab * indent) then
							content[index] = strrep(" ", tab * (indent-1))
						end
					end
					tinsert(content, word)
				else
					tinsert(content, word)

					if not self.__IdentifierCache[word] then
						self.__IdentifierCache[word] = true
						self:InsertAutoCompleteWord(word)
					end
				end
				rightSpace = false
			elseif _WordWrap[token] == _IndentNone then
				tinsert(content, word)
				rightSpace = false
			elseif _WordWrap[token] == _IndentRight then
				tinsert(content, word .. " ")
				rightSpace = true
			elseif _WordWrap[token] == _IndentLeft then
				if rightSpace then
					tinsert(content, word)
				else
					tinsert(content, " " .. word)
				end
				rightSpace = false
			elseif _WordWrap[token] == _IndentBoth then
				if rightSpace then
					tinsert(content, word .. " ")
				else
					tinsert(content, " " .. word .. " ")
				end
				rightSpace = true
			else
				tinsert(content, word)
				rightSpace = false
			end

			pos = nextPos
		end

		str = tblconcat(content)

		wipe(content)

		return str, indent, prevIndent
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

	-- Edit function
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

	local function RemoveColor(str, cursorPos)
		local pos = 1

		local token
		local content = {}
		local nextPos
		local trueWord
		local word

		cursorPos = cursorPos or 0

		local chkLength = 0
		local newCurPos = 0

		while true do
			token, nextPos, trueWord = nextToken(str, pos, nil, true)

			if not token then
				break
			end

			word = trueWord or str:sub(pos, nextPos - 1)

			if token == _Token.COLORCODE_START or token == _Token.COLORCODE_END then
				-- clear prev colorcode
				tinsert(content, "")
			else
				tinsert(content, word)
			end

			-- Check cursor position
			if chkLength < cursorPos then
				chkLength = chkLength + nextPos - pos

				if chkLength >= cursorPos then
					newCurPos = newCurPos + cursorPos - (chkLength - word:len())
				else
					newCurPos = newCurPos + content[#content]:len()
				end
			end

			pos = nextPos
		end

		return tblconcat(content), newCurPos
	end

	local function FormatColor4Line(self, startp, endp)
		local cursorPos = self.CursorPosition
		local text = self.FullText
		local byte
		local line

		local commentColor = self.CommentColor.code
		local stringColor = self.StringColor.code

		startp = startp or cursorPos
		endp = endp or cursorPos

		-- Color the line
		startp, endp, line = GetLines(text, startp, endp)

		-- check prev comment
		local preColorPos = startp - 1
		local token, nextPos

		while preColorPos > 0 do
			byte = strbyte(text, preColorPos)

			if byte == _Byte.VERTICAL then
				-- '|'
				byte = strbyte(text, preColorPos + 1)

				if byte == _Byte.c then
					if commentColor == text:sub(preColorPos, preColorPos + 9) or stringColor == text:sub(preColorPos, preColorPos + 9) then
						-- check multi-lines comment or string
						token, nextPos = nextToken(text, preColorPos + 10)

						if token == _Token.COMMENT or token == _Token.STRING then
							if nextPos < startp and nextPos < endp then
								break	-- no need to think about prev multi-lines comment and string
							end

							while token and (nextPos <= endp or nextPos <= startp) do
								token, nextPos = nextToken(text, nextPos)
							end

							byte = strbyte(text, nextPos)

							if not byte or (nextPos - 1 > endp and nextPos - 1 > startp) then
								line, cursorPos = FormatColor(text:sub(preColorPos, nextPos - 1), self, cursorPos - preColorPos + 1)

								self.FullText = ReplaceBlock(text, preColorPos, nextPos - 1, line)

								cursorPos = preColorPos + cursorPos - 1

								return AdjustCursorPosition(self, cursorPos)
							end

							token, nextPos = nextToken(text, nextPos)

							while token do
								if token == _Token.COLORCODE_START or token == _Token.COLORCODE_END then
									line, cursorPos = FormatColor(text:sub(preColorPos, endp), self, cursorPos - preColorPos + 1)

									self.FullText = ReplaceBlock(text, preColorPos, endp, line)

									cursorPos = preColorPos + cursorPos - 1

									return AdjustCursorPosition(self, cursorPos)
								elseif token == _Token.IDENTIFIER or token == _Token.NUMBER or token == _Token.STRING or token == _Token.COMMENT then
									while token and token ~= _Token.COLORCODE_END do
										token, nextPos = nextToken(text, nextPos)
									end

									line, cursorPos = FormatColor(text:sub(preColorPos, nextPos - 1), self, cursorPos - preColorPos + 1)

									self.FullText = ReplaceBlock(text, preColorPos, nextPos - 1, line)

									cursorPos = preColorPos + cursorPos - 1

									return AdjustCursorPosition(self, cursorPos)
								end

								token, nextPos = nextToken(text, nextPos)
							end
						else
							break
						end
					else
						break
					end
				end
			end

			preColorPos = preColorPos - 1
		end

		nextPos = startp
		token, nextPos = nextToken(text, nextPos)

		while token and (nextPos <= endp or nextPos <= startp) do
			token, nextPos = nextToken(text, nextPos)
		end

		if nextPos - 1 > endp and nextPos - 1 > startp then
			line, cursorPos = FormatColor(text:sub(startp, nextPos - 1), self, cursorPos - startp + 1)

			self.FullText = ReplaceBlock(text, startp, nextPos - 1, line)

			cursorPos = startp + cursorPos - 1

			return AdjustCursorPosition(self, cursorPos)
		end

		while true do
			if not token then
				line, cursorPos = FormatColor(text:sub(startp, endp), self, cursorPos - startp + 1)

				self.FullText = ReplaceBlock(text, startp, endp, line)

				cursorPos = startp + cursorPos - 1

				return AdjustCursorPosition(self, cursorPos)
			elseif token == _Token.COLORCODE_START or token == _Token.COLORCODE_END then
				line, cursorPos = FormatColor(text:sub(startp, endp), self, cursorPos - startp + 1)

				self.FullText = ReplaceBlock(text, startp, endp, line)

				cursorPos = startp + cursorPos - 1

				return AdjustCursorPosition(self, cursorPos)
			elseif token == _Token.IDENTIFIER or token == _Token.NUMBER or token == _Token.STRING or token == _Token.COMMENT then
				while token and token ~= _Token.COLORCODE_END do
					token, nextPos = nextToken(text, nextPos)
				end

				line, cursorPos = FormatColor(text:sub(startp, nextPos - 1), self, cursorPos - startp + 1)

				self.FullText = ReplaceBlock(text, startp, nextPos - 1, line)

				cursorPos = startp + cursorPos - 1

				return AdjustCursorPosition(self, cursorPos)
			end

			token, nextPos = nextToken(text, nextPos)
		end
	end

    local function FormatColor4Delay()
        if _CheckTimer.Interval <= 0 then return end

        local editor = _KeyScan.FocusEditor

        _CheckTimer.Interval = 0

        if editor then
            local cursorPos = editor.CursorPosition

            if editor.__DELETE then
                editor.__DELETE = nil

                return FormatColor4Line(editor)
            end

            if editor.__BACKSPACE then
                --[[
                local text = editor.FullText
                local startp, endp, str = GetLines(text, cursorPos)

                local _, len = str:find("^%s+")

                if len and len > 1 and startp + len - 1 >= cursorPos and len % editor.TabWidth ~= 0 then
                    str = str:sub(len + 1, -1)
                    len = floor(len/editor.TabWidth) * editor.TabWidth

                    str = strrep(" ", len) .. str

                    editor.FullText = ReplaceBlock(text, startp, endp, str)

                    AdjustCursorPosition(editor, startp - 1 + len)
                end --]]

                editor.__BACKSPACE = nil

                return FormatColor4Line(editor)
            end
        end
    end

	local function FormatAll(str, self)
		local pos = 1
		local tab = self.TabWidth

		local token
		local content = {}
		local nextPos
		local trueWord
		local word

		local defaultColor = self.DefaultColor.code
		local commentColor = self.CommentColor.code
		local stringColor = self.StringColor.code
		local numberColor = self.NumberColor.code
		local instructionColor = self.InstructionColor.code

		local indent = 0
		local rightSpace = false
		local index
		local prevIndent = 0
		local startIndent = 0
		local prevToken

		InitDefinition(self)

		while true do
			prevToken = token
			token, nextPos, trueWord = nextToken(str, pos, nil, true)

			if not token then
				break
			end

			word = trueWord or str:sub(pos, nextPos - 1)

			if token == _Token.COLORCODE_START or token == _Token.COLORCODE_END then
				-- clear prev colorcode
				tinsert(content, "")
			elseif token == _Token.LEFTWING then
				indent = indent + 1
				startIndent = startIndent + 1
				tinsert(content, word)
				rightSpace = false
			elseif token == _Token.RIGHTWING then
				indent = indent - 1
				if startIndent > 0 then
					startIndent = startIndent - 1
				else
					prevIndent = prevIndent + 1
				end
				index = #content
				if content[index] == strrep(" ", tab * (indent+1)) then
					content[index] = strrep(" ", tab * indent)
				end
				tinsert(content, word)
				rightSpace = false
			elseif token == _Token.LINEBREAK then
				if rightSpace then
					index = #content
					content[index] = content[index]:gsub("^(.-)%s*$", "%1")
					if content[index] == "" then
						content[index] = strrep(" ", tab * indent)
						-- tremove(content, index)
					end
				end
				tinsert(content, word)
				tinsert(content, strrep(" ", tab * indent))
				rightSpace = true
			elseif token == _Token.SPACE then
				if not rightSpace then
					tinsert(content, " ")
				end
				rightSpace = true
			elseif token == _Token.IDENTIFIER then
				if _KeyWord[word] then
					if _KeyWord[word] == _IndentNone then
						indent = indent
					elseif _KeyWord[word] == _IndentRight then
						indent = indent + 1
						startIndent = startIndent + 1
					elseif _KeyWord[word] == _IndentLeft then
						indent = indent - 1
						if startIndent > 0 then
							startIndent = startIndent - 1
						else
							prevIndent = prevIndent + 1
						end

						if prevToken == _Token.COLORCODE_START then
							index = #content - 1
						else
							index = #content
						end

						if content[index] == strrep(" ", tab * (indent+1)) then
							content[index] = strrep(" ", tab * indent)
						end
					elseif _KeyWord[word] == _IndentBoth then
						indent = indent
						if startIndent == 0 then
							prevIndent = prevIndent + 1
							startIndent = startIndent + 1
						end

						if prevToken == _Token.COLORCODE_START then
							index = #content - 1
						else
							index = #content
						end

						if content[index] == strrep(" ", tab * indent) then
							content[index] = strrep(" ", tab * (indent-1))
						end
					end
					tinsert(content, instructionColor .. word .. _EndColor)
				else
					tinsert(content, defaultColor .. word .. _EndColor)

					word = RemoveColor(word)
					if not self.__IdentifierCache[word] then
						self.__IdentifierCache[word] = true
						self:InsertAutoCompleteWord(word)
					end
				end
				rightSpace = false
			else
				if token == _Token.NUMBER then
					tinsert(content, numberColor .. word .. _EndColor)
				elseif token == _Token.STRING then
					tinsert(content, stringColor .. word .. _EndColor)
				elseif token == _Token.COMMENT then
					tinsert(content, commentColor .. word .. _EndColor)
				else
					tinsert(content, word)
				end

				if _WordWrap[token] == _IndentNone then
					rightSpace = false
				elseif _WordWrap[token] == _IndentRight then
					content[#content] = content[#content] .. " "
					rightSpace = true
				elseif _WordWrap[token] == _IndentLeft then
					if not rightSpace then
						content[#content] = " " .. content[#content]
					end
					rightSpace = false
				elseif _WordWrap[token] == _IndentBoth then
					if rightSpace then
						content[#content] = content[#content] .. " "
					else
						content[#content] = " " .. content[#content] .. " "
					end
					rightSpace = true
				else
					rightSpace = false
				end
			end

			pos = nextPos
		end

		return tblconcat(content)
	end

	local function GetIndex(list, name, sIdx, eIdx)
		if not sIdx then
			if not next(list) then
				return nil
			end
			sIdx = 1
			eIdx = #list
		end
		if sIdx == eIdx then
			if sIdx > 1 then
				return sIdx - 1
			else
				return nil
			end
		end
		local f = floor((sIdx + eIdx) / 2)
		if compare(list[f], name) then
			if not compare(list[f + 1], name) then
				return f
			else
				return GetIndex(list, name, f + 1, eIdx)
			end
		elseif strupper(list[f]) == strupper(name) then
			return GetIndex(list, name, f, f)
		else
			return GetIndex(list, name, sIdx, f)
		end
	end

	local function GetPrevObject(self)
		do
			return nil
		end
		local cursorPos = self.CursorPosition
		local text = self.FullText

		local startp, _, str = GetLines(text, cursorPos)

		str = RemoveColor(str:sub(1, cursorPos - startp))

		local id = str:match("([_%a][_%w%.]*)$")

		if id == "self" then
			while startp > 1 do
				startp, _, str = GetLines(text, startp - 2)

				if str ~= "" then
					str = RemoveColor(str)

					id = str:match("function%s*([_%a][_%w%.]*):")

					if id and id ~= "" then
						break
					end
				end
			end
		end

		local obj

		if id and id ~= "" then
			for sub in id:gmatch("[^%.]+") do
				sub = sub and strtrim(sub)
				if not sub or sub =="" then return end


			end
		end

		return obj
	end

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	__Doc__[[
		<desc>Sets the code editor's code content</desc>
		<param name="text">string, the lua code</param>
	]]
	function SetText(self, str)
		if type(str) ~= "string" then
			error("Usage : CodeEditor:SetText(text) : 'text' - string expected.", 2)
		end

		-- Format text
        str = str:gsub("\124", "\124\124")
		MultiLineTextBox.SetText(self, FormatAll(str, self))
	end

	__Doc__[[
		<desc>Get the content lua code</desc>
		<return type="string">the lua code</return>
	]]
	function GetText(self)
		local str = RemoveColor(self.FullText)
        str = str:gsub("\124\124", "\124")
        return str
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	__Doc__[[color for normal code]]
	property "DefaultColor" {
		Get = function(self)
			return self.__DefaultColor or _DefaultColor
		end,
		Set = function(self, color)
			self.__DefaultColor = color

			-- UpdateText
			self:SetText(self.FullText)
		end,
		Type = System.Widget.ColorType + nil,
	}

	__Doc__[[color for comment]]
	property "CommentColor" {
		Get = function(self)
			return self.__CommentColor or _CommentColor
		end,
		Set = function(self, color)
			self.__CommentColor = color

			-- UpdateText
			self:SetText(self.FullText)
		end,
		Type = System.Widget.ColorType + nil,
	}

	__Doc__[[color for string]]
	property "StringColor" {
		Get = function(self)
			return self.__StringColor or _StringColor
		end,
		Set = function(self, color)
			self.__StringColor = color

			-- UpdateText
			self:SetText(self.FullText)
		end,
		Type = System.Widget.ColorType + nil,
	}

	__Doc__[[color for number]]
	property "NumberColor" {
		Get = function(self)
			return self.__NumberColor or _NumberColor
		end,
		Set = function(self, color)
			self.__NumberColor = color

			-- UpdateText
			self:SetText(self.FullText)
		end,
		Type = System.Widget.ColorType + nil,
	}

	__Doc__[[color for instruction]]
	property "InstructionColor" {
		Get = function(self)
			return self.__InstructionColor or _InstructionColor
		end,
		Set = function(self, color)
			self.__InstructionColor = color

			-- UpdateText
			self:SetText(self.FullText)
		end,
		Type = System.Widget.ColorType + nil,
	}

	__Doc__[[the full text contains color token]]
	property "FullText" {
		Set = function(self, text)
			MultiLineTextBox.AdjustText(self, text)
		end,

		Get = function(self)
			return MultiLineTextBox.GetText(self)
		end,

		Type = String,
	}

	------------------------------------------------------
	-- Event Handlers
	------------------------------------------------------
	local function OnEnterPressed(self)
		local cursorPos = self.CursorPosition
		local text = self.FullText
		local lstartp, lendp, lstr = GetLines(text, cursorPos - 1)
		local _, len, indent, startp, endp, str, lprevIndent, oprevIndent, prevIndent, lindent, llen

		lstr = lstr or ""

		_, llen = lstr:find("^%s+")

		llen = llen or 0

		lstr, lindent, lprevIndent = FormatIndent(lstr:sub(llen+1, -1), self)

		oprevIndent = lprevIndent

		if lprevIndent == 0 then
			if lindent == 0 then
				self:Insert(strrep(" ", llen))
			elseif lindent > 0 then
				self:Insert(strrep(" ", floor(llen/self.TabWidth)*self.TabWidth + self.TabWidth * lindent))
			end
		else
			startp, endp, str, len = lstartp, lendp, lstr, llen

			while startp > 1 do
				startp, endp, str = GetLines(text, startp - 2)

				if startp < endp then
					_, len = str:find("^%s+")

					len = len or 0

					if len < str:len() then
						str, indent, prevIndent = FormatIndent(str:sub(len+1, -1), self)

						lprevIndent = lprevIndent - indent

						if lprevIndent <= 0 then
							break
						end
					end
				end
			end

			if lprevIndent <= 0 then
				lstr = strrep(" ", floor(len / self.TabWidth) * self.TabWidth) .. lstr
				self.FullText = ReplaceBlock(text, lstartp, lendp, lstr)
				AdjustCursorPosition(self, lstartp + lstr:len())
				self:Insert(strrep(" ", floor(len / self.TabWidth) * self.TabWidth + self.TabWidth * (lindent + oprevIndent)))
			else
				self.FullText = ReplaceBlock(text, lstartp, lendp, lstr)
				AdjustCursorPosition(self, lstartp + lstr:len())
				self:Insert(strrep(" ", self.TabWidth * (lindent + oprevIndent)))
			end
		end

		return FormatColor4Line(self, lstartp)
	end

	local function OnChar(self, char)
		-- Keep change to operation list
		--if char == "." then
			-- check property
		--	local obj = GetPrevObject(self)
		--elseif char == ":" then
			-- check method
		--	local obj = GetPrevObject(self)
		--else
		-- Color the line
		return FormatColor4Line(self)
		--end
	end

	local function OnCursorChanged(self, x, y, w, h)
		self.__X = x
		self.__Y = y
	end

	local function OnOperationListChanged(self, startp, endp)
		if startp and endp then
			return FormatColor4Line(self, startp, endp)
		end
	end

	local function OnDeleteFinished(self)
		return FormatColor4Line(self)
	end

	local function OnBackspaceFinished(self)
		return FormatColor4Line(self)
	end

	local function OnPasting(self, startp, endp)
		if startp and endp then
			return FormatColor4Line(self, startp, endp)
		end
	end

	local function OnCut(self)
		return FormatColor4Line(self)
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function CodeEditor(self, name, parent, ...)
    	Super(self, name, parent, ...)

		-- Event Handlers
		self.OnEnterPressed = self.OnEnterPressed + OnEnterPressed
		--self.OnCursorChanged = self.OnCursorChanged + OnCursorChanged
		self.OnChar = self.OnChar + OnChar
		self.OnOperationListChanged = self.OnOperationListChanged + OnOperationListChanged
		self.OnPasting = self.OnPasting + OnPasting
		self.OnDeleteFinished = self.OnDeleteFinished + OnDeleteFinished
		self.OnBackspaceFinished = self.OnBackspaceFinished + OnBackspaceFinished
		self.OnCut = self.OnCut + OnCut

		-- Enviroment
		InitDefinition(self)
	end
endclass "CodeEditor"
