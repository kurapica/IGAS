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
	newIndex = function(reset) _M.AutoIndex = reset or ((_M.AutoIndex or 0) + 1); return _M.AutoIndex end

	_Token = {
		NAME_START	= newIndex(),
		NAME_CHAR	= newIndex(),
		NAME		= newIndex(),
		NAMES		= newIndex(),
		NAME_TOKEN	= newIndex(),
		NAME_TOKENS	= newIndex(),

		TAG_START	= newIndex(),
		TAG_END		= newIndex(),


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
		[_Bytes.SPACE] = _Token.SPACE,
		[_Bytes.TAB] = _Token.TAB,

		[_Bytes.LF] = _Token.LF,
		[_Bytes.CR] = _Token.CR,

		[_Bytes.EXCLAMATION] = _Token.EXCLAMATION,
		[_Bytes.DOUBLE_QUOTE] = _Token.DOUBLE_QUOTE,
		[_Bytes.NUMBER_SIGN] = _Token.NUMBER_SIGN,
		[_Bytes.DOLLAR_SIGN] = _Token.DOLLAR_SIGN,
		[_Bytes.PERCENT] = _Token.PERCENT,
		[_Bytes.AMP] = _Token.AMP,
		[_Bytes.SINGLE_QUOTE] = _Token.SINGLE_QUOTE,
		[_Bytes.LEFTPAREN] = _Token.LEFTPAREN,
		[_Bytes.RIGHTPAREN] = _Token.RIGHTPAREN,
		[_Bytes.ASTERISK] = _Token.ASTERISK,
		[_Bytes.PLUS] = _Token.PLUS,
		[_Bytes.COMMA] = _Token.COMMA,
		[_Bytes.MINUS] = _Token.MINUS,
		[_Bytes.PERIOD] = _Token.PERIOD,
		[_Bytes.SLASH] = _Token.SLASH,
		[_Bytes.COLON] = _Token.COLON,
		[_Bytes.SEMICOLON] = _Token.SEMICOLON,
		[_Bytes.LESSTHAN] = _Token.LESSTHAN,
		[_Bytes.EQUALS] = _Token.EQUALS,
		[_Bytes.GREATERTHAN] = _Token.GREATERTHAN,
		[_Bytes.QUESTION] = _Token.QUESTION,
		[_Bytes.AT_SIGN] = _Token.AT_SIGN,
		[_Bytes.LEFTBRACKET] = _Token.LEFTBRACKET,
		[_Bytes.BACKSLASH] = _Token.BACKSLASH,
		[_Bytes.RIGHTBRACKET] = _Token.RIGHTBRACKET,
		[_Bytes.CARET] = _Token.CARET,
		[_Bytes.UNDERLINE] = _Token.UNDERLINE,
		[_Bytes.GRAVE_ACCENT] = _Token.GRAVE_ACCENT,
		[_Bytes.LEFTWING] = _Token.LEFTWING,
		[_Bytes.VERTICAL] = _Token.VERTICAL,
		[_Bytes.RIGHTWING] = _Token.RIGHTWING,
		[_Bytes.TILDE] = _Token.TILDE,
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

				return byte, len
			end,
		},
		["UTF-16"] = {
			BigEndian = function (str, startp)
				local obyte, sbyte = strbyte(str, startp, startp + 1)

				if obyte <= 0xD7 then
					-- two bytes
					return obyte * 256 + sbyte, 2
				elseif obyte >= 0xD8 and obyte <= 0xDB then
					-- four byte
					local tbyte, fbyte = strbyte(str, startp + 2, startp + 3)
					if tbyte >= 0xDC and tbyte <= 0xDF then
						return ((obyte - 0xD8) * 256 + sbyte) * 1024 + ((tbyte - 0xDC) * 256 + fbyte) + 0x10000, 4
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
					return obyte * 256 + sbyte, 2
				elseif obyte >= 0xD8 and obyte <= 0xDB then
					-- four byte
					local fbyte, tbyte = strbyte(str, startp + 2, startp + 3)
					if tbyte >= 0xDC and tbyte <= 0xDF then
						return ((obyte - 0xD8) * 256 + sbyte) * 1024 + ((tbyte - 0xDC) * 256 + fbyte) + 0x10000, 4
					else
						return false
					end
				else
					return false
				end
			end
		},
	}

	_WhiteSpace = {
		Single = {
			[_Byte.SPACE] = true,
			[_Byte.TAB] = true,
			[_Byte.CR] = true,
			[_Byte.LF] = true,
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
	},

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

	function loadFile(data, fileEncode, isBigEndian)
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
		local char, len = 0, 0
		local line, lineStart = 0, 0
		local stackToken, stackName = {}, {}
		local stackLen = 0
		local cdata = false

		while pos <= endp do
			pos = pos + len
			char, len = getChar(data, pos)

			if not char or not isChar(char, _ValidChar) then
				error("Not a valid char at line " .. line .. " column " .. (pos - lineStart), 2)
			end

			if _Special[char] then
				if isChar(char, _WhiteSpace) then

				else
					tinsert(stackToken, _Special[char])
					stackLen = stackLen + 1
				end
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