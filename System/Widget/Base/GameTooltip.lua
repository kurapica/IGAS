-- Author      : Kurapica
-- Create Date : 7/16/2008 11:55
-- Change Log  :
--				2011/03/13	Recode as class
--				2011/06/01	Fix name conflict

-- Check Version
local version = 8
if not IGAS:NewAddon("IGAS.Widget.GameTooltip", version) then
	return
end

class "GameTooltip"
	inherit "Frame"

	doc [======[
		@name GameTooltip
		@type class
		@desc GameTooltips are used to display explanatory information relevant to a particular element of the game world.
	]======]

	COPPER_PER_SILVER = COPPER_PER_SILVER
	SILVER_PER_GOLD = SILVER_PER_GOLD

	------------------------------------------------------
	-- Event
	------------------------------------------------------
	doc [======[
		@name OnTooltipAddMoney
		@type event
		@desc Run when an amount of money should be added to the tooltip
		@param amount number, amount of money to be added to the tooltip (in copper)
		@param maxAmount number, a second amount of money to be added to the tooltip (in copper); if non-nil, the first amount is treated as the minimum and this amount as the maximum of a price range
	]======]
	event "OnTooltipAddMoney"

	doc [======[
		@name OnTooltipCleared
		@type event
		@desc Run when the tooltip is hidden or its content is cleared
	]======]
	event "OnTooltipCleared"

	doc [======[
		@name OnTooltipSetAchievement
		@type event
		@desc Run when the tooltip is filled with information about an achievement
	]======]
	event "OnTooltipSetAchievement"

	doc [======[
		@name OnTooltipSetDefaultAnchor
		@type event
		@desc Run when the tooltip is repositioned to its default anchor location
	]======]
	event "OnTooltipSetDefaultAnchor"

	doc [======[
		@name OnTooltipSetEquipmentSet
		@type event
		@desc Run when the tooltip is filled with information about an equipment set
	]======]
	event "OnTooltipSetEquipmentSet"

	doc [======[
		@name OnTooltipSetFrameStack
		@type event
		@desc Run when the tooltip is filled with a list of frames under the mouse cursor
	]======]
	event "OnTooltipSetFrameStack"

	doc [======[
		@name OnTooltipSetItem
		@type event
		@desc Run when the tooltip is filled with information about an item
	]======]
	event "OnTooltipSetItem"

	doc [======[
		@name OnTooltipSetQuest
		@type event
		@desc Run when the tooltip is filled with information about a quest
	]======]
	event "OnTooltipSetQuest"

	doc [======[
		@name OnTooltipSetSpell
		@type event
		@desc Run when the tooltip is filled with information about a spell
	]======]
	event "OnTooltipSetSpell"

	doc [======[
		@name OnTooltipSetUnit
		@type event
		@desc Run when the tooltip is filled with information about a unit
	]======]
	event "OnTooltipSetUnit"

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		local name = self:GetName()
		local index, chkName

		self:ClearLines()

		if name and _G[name] and IGAS:GetWrapper(_G[name]) == self then
			-- remove lefttext
			index = 1

			while _G[name.."TextLeft"..index] do
				_G[name.."TextLeft"..index] = nil
				index = index + 1
			end

			-- remove righttext
			index = 1

			while _G[name.."TextRight"..index] do
				_G[name.."TextRight"..index] = nil
				index = index + 1
			end

			-- remove texture
			index = 1

			while _G[name.."Texture"..index] do
				_G[name.."Texture"..index] = nil
				index = index + 1
			end

			-- remove self
			_G[name] = nil
		end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Constructor(self, name, parent, ...)
		local fullname = (parent:GetName() or "").."."..name

		return CreateFrame("GameTooltip", fullname, parent, ...)
	end
endclass "GameTooltip"

