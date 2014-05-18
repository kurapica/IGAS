-- Author      : Kurapica
-- Create Date : 2014/03/10
-- ChangeLog   :

Module "System.Xml" "1.0.0"

import "System"

__Doc__[[The System.Xml namespace provides standards-based support for processing XML.]]
namespace "System.Xml"

--[[==============
	XML Parser
--================]]
do
	tinsert = table.insert
	tremove = table.remove
	strsub = string.gsub
	strbyte = string.byte
	strchar = string.char
	wipe = function(t) for k in pairs(t) do t[k] = nil end end
	cache = setmetatable({}, {__call = function(self, tbl) if tbl then wipe(tbl) tinsert(self, tbl) else return tremove(self) or {} end end,})
	newIndex = function(reset) _M.AutoIndex = reset or ((_M.AutoIndex or 0) + 1); return _M.AutoIndex end
	stackAPI = {
		New = function()
			local stack = { Token = {}, Pos = {}, Info = {}, StackLen = 0 }

			for k, v in pairs(stackAPI) do if k ~= "New" then stack[k] = v end end

			return stack
		end,
		Push = function(self, token, pos, info)
			local index = self.StackLen + 1

			self.Token[index] = token
			self.Pos[index] = pos
			self.Info[index] = info

			self.StackLen = index

			return self:Parse()
		end,
		Pop = function(self)
			local index = self.StackLen

			if index == 0 then return end

			local token = self.Token[index]
			local pos = self.Pos[index]
			local info = self.Info[index]

			self.Token[index] = nil
			self.Pos[index] = nil
			self.Info[index] = nil

			self.StackLen = self.StackLen - 1

			return token, pos, info
		end,
		Parse = function(self)
			local index = self.StackLen
			local token = self.Token[index]

			if _TokenParser[token] then
				for _, parser in ipairs(_TokenParser[token]) do
					if type(parser) == "function" then
						if parser(self) then
							return self:Parse()
						end
					elseif type(parser) == "table" then
						local match = true
						for i = #parser, 1, -1 do
							if parser[i] == self.Token[index] then
								index = index - 1
							else
								match = false
								break
							end
						end

						if match then
							local buildInfo = parser.BuildInfo
							local tmp = buildInfo and cache()
							local token, pos, info

							for i = #parser, 1, -1 do
								token, pos, info = self:Pop()

								if tmp then tmp[i] = info end
							end

							local newInfo
							if tmp then
								newIndex = buildInfo(tmp)
								cache(tmp)
							end

							self:Push(parser[0], pos, newInfo)

							return self:Parse()
						end
					end
				end
			end
		end,
		ThrowError = function(self, msg, pos)
			local line = 1
			local linePos = 0
			local newLine = _Token.LF
			local ret = _Token.CR
			local sToken = self.Token
			local sPos = self.Pos
			local sInfo = self.Info

			for i = 1, self.StackLen do
				if sPos[i] < pos then
					if sToken == newLine or sToken == ret then
						line = line + 1
						linePos = sPos[i] + sInfo[i] or 1
					end
				else
					break
				end
			end

			error(([[Error at line %d column %d : %s]]):format(line, pos - linePos + 1, msg), 3)
		end,
	}

	_Token = {
		NAME_START	= newIndex(),
		NAME_CHAR	= newIndex(),
		NAME		= newIndex(),
		NAMES		= newIndex(),
		NAME_TOKEN	= newIndex(),
		NAME_TOKENS	= newIndex(),

		VALUE		= newIndex(),

		OPEN_TAG	= newIndex(),
		CLOSE_TAG	= newIndex(),

		EMP_ELEMENT	= newIndex(),

		WHITE_SPACE = newIndex(),


		SPACE		= newIndex(),
		TAB			= newIndex(),

		LF			= newIndex(),
		CR			= newIndex(),

		EXCLAMATION	= newIndex(),
		DOUBLE_QUOTE= newIndex(),
		NUMBER_SIGN	= newIndex(),
		DOLLAR_SIGN	= newIndex(),
		PERCENT		= newIndex(),
		AMP			= newIndex(),
		SINGLE_QUOTE= newIndex(),
		LEFTPAREN	= newIndex(),
		RIGHTPAREN	= newIndex(),
		ASTERISK	= newIndex(),
		PLUS		= newIndex(),
		COMMA		= newIndex(),
		MINUS		= newIndex(),
		PERIOD		= newIndex(),
		SLASH		= newIndex(),
		COLON		= newIndex(),
		SEMICOLON	= newIndex(),
		LESSTHAN	= newIndex(),
		EQUALS		= newIndex(),
		GREATERTHAN	= newIndex(),
		QUESTION	= newIndex(),
		AT_SIGN		= newIndex(),
		LEFTBRACKET	= newIndex(),
		BACKSLASH	= newIndex(),
		RIGHTBRACKET= newIndex(),
		CARET		= newIndex(),
		UNDERLINE	= newIndex(),
		GRAVE_ACCENT= newIndex(),
		LEFTWING	= newIndex(),
		VERTICAL	= newIndex(),
		RIGHTWING	= newIndex(),
		TILDE		= newIndex(),
	}

	_Byte = {
		SPACE		= strbyte(" "),
		TAB			= strbyte("\t"),

		LF			= strbyte("\n"),
		CR			= strbyte("\r"),

		EXCLAMATION	= strbyte("!"),
		DOUBLE_QUOTE= strbyte('"'),
		NUMBER_SIGN	= strbyte("#"),
		DOLLAR_SIGN	= strbyte("$"),
		PERCENT		= strbyte("%"),
		AMP			= strbyte("&"),
		SINGLE_QUOTE= strbyte("'"),
		LEFTPAREN	= strbyte("("),
		RIGHTPAREN	= strbyte(")"),
		ASTERISK	= strbyte("*"),
		PLUS		= strbyte("+"),
		COMMA		= strbyte(","),
		MINUS		= strbyte("-"),
		PERIOD		= strbyte("."),
		SLASH		= strbyte("/"),
		COLON		= strbyte(":"),
		SEMICOLON	= strbyte(";"),
		LESSTHAN	= strbyte("<"),
		EQUALS		= strbyte("="),
		GREATERTHAN	= strbyte(">"),
		QUESTION	= strbyte("?"),
		AT_SIGN		= strbyte("@"),
		LEFTBRACKET	= strbyte("["),
		BACKSLASH	= strbyte("\\"),
		RIGHTBRACKET= strbyte("]"),
		CARET		= strbyte("^"),
		UNDERLINE	= strbyte("_"),
		GRAVE_ACCENT= strbyte("`"),
		LEFTWING	= strbyte("{"),
		VERTICAL	= strbyte("|"),
		RIGHTWING	= strbyte("}"),
		TILDE		= strbyte("~"),
	}

	_Special = {
		[_Byte.SPACE] = _Token.WHITE_SPACE,
		[_Byte.TAB] = _Token.WHITE_SPACE,

		[_Byte.LF] = _Token.LF,
		[_Byte.CR] = _Token.CR,

		[_Byte.EXCLAMATION] = _Token.EXCLAMATION,
		[_Byte.DOUBLE_QUOTE] = _Token.DOUBLE_QUOTE,
		[_Byte.NUMBER_SIGN] = _Token.NUMBER_SIGN,
		[_Byte.DOLLAR_SIGN] = _Token.DOLLAR_SIGN,
		[_Byte.PERCENT] = _Token.PERCENT,
		[_Byte.AMP] = _Token.AMP,
		[_Byte.SINGLE_QUOTE] = _Token.SINGLE_QUOTE,
		[_Byte.LEFTPAREN] = _Token.LEFTPAREN,
		[_Byte.RIGHTPAREN] = _Token.RIGHTPAREN,
		[_Byte.ASTERISK] = _Token.ASTERISK,
		[_Byte.PLUS] = _Token.PLUS,
		[_Byte.COMMA] = _Token.COMMA,
		[_Byte.MINUS] = _Token.MINUS,
		[_Byte.PERIOD] = _Token.PERIOD,
		[_Byte.SLASH] = _Token.SLASH,
		[_Byte.COLON] = _Token.COLON,
		[_Byte.SEMICOLON] = _Token.SEMICOLON,
		[_Byte.LESSTHAN] = _Token.LESSTHAN,
		[_Byte.EQUALS] = _Token.EQUALS,
		[_Byte.GREATERTHAN] = _Token.GREATERTHAN,
		[_Byte.QUESTION] = _Token.QUESTION,
		[_Byte.AT_SIGN] = _Token.AT_SIGN,
		[_Byte.LEFTBRACKET] = _Token.LEFTBRACKET,
		[_Byte.BACKSLASH] = _Token.BACKSLASH,
		[_Byte.RIGHTBRACKET] = _Token.RIGHTBRACKET,
		[_Byte.CARET] = _Token.CARET,
		[_Byte.UNDERLINE] = _Token.UNDERLINE,
		[_Byte.GRAVE_ACCENT] = _Token.GRAVE_ACCENT,
		[_Byte.LEFTWING] = _Token.LEFTWING,
		[_Byte.VERTICAL] = _Token.VERTICAL,
		[_Byte.RIGHTWING] = _Token.RIGHTWING,
		[_Byte.TILDE] = _Token.TILDE,
	}

	_Encode = {
		["UTF-8"] = {
			Default = function (str, startp)
				local byte = strbyte(str, startp)
				local len = byte < 192 and 1 or
							byte < 224 and 2 or
							byte < 240 and 3 or
							byte < 248 and 4 or
							byte < 252 and 5 or
							byte < 254 and 6 or -1

				if len == -1 then
					return false
				elseif len > 1 then
					byte = byte % ( 2 ^ ( 8 - len ))

					for i = 1, len do
						local nbyte = strbyte(str, startp + i)
						if not nbyte then return false end
						byte = byte * 64 + len % 64
					end
				end

				return byte, strsub(str, startp, startp + len - 1), len
			end,
		},
		["UTF-16"] = {
			BigEndian = function (str, startp)
				local obyte, sbyte = strbyte(str, startp, startp + 1)

				if obyte <= 0xD7 then
					-- two bytes
					return obyte * 256 + sbyte, strchar(obyte, sbyte), 2
				elseif obyte >= 0xD8 and obyte <= 0xDB then
					-- four byte
					local tbyte, fbyte = strbyte(str, startp + 2, startp + 3)
					if tbyte >= 0xDC and tbyte <= 0xDF then
						return ((obyte - 0xD8) * 256 + sbyte) * 1024 + ((tbyte - 0xDC) * 256 + fbyte) + 0x10000, strchar(obyte, sbyte, tbyte, fbyte), 4
					else
						return false
					end
				else
					return false
				end
			end,
			LittleEndian = function (str, startp)
				local sbyte, obyte = strbyte(str, startp, startp + 1)

				if obyte <= 0xD7 then
					-- two bytes
					return obyte * 256 + sbyte, strchar(obyte, sbyte), 2
				elseif obyte >= 0xD8 and obyte <= 0xDB then
					-- four byte
					local fbyte, tbyte = strbyte(str, startp + 2, startp + 3)
					if tbyte >= 0xDC and tbyte <= 0xDF then
						return ((obyte - 0xD8) * 256 + sbyte) * 1024 + ((tbyte - 0xDC) * 256 + fbyte) + 0x10000, strchar(obyte, sbyte, tbyte, fbyte), 4
					else
						return false
					end
				else
					return false
				end
			end
		},
	}

	_ValidChar = {
		Single = {
			[_Byte.TAB] = true,
			[_Byte.CR] = true,
			[_Byte.LF] = true,
		},
		Range = {
			{ 0x20, 0xD7FF },
			{ 0xE000 , 0xFFFD },
			{ 0x10000 , 0x10FFFF },
		},
	}

	_NameStartChar = {
		Single = {
			[_Byte.COLON] = true,
			[_Byte.UNDERLINE] = true,
		},
		Range = {
			{ strbyte("A"), strbyte("Z") },
			{ strbyte("a"), strbyte("z") },
			{ 0xC0, 0xD6 },
			{ 0xD8, 0xF6 },
			{ 0xF8, 0x2FF },
			{ 0x370, 0x37D },
			{ 0x37F, 0x1FFF },
			{ 0x200C, 0x200D },
			{ 0x2070, 0x218F },
			{ 0x2C00, 0x2FEF },
			{ 0x3001, 0xD7FF },
			{ 0xF900, 0xFDCF },
			{ 0xFDF0, 0xFFFD },
			{ 0x10000, 0xEFFFF },
		},
	}

	_NameChar = {
		Base = _NameStartChar,
		Single = {
			[_Byte.MINUS] = true,
			[_Byte.PERIOD] = true,
			[ 0xB7 ] = true,
		},
		Range = {
			{ strbyte("0"), strbyte("9") },
			{ 0x0300, 0x036F },
			{ 0x203F, 0x2040 },
		},
	}

	_XMLTokenParser = {
		[_Token.LF] = {
			{	-- CRLF -> LF
				[0] = _Token.LF,
				_Token.CR,
				_Token.LF,

				BuildInfo = function(infos)
					return 2
				end,
			},
		},
		[_Token.GREATERTHAN] = {
			{	-- <tagname> -> open tag
				[0] = _Token.OPEN_TAG,
				_Token.LESSTHAN,
				_Token.NAME,
				_Token.GREATERTHAN,

				BuildInfo = function(infos)
					return infos[2]
				end,
			},
			{	-- </tagname> -> close tag
				[0] = _Token.CLOSE_TAG,
				_Token.LESSTHAN,
				_Token.SLASH,
				_Token.NAME,
				_Token.GREATERTHAN,

				BuildInfo = function(infos)
					return infos[3]
				end,
			},
			{	--<tagname/> -> empty element
				[0] = _Token.EMP_ELEMENT,
				_Token.LESSTHAN,
				_Token.NAME,
				_Token.SLASH,
				_Token.GREATERTHAN,

				BuildInfo = function(infos)
					return XmlNode{ Name = infos[2] }
				end,
			},
		},
	}

	function isChar(char, define)
		if define.Base and isChar(char, define.Base) then return true end
		if define.Single and define.Single[char] then return true end
		if define.Range then
			for _, range in ipairs(define.Range) do
				if char < range[0] then break end
				if char <= range[1] then return true end
			end
		end
		return false
	end

	function loadXML(data, fileEncode, isBigEndian)
		-- Checking byte order mark
		local bom = data:byte(1, 4)
		local encode = "UTF-8"
		local startp = 1
		local bigEndian

		if bom[1] == 0xEF and bom[2] == 0xBB and bom[3] == 0xBF then
			encode = "UTF-8"
			startp = 4
		--[[elseif bom[1] == 0xFF and bom[2] == 0xFE and bom[3] == 0x00 and bom[4] == 0x00 then
			encode = "UTF-32"
			bigEndian = false
			startp = 5
		elseif bom[1] == 0x00 and bom[2] == 0x00 and bom[3] == 0xFE and bom[4] == 0xFF then
			encode = "UTF-32"
			bigEndian = true
			startp = 5--]]
		elseif bom[1] == 0xFF and bom[2] == 0xFE then
			encode = "UTF-16"
			bigEndian = false
			startp = 3
		elseif bom[1] == 0xFE and bom[2] == 0xFF then
			encode = "UTF-16"
			bigEndian = true
			startp = 3
		end

		if ( not encode or not fileEncode or encode == fileEncode ) and
			( isBigEndian == nil or ( (encode == "UTF-16" or encode == "UTF-32") and bigEndian == isBigEndian )) then

			return parseXmlElements(data, startp, encode, bigEndian)
		else
			return false
		end
	end

	function parseXmlElements(data, start, encode, isBigEndian)
		encode = encode or "UTF-8"
		startp = startp or 1
		local endp = endp or #data

		local getChar = isBigEndian and _Encode[encode].BigEndian or _Encode[encode].LittleEndian or _Encode[encode].Default
		local pos = startp
		local char, string
		local len = 0
		local stack = stackAPI:New()

		while pos <= endp do
			pos = pos + len
			char, string, len = getChar(data, pos)

			if not char or not isChar(char, _ValidChar) then
				return stack:ThrowError("Not a valid char.", pos)
			end

			-- Check last token for open tag
			if stack.Token[stack.StackLen] == _Token.OPEN_TAG then

			end

			if _Special[char] then
				local token = _Special[char]

				if token == _Token.WHITE_SPACE then
					-- Skip
				elseif token == _Token.DOUBLE_QUOTE or token == _Token.SINGLE_QUOTE then
					local spos = pos
					local startChar = char
					local value = ""

					-- scan full name
					while pos <= endp do
						pos = pos + len
						char, string, len = getChar(data, pos)

						if not char or not isChar(char, _ValidChar)  then
							return stack:ThrowError("Not a valid char.", pos)
						elseif startChar == char then
							break
						end

						value = value .. string
					end

					stack:Push(_Token.VALUE, spos, value)
				else
					stack:Push(token, pos)
				end
			elseif isChar(char, _NameStartChar) then
				local spos = pos
				local name = string

				-- scan full name
				while pos <= endp do
					pos = pos + len
					char, string, len = getChar(data, pos)

					if not char or not isChar(char, _NameChar) then
						len = 0 break
					end

					name = name .. string
				end

				stack:Push(_Token.NAME, spos, name)
			end
		end
	end
end

__Doc__[[Represents a single node in the XML document.]]
class "XmlNode"
	------------------------------------------------------
	-- Event
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	__Doc__[[Gets an XmlAttributeCollection containing the attributes of this node.]]
	property "Attributes" {
		Get = function (self)
			return self.__Attributes
		end,
	}

	__Doc__[[Gets the base URI of the current node.]]
	property "BaseURI" {
		Get = function (self)
			return self.__BaseURI
		end,
	}

	__Doc__[[Gets all the child nodes of the node.]]
	property "ChildNodes" {
		Get = function (self)
			return self.__ChildNodes
		end,
	}

	__Doc__[[Gets the first child of the node.]]
	property "FirstChild" {
		Get = function (self)
			return self.__ChildNodes[1]
		end,
	}

	__Doc__[[Gets a value indicating whether this node has any child nodes.]]
	property "HasChildNodes" {
		Get = function (self)
			return #(self.__ChildNodes) > 0
		end,
	}

	__Doc__[[Gets or sets the concatenated values of the node and all its child nodes.]]
	property "InnerText" {
		Get = function (self)
			-- body
		end
	}

	__Doc__[[Gets or sets the markup representing only the child nodes of this node.]]
	property "InnerXml" {}

	__Doc__[[Gets a value indicating whether the node is read-only.]]
	property "IsReadOnly" {}

	__Doc__[[[String]	Gets the first child element with the specified Name.]]
	property "Item" {}

	__Doc__[[[String, String]	Gets the first child element with the specified LocalName and NamespaceURI.]]
	property "Item" {}

	__Doc__[[Gets the last child of the node.]]
	property "LastChild" {}

	__Doc__[[Gets the local name of the node, when overridden in a derived class.]]
	property "LocalName" {}

	__Doc__[[Gets the qualified name of the node, when overridden in a derived class.]]
	property "Name" {}

	__Doc__[[Gets the namespace URI of this node.]]
	property "NamespaceURI" {}

	__Doc__[[Gets the node immediately following this node.]]
	property "NextSibling" {}

	__Doc__[[Gets the type of the current node, when overridden in a derived class.]]
	property "NodeType" {}

	__Doc__[[Gets the markup containing this node and all its child nodes.]]
	property "OuterXml" {}

	__Doc__[[Gets the XmlDocument to which this node belongs.]]
	property "OwnerDocument" {}

	__Doc__[[Gets the parent of this node (for nodes that can have parents).]]
	property "ParentNode" {}

	__Doc__[[Gets or sets the namespace prefix of this node.]]
	property "Prefix" {}

	__Doc__[[Gets the node immediately preceding this node.]]
	property "PreviousSibling" {}

	__Doc__[[Gets the post schema validation infoset that has been assigned to this node as a result of schema validation.]]
	property "SchemaInfo" {}

	__Doc__[[Gets or sets the value of the node.]]
	property "Value" {}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function XmlNode(self, ...)

    end
endclass "XmlNode"

__Doc__[[Represents the text content of an element or attribute.]]
class "XmlText"
	inherit "XmlNode"

	------------------------------------------------------
	-- Event
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function XmlText(self, ...)

    end
endclass "XmlText"

__Doc__[[Represents an XML document.]]
class "XmlDocument"
	inherit "XmlNode"

	------------------------------------------------------
	-- Event
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	__Doc__[[Gets the root XmlElement for the document.]]
	property "DocumentElement" {}

	__Doc__[[Gets the node containing the DOCTYPE declaration.]]
	property "DocumentType" {}

	__Doc__[[Gets the XmlImplementation object for the current document.]]
	property "Implementation" {}

	__Doc__[[Gets the XmlNameTable associated with this implementation.]]
	property "NameTable" {}

	__Doc__[[Gets or sets a value indicating whether to preserve white space in element content.]]
	property "PreserveWhitespace" {}

	__Doc__[[Gets or sets the XmlSchemaSet object associated with this XmlDocument.]]
	property "Schemas" {}

	__Doc__[[Sets the XmlResolver to use for resolving external resources.]]
	property "XmlResolver" {}


	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function XmlDocument(self, ...)

    end
endclass "XmlDocument"