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
	_Token = {
	}

	_Byte = {
		AMP = "&",
		COLON = strbyte(":"),
		LESSTHAN = strbyte("<"),
		GREATERTHAN = strbyte(">"),
		SLASH = strbyte("/"),
		SINGLE_QUOTE = strbyte("'"),
		DOUBLE_QUOTE = strbyte('"'),

		SPACE = strbyte(" "),
		TAB = strbyte("\t"),

		LINEBREAK_N = strbyte("\n"),
		LINEBREAK_R = strbyte("\r"),
	}

	_Special = {
		[_Byte.COLON] = true,
		[_Byte.LESSTHAN] = true,
		[_Byte.GREATERTHAN] = true,
		[_Byte.SLASH] = true,
		[_Byte.SINGLE_QUOTE] = true,
		[_Byte.DOUBLE_QUOTE] = true,
		[_Byte.SPACE] = true,
		[_Byte.TAB] = true,
		[_Byte.LINEBREAK_R] = true,
		[_Byte.LINEBREAK_N] = true,
	}

	function parseXmlElements(data, startp)
		startp = startp or 1
		endp = endp or #data

		local pos = startp
		local byte = strbyte(data, pos)

		if byte ~= LESSTHAN then
			-- means text node
			while byte do
				if byte == LESSTHAN then
					return XmlText(data:sub(startp, pos - 1)), pos
				elseif byte == GREATERTHAN then
					error("Not a validated xml.")
				end

				pos = pos + 1
				byte = strbyte(data, pos)
			end

			return XmlText(data:sub(startp, pos - 1)), pos
		else
			-- means xml element
			startp = pos + 1
			pos = startp
			byte = strbyte(data, pos)

			-- match tag name
			while byte do
				if _Special[byte] then break end

				pos = pos + 1
				byte = strbyte(data, pos)
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