class "GameTooltip"
	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name AddDoubleLine
		@type method
		@desc Adds a line to the tooltip with both left-side and right-side portions. The tooltip is not automatically resized to fit the added line; to do so, call the tooltip's :Show() method after adding lines.
		@param textLeft string, text to be displayed on the left side of the new line
		@param textRight string, text to be displayed on the right side of the new line
		@param rL number, red component of the color for the left-side text (0.0 - 1.0)
		@param gL number, green component of the color for the left-side text (0.0 - 1.0)
		@param bL number, blue component of the color for the left-side text (0.0 - 1.0)
		@param rR number, red component of the color for the right-side text (0.0 - 1.0)
		@param gR number, green component of the color for the right-side text (0.0 - 1.0)
		@param bR number, blue component of the color for the right-side text (0.0 - 1.0)
		@return nil
	]======]

	doc [======[
		@name AddFontStrings
		@type method
		@desc  Adds FontString objects to the tooltip, allowing it to display an additional line of text. This method is of little utility outside of Blizzard scripts, as the tooltip automatically creates new font strings for additional lines as needed.
		@param left System.Widget.FontString, reference to a FontString object for the left-side text of a new line
		@param right System.Widget.FontString, reference to a FontString object for the right-side text of a new line
		@return nil
	]======]

	doc [======[
		@name AddLine
		@type method
		@desc Adds a line of text to the tooltip. The tooltip is not automatically resized to fit the added line (and wrap it, if applicable); to do so, call the tooltip's :Show() method after adding lines.
		@param text string, text to be added as a new line in the tooltip
		@param r number, red component of the text color (0.0 - 1.0)
		@param g number, green component of the text color (0.0 - 1.0)
		@param b number, blue component of the text color (0.0 - 1.0)
		@param wrap boolean, true to cause the line to wrap if it is longer than other, non-wrapping lines in the tooltip or longer than the tooltip's forced width
		@return nil
	]======]

	doc [======[
		@name AddSpellByID
		@type method
		@desc
		@param spellId number
		@return nil
	]======]

	doc [======[
		@name AddTexture
		@type method
		@desc Adds a texture to the last tooltip line. The texture is sized to match the height of the line's text and positioned to the left of the text (indenting the text to provide room).
		@param texture string, path to a texture image file
		@return nil
	]======]

	doc [======[
		@name AppendText
		@type method
		@desc Adds text to the first line of the tooltip
		@param text string, text to be appended to the tooltip's first line
		@return nil
	]======]

	doc [======[
		@name ClearLines
		@type method
		@desc Clears the tooltip's contents. Scripts scanning the tooltip contents should be aware that this method clears the text of all the tooltip's left-side font strings but hides the right-side font strings without clearing their text.
		@return nil
	]======]

	doc [======[
		@name FadeOut
		@type method
		@desc Causes the tooltip to begin fading out
		@return nil
	]======]

	doc [======[
		@name GetAnchorType
		@type method
		@desc Returns the method for anchoring the tooltip relative to its owner
		@return System.Widget.AnchorType
	]======]

	doc [======[
		@name GetItem
		@type method
		@desc Returns the name and hyperlink for the item displayed in the tooltip
		@return name string, name of the item whose information is displayed in the tooltip, or nil.
		@return link string, a hyperlink for the item
	]======]

	doc [======[
		@name GetMinimumWidth
		@type method
		@desc Returns the minimum width of the tooltip
		@return number Minimum width of the tooltip frame (in pixels)
	]======]

	doc [======[
		@name GetOwner
		@type method
		@desc Returns the frame to which the tooltip refers and is anchored
		@return System.Widget.Region Reference to the Frame object to which the tooltip is anchored
	]======]
	function GetOwner(self, ...)
		return IGAS:GetWrapper(self.__UI:GetOwner(...))
	end

	doc [======[
		@name GetPadding
		@type method
		@desc Returns the amount of space between tooltip's text and its right-side edge
		@return padding number, amount of space between the right-side edge of the tooltip's text and the right-side edge of the tooltip frame (in pixels)
	]======]

	doc [======[
		@name GetSpell
		@type method
		@desc Returns information about the spell displayed in the tooltip
		@return spellName string, name of the spell, or nil if the information in the tooltip is not for a spell
		@return spellRank string, secondary text associated with the spell name (often a rank, e.g. "Rank 8")
		@return spellID number, numeric identifier for the spell and rank
	]======]

	doc [======[
		@name GetUnit
		@type method
		@desc Returns information about the unit displayed in the tooltip
		@return name string, name of the unit displayed in the tooltip, or nil
		@return unit string, unit identifier of the unit, or nil if the unit cannot be referenced by a unitID
	]======]

	doc [======[
		@name IsEquippedItem
		@type method
		@desc Returns whether the tooltip is displaying an item currently equipped by the player
		@return boolean 1 if the tooltip is displaying information about an item currently equipped by the player; otherwise nil
	]======]

	doc [======[
		@name IsOwned
		@type method
		@desc Returns whether the tooltip has an owner frame
		@return boolean 1 if the tooltip has an owner frame; otherwise nil
	]======]

	doc [======[
		@name IsUnit
		@type method
		@desc Returns whether the tooltip is displaying information for a given unit
		@return boolean 1 if the tooltip is displaying information for the unit; otherwise nil
	]======]

	doc [======[
		@name NumLines
		@type method
		@desc Returns the number of lines of text currently shown in the tooltip
		@return number Number of lines currently shown in the tooltip
	]======]

	doc [======[
		@name SetAction
		@type method
		@desc Fills the tooltip with information about the contents of an action slot
		@param slot number, an action bar slot
		@return nil
	]======]

	doc [======[
		@name SetAnchorType
		@type method
		@desc Sets the method for anchoring the tooltip relative to its owner
		@param anchor System.Widget.AnchorType
		@return nil
	]======]

	doc [======[
		@name SetAuctionItem
		@type method
		@desc Fills the tooltip with information about an item in the auction house
		@param list string, type of auction listing: bidder|list|owner
		@param index number, index of an auction in the listing
		@return nil
	]======]

	doc [======[
		@name function_name
		@type method
		@desc Fills the tooltip with information about the item currently being set up for auction. Return values 2 and higher are only available if the item to be auctioned is actually a battle pet.
		@return hasCooldown boolean, 1 or nil
		@return speciesID number, speciesID to identify a battle pet's species
		@return level number, the level of this battle pet
		@return breedQuality number, quality (rarity) level of the battle pet
		@return health number, maximum health of this battle pet
		@return power number, attack power of this battle pet
		@return speed number, attack speed of this battle pet
		@return petName string, the name of this battle pet.
	]======]

	doc [======[
		@name SetBackpackToken
		@type method
		@desc Fills the tooltip with information about a currency marked for watching on the Backpack UI
		@param index number, index of a 'slot' for displaying currencies on the backpack (between 1 and MAX_WATCHED_TOKENS)
		@return nil
	]======]

	doc [======[
		@name SetBagItem
		@type method
		@desc Fills the tooltip with information about an item in the player's bags
		@param container number, index of one of the player's bags or other containers
		@param slot number, index of an item slot within the container
		@return hasCooldown boolean, 1 if the item is currently on cooldown, otherwise nil
		@return repairCost number, cost of repairing the item (in copper, ignoring faction discounts)
	]======]

	doc [======[
		@name SetBuybackItem
		@type method
		@desc Fills the tooltip with information about item recently sold to a vendor and available to be repurchased
		@param index number, ndex of an item in the buyback listing (between 1 and GetNumBuybackItems())
		@return nil
	]======]

	doc [======[
		@name SetCurrencyByID
		@type method
		@desc Fills the tooltip with information about a specified currency
		@param currencyID number, a currencyID. All currently known currencyIDs
		@return nil
	]======]

	doc [======[
		@name SetCurrencyToken
		@type method
		@desc Fills the tooltip with information about a special currency type. Note that passing the index of a header will crash the client.
		@param index number, index of a currency type in the currency list (between 1 and GetCurrencyListSize())
		@return nil
	]======]

	doc [======[
		@name SetEquipmentSet
		@type method
		@desc Fills the tooltip with information about an equipment set
		@param name string, name of the equipment set
		@return nil
	]======]

	doc [======[
		@name SetExistingSocketGem
		@type method
		@desc Fills the tooltip with information about a permanently socketed gem
		@param index number, index of a gem socket (between 1 and GetNumSockets())
		@param toDestroy boolean, true to alter the tooltip display to indicate that this gem will be destroyed by socketing a new gem; false to show the normal tooltip for the gem
		@return nil
	]======]

	doc [======[
		@name SetFrameStack
		@type method
		@desc Fills the tooltip with a list of frames under the mouse cursor. Not relevant outside of addon development and debugging.
		@param includeHidden boolean, true to include hidden frames in the list; false to list only visible frames
		@return nil
	]======]

	doc [======[
		@name SetGlyph
		@type method
		@desc Fills the tooltip with information about one of the player's glyphs
		@param socket number, which socket's glyph to display (between 1 and NUM_GLYPH_SLOTS)
		@param talentGroup number, which set of glyphs to display, if the player has Dual Talent Specialization enabled, 1 - Primary Talents, 2 - Secondary Talents, nil - Currently active talents
		@return nil
	]======]

	doc [======[
		@name SetGlyphByID
		@type method
		@desc
		@param id numbr
		@return nil
	]======]

	doc [======[
		@name SetGuildBankItem
		@type method
		@desc Fills the tooltip with information about an item in the guild bank. Information is only available if the guild bank tab has been opened in the current play session.
		@param tab number, index of a guild bank tab (between 1 and GetNumGuildBankTabs())
		@param slot number, index of an item slot in the guild bank tab (between 1 and MAX_GUILDBANK_SLOTS_PER_TAB)
		@return nil
	]======]

	doc [======[
		@name SetHyperlink
		@type method
		@desc Fills the tooltip with information about an item, quest, spell, or other entity represented by a hyperlink
		@param hyperlink string, a full hyperlink, or the linktype:linkdata portion thereof
		@return nil
	]======]

	doc [======[
		@name SetHyperlinkCompareItem
		@type method
		@desc Fills the tooltip with information about the item currently equipped in the slot used the supplied item
		@param hyperlink string, a full hyperlink, or the linktype:linkdata portion thereof, for an item to compare against the player's equipped similar item
		@param index number, index of the slot to compare against (1, 2, or 3), if more than one item of the equipment type can be equipped at once (e.g. rings and trinkets)
		@return boolean 1 if an item's information was loaded into the tooltip; otherwise nil
	]======]

	doc [======[
		@name SetInboxItem
		@type method
		@desc Fills the tooltip with information about an item attached to a message in the player's inbox
		@param mailID number, index of a message in the player's inbox (between 1 and GetInboxNumItems())
		@param attachmentIndex number, index of an attachment to the message (between 1 and select(8,GetInboxHeaderInfo(mailID)))
		@return nil
	]======]

	doc [======[
		@name SetInstanceLockEncountersComplete
		@type method
		@desc
		@param id number
		@return nil
	]======]

	doc [======[
		@name SetInventoryItem
		@type method
		@desc Fills the tooltip with information about an equipped item
		@param unit string, a unit to query; only valid for 'player' or the unit currently being inspected
		@param slot number, an inventory slot number, as can be obtained from GetInventorySlotInfo
		@param nameOnly boolean, true to omit much of the item's information (stat bonuses, sockets, and binding) from the tooltip; false to show all of the item's information
		@return hasItem boolean, 1 if the unit has an item in the given slot; otherwise nil
		@return hasCooldown boolean, 1 if the item is currently on cooldown; otherwise nil
		@return repairCost number, Cost to repair the item (in copper, ignoring faction discounts)
	]======]

	doc [======[
		@name SetInventoryItemByID
		@type method
		@desc
		@param id number
		@return nil
	]======]

	doc [======[
		@name SetLFGCompletionReward
		@type method
		@desc Fills the tooltip with the information about the LFG completion reward
		@param index number reward ID
		@return nil
	]======]

	doc [======[
		@name SetLFGDungeonReward
		@type method
		@desc Fills the tooltip with the information about the LFD completion reward
		@param index number reward ID
		@return nil
	]======]

	doc [======[
		@name SetLootCurrency
		@type method
		@desc Fills the tooltip with information about the loot currency
		@param slot number
		@return nil
	]======]

	doc [======[
		@name SetLootItem
		@type method
		@desc Fills the tooltip with information about an item available as loot
		@param slot number, index of a loot slot (between 1 and GetNumLootItems())
		@return nil
	]======]

	doc [======[
		@name SetLootRollItem
		@type method
		@desc Fills the tooltip with information about an item currently up for loot rolling
		@param id number, index of an item currently up for loot rolling (as provided in the START_LOOT_ROLL event)
		@return nil
	]======]

	doc [======[
		@name SetMerchantCostItem
		@type method
		@desc Fills the tooltip with information about an alternate currency required to purchase an item from a vendor. Only applies to item-based currencies, not honor or arena points.
		@param index number, index of an item in the vendor's listing (between 1 and GetMerchantNumItems()) (number)
		@param currency number, index of one of the item currencies required to purchase the item (between 1 and select(3,GetMerchantItemCostInfo(index))) (number)
		@return nil
	]======]

	doc [======[
		@name SetMerchantItem
		@type method
		@desc Fills the tooltip with information about an item available for purchase from a vendor
		@param merchantIndex number, the index of an item in the merchant window, between 1 and GetMerchantNumItems().
		@return nil
	]======]

	doc [======[
		@name SetMinimumWidth
		@type method
		@desc Sets the minimum width of the tooltip. Normally, a tooltip is automatically sized to match the width of its shortest line of text; setting a minimum width can be useful if the tooltip also contains non-text frames (such as an amount of money or a status bar)
		@param width number, minimum width of the tooltip frame (in pixels)
		@return nil
	]======]

	doc [======[
		@name SetOwner
		@type method
		@desc Sets the frame to which the tooltip refers and is anchored
		@format frame [, anchorType[, xOffset [, yOffset]]]
		@param frame System.Widget.Region, reference to the Frame to which the tooltip refers
		@param anchorType System.Widget.AnchorType, token identifying the positioning method for the tooltip relative to its owner frame
		@param xOffset number, the horizontal offset for the tooltip anchor
		@param yOffset number, the vertical offset for the tooltip anchor
		@return nil
	]======]

	doc [======[
		@name SetPadding
		@type method
		@desc Sets the amount of space between tooltip's text and its right-side edge. Used in the default UI's ItemRefTooltip to provide space for a close button.
		@param padding number, amount of space between the right-side edge of the tooltip's text and the right-side edge of the tooltip frame (in pixels)
		@return nil
	]======]

	doc [======[
		@name SetPetAction
		@type method
		@desc Fills the tooltip with information about a pet action. Only provides information for pet action slots containing pet spells -- in the default UI, the standard pet actions (attack, follow, passive, aggressive, etc) are special-cased to show specific tooltip text.
		@param index number, index of a pet action button (between 1 and NUM_PET_ACTION_SLOTS)
		@return nil
	]======]

	doc [======[
		@name SetPossession
		@type method
		@desc Fills the tooltip with information about one of the special actions available while the player possesses another unit
		@param index number, index of a possession bar action (between 1 and NUM_POSSESS_SLOTS)
		@return nil
	]======]

	doc [======[
		@name SetQuestCurrency
		@type method
		@desc
		@param type string
		@param id number
		@return nil
	]======]

	doc [======[
		@name SetQuestItem
		@type method
		@desc Fills the tooltip with information about an item in a questgiver dialog
		@param itemType string, token identifying one of the possible sets of items : choice|required|reward
		@param index number, index of an item in the set (between 1 and GetNumQuestChoices(), GetNumQuestItems(), or GetNumQuestRewards(), according to itemType)
		@return nil
	]======]

	doc [======[
		@name SetQuestLogCurrency
		@type method
		@desc
		@param type string
		@param id number
		@return nil
	]======]

	doc [======[
		@name SetQuestLogItem
		@type method
		@desc Fills the tooltip with information about an item related to the selected quest in the quest log
		@param itemType string, token identifying one of the possible sets of items : choice|reward
		@param index number, index of an item in the set (between 1 and GetNumQuestLogChoices() or GetNumQuestLogRewards(), according to itemType)
		@return nil
	]======]

	doc [======[
		@name function_name
		@type method
		@desc Fills the tooltip with information about the reward spell for the selected quest in the quest log
		@return nil
	]======]

	doc [======[
		@name SetQuestLogSpecialItem
		@type method
		@desc Fills the tooltip with information about a usable item associated with a current quest
		@param questIndex number, index of a quest log entry with an associated usable item (between 1 and GetNumQuestLogEntries())
		@return nil
	]======]

	doc [======[
		@name SetQuestRewardSpell
		@type method
		@desc Fills the tooltip with information about the spell reward in a questgiver dialog
		@return nil
	]======]

	doc [======[
		@name SetReforgeItem
		@type method
		@desc Fills the tooltip with information about the reforged item
		@return nil
	]======]

	doc [======[
		@name SetSendMailItem
		@type method
		@desc Fills the tooltip with information about an item attached to the outgoing mail message
		@param slot number, index of an outgoing attachment slot (between 1 and ATTACHMENTS_MAX_SEND)
		@return nil
	]======]

	doc [======[
		@name SetShapeshift
		@type method
		@desc Fills the tooltip with information about an ability on the stance/shapeshift bar
		@param index number, index of an ability on the stance/shapeshift bar (between 1 and GetNumShapeshiftForms())
		@return nil
	]======]

	doc [======[
		@name SetSocketedItem
		@type method
		@desc Fills the tooltip with information about the item currently being socketed
		@return nil
	]======]

	doc [======[
		@name SetSocketGem
		@type method
		@desc Fills the tooltip with information about a gem added to a socket
		@param index number, index of a gem socket (between 1 and GetNumSockets())
		@return nil
	]======]

	doc [======[
		@name SetSpellBookItem
		@type method
		@desc
		@param slot
		@param bookType
		@return nil
	]======]

	doc [======[
		@name SetSpellByID
		@type method
		@desc Fills the tooltip with information about a spell specified by ID
		@param id number, spell id
		@return nil
	]======]

	doc [======[
		@name SetTalent
		@type method
		@desc Fills the tooltip with information about a talent
		@param tabIndex number, index of a talent tab (between 1 and GetNumTalentTabs())
		@param talentIndex number, index of a talent option (between 1 and GetNumTalents())
		@param inspect boolean, true to return information for the currently inspected unit; false to return information for the player
		@param pet boolean, true to return information for the player's pet; false to return information for the player
		@param talentGroup number, Which set of talents to edit, if the player has Dual Talent Specialization enabled: 1 - Primary Talents, 2 - Secondary Talents, nil - Currently active talents
		@return nil
	]======]

	doc [======[
		@name SetText
		@type method
		@desc Sets the tooltip's text. Any other content currently displayed in the tooltip will be removed or hidden, and the tooltip's size will be adjusted to fit the new text.
		@format text[, r, g, b[, a]]
		@param text string, text to be displayed in the tooltip
		@param r number, red component of the text color (0.0 - 1.0)
		@param g number, green component of the text color (0.0 - 1.0)
		@param b number, blue component of the text color (0.0 - 1.0)
		@param a number, alpha (opacity) for the text (0.0 = fully transparent, 1.0 = fully opaque)
		@return nil
	]======]

	doc [======[
		@name SetTotem
		@type method
		@desc Fills the tooltip with information about one of the player's active totems.
		@param slot number, which totem to query
		@return nil
	]======]

	doc [======[
		@name SetTradePlayerItem
		@type method
		@desc Fills the tooltip with information about an item offered for trade by the player.
		@param index number, index of an item offered for trade by the player (between 1 and MAX_TRADE_ITEMS)
		@return nil
	]======]

	doc [======[
		@name SetTradeSkillItem
		@type method
		@desc Fills the tooltip with information about an item created by a trade skill recipe or a reagent in the recipe
		@param skillIndex number, index of a recipe in the trade skill list (between 1 and GetNumTradeSkills())
		@param reagentIndex number, index of a reagent in the recipe (between 1 and GetTradeSkillNumReagents()); if omitted, displays a tooltip for the item created by the recipe
		@return nil
	]======]

	doc [======[
		@name SetTradeTargetItem
		@type method
		@desc Fills the tooltip with information about an item offered for trade by the target. See :SetTradePlayerItem() for items to be traded away by the player.
		@param index number, index of an item offered for trade by the target (between 1 and MAX_TRADE_ITEMS)
		@return nil
	]======]

	doc [======[
		@name SetTrainerService
		@type method
		@desc Fills the tooltip with information about a trainer service
		@param index number, index of an entry in the trainer service listing (between 1 and GetNumTrainerServices())
		@return nil
	]======]

	doc [======[
		@name SetUnit
		@type method
		@desc Fills the tooltip with information about a unit
		@param unit string, a unit to query
		@return nil
	]======]

	doc [======[
		@name SetUnitAura
		@type method
		@desc Fills the tooltip with information about a buff or debuff on a unit
		@param unit string, a unit to query
		@param index number, index of a buff or debuff on the unit
		@param filter string, a list of filters to use when resolving the index, separated by the pipe '|' character; e.g. "RAID|PLAYER" will query group buffs cast by the player
		@return nil
	]======]

	doc [======[
		@name SetUnitBuff
		@type method
		@desc Fills the tooltip with information about a buff on a unit.
		@param unit string, a unit to query
		@param index number, index of a buff or debuff on the unit
		@param filter string, a list of filters to use when resolving the index, separated by the pipe '|' character; e.g. "RAID|PLAYER" will query group buffs cast by the player
		@return nil
	]======]

	doc [======[
		@name SetUnitDebuff
		@type method
		@desc Fills the tooltip with information about a debuff on a unit.
		@param unit string, a unit to query
		@param index number, index of a buff or debuff on the unit
		@param filter string, a list of filters to use when resolving the index, separated by the pipe '|' character; e.g. "CANCELABLE|PLAYER" will query cancelable debuffs cast by the player
		@return nil
	]======]

	doc [======[
		@name GetLeftText
		@type method
		@desc Get the left text of the given index line
		@param index number, between 1 and self:NumLines()
		@return string
	]======]
	function GetLeftText(self, index)
		local name = self:GetName()

		if not name or not index or type(index) ~= "number" then
			return
		end

		name = name.."TextLeft"..index

		if _G[name] and type(_G[name]) == "table" and _G[name].GetText then
			return _G[name]:GetText()
		end
	end

	doc [======[
		@name GetRightText
		@type method
		@desc Get the right text of the given index line
		@param index number, between 1 and self:NumLines()
		@return string
	]======]
	function GetRightText(self, index)
		local name = self:GetName()

		if not name or not index or type(index) ~= "number" then
			return
		end

		name = name.."TextRight"..index

		if _G[name] and type(_G[name]) == "table" and _G[name].GetText then
			return _G[name]:GetText()
		end
	end

	doc [======[
		@name GetTexture
		@type method
		@desc Get the texutre of the given index line
		@param index number, between 1 and self:NumLines()
		@return string
	]======]
	function GetTexture(self, index)
		local name = self:GetName()

		if not name or not index or type(index) ~= "number" then
			return
		end

		name = name.."Texture"..index

		if _G[name] and type(_G[name]) == "table" and _G[name].GetTexture then
			return _G[name]:GetTexture()
		end
	end

	doc [======[
		@name GetMoney
		@type method
		@desc Get the money of the given index, default 1
		@param index number, between 1 and self:NumLines()
		@return number
	]======]
	function GetMoney(self, index)
		local name = self:GetName()

		index = index or 1

		if not name or not index or type(index) ~= "number" then
			return
		end

		name = name.."MoneyFrame"..index

		if _G[name] and type(_G[name]) == "table" then
			local gold = strmatch((_G[name.."GoldButton"] and _G[name.."GoldButton"]:GetText()) or "0", "%d*") or 0
			local silver = strmatch((_G[name.."SilverButton"] and _G[name.."SilverButton"]:GetText()) or "0", "%d*") or 0
			local copper = strmatch((_G[name.."CopperButton"] and _G[name.."CopperButton"]:GetText()) or "0", "%d*") or 0

			return gold * COPPER_PER_SILVER * SILVER_PER_GOLD + silver * COPPER_PER_SILVER + copper
		end
	end

	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(GameTooltip)

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name Owner
		@type property
		@desc The owner of this gametooltip
	]======]
	property "Owner" { Type = UIObject + nil }

endclass "GameTooltip"