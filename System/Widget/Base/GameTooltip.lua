-- Author      : Kurapica
-- Create Date : 7/16/2008 11:55
-- Change Log  :
--				2011/03/13	Recode as class
--				2011/06/01	Fix name conflict

----------------------------------------------------------------------------------------------------------------------------------------
--- GameTooltips are used to display explanatory information relevant to a particular element of the game world.
-- <br><br>inherit <a href=".\Frame.html">Frame</a> For all methods, properties and scriptTypes
-- @name GameTooltip
-- @class table
-- @field Owner The owner of this gametooltip
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 8
if not IGAS:NewAddon("IGAS.Widget.GameTooltip", version) then
	return
end

class "GameTooltip"
	inherit "Frame"

	COPPER_PER_SILVER = COPPER_PER_SILVER
	SILVER_PER_GOLD = SILVER_PER_GOLD

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	------------------------------------
	--- ScriptType, Run when an amount of money should be added to the tooltip
	-- @name GameTooltip:OnTooltipAddMoney
	-- @class function
	-- @param amount Amount of money to be added to the tooltip (in copper)
	-- @param maxAmount A second amount of money to be added to the tooltip (in copper); if non-nil, the first amount is treated as the minimum and this amount as the maximum of a price range
	-- @usage function GameTooltip:OnTooltipAddMoney(amount, maxAmount)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnTooltipAddMoney"

	------------------------------------
	--- ScriptType, Run when the tooltip is hidden or its content is cleared
	-- @name GameTooltip:OnTooltipCleared
	-- @class function
	-- @usage function GameTooltip:OnTooltipCleared()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnTooltipCleared"

	------------------------------------
	--- ScriptType, Run when the tooltip is filled with information about an achievement
	-- @name GameTooltip:OnTooltipSetAchievement
	-- @class function
	-- @usage function GameTooltip:OnTooltipSetAchievement()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnTooltipSetAchievement"

	------------------------------------
	--- ScriptType, Run when the tooltip is repositioned to its default anchor location
	-- @name GameTooltip:OnTooltipSetDefaultAnchor
	-- @class function
	-- @usage function GameTooltip:OnTooltipSetDefaultAnchor()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnTooltipSetDefaultAnchor"

	------------------------------------
	--- ScriptType, Run when the tooltip is filled with information about an equipment set
	-- @name GameTooltip:OnTooltipSetEquipmentSet
	-- @class function
	-- @usage function GameTooltip:OnTooltipSetEquipmentSet()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnTooltipSetEquipmentSet"

	------------------------------------
	--- ScriptType, Run when the tooltip is filled with a list of frames under the mouse cursor
	-- @name GameTooltip:OnTooltipSetFrameStack
	-- @class function
	-- @usage function GameTooltip:OnTooltipSetFrameStack()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnTooltipSetFrameStack"

	------------------------------------
	--- ScriptType, Run when the tooltip is filled with information about an item
	-- @name GameTooltip:OnTooltipSetItem
	-- @class function
	-- @usage function GameTooltip:OnTooltipSetItem()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnTooltipSetItem"

	------------------------------------
	--- ScriptType, Run when the tooltip is filled with information about a quest
	-- @name GameTooltip:OnTooltipSetQuest
	-- @class function
	-- @usage function GameTooltip:OnTooltipSetQuest()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnTooltipSetQuest"

	------------------------------------
	--- ScriptType, Run when the tooltip is filled with information about a spell
	-- @name GameTooltip:OnTooltipSetSpell
	-- @class function
	-- @usage function GameTooltip:OnTooltipSetSpell()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnTooltipSetSpell"

	------------------------------------
	--- ScriptType, Run when the tooltip is filled with information about a unit
	-- @name GameTooltip:OnTooltipSetUnit
	-- @class function
	-- @usage function GameTooltip:OnTooltipSetUnit()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnTooltipSetUnit"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	-- Dispose, release resource
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

	------------------------------------
	--- Adds a line to the tooltip with both left-side and right-side portions. The tooltip is not automatically resized to fit the added line; to do so, call the tooltip's :Show() method after adding lines.
	-- @name GameTooltip:AddDoubleLine
	-- @class function
	-- @param textLeft Text to be displayed on the left side of the new line (string)
	-- @param textRight Text to be displayed on the right side of the new line (string)
	-- @param rL Red component of the color for the left-side text (0.0 - 1.0) (number)
	-- @param gL Green component of the color for the left-side text (0.0 - 1.0) (number)
	-- @param bL Blue component of the color for the left-side text (0.0 - 1.0) (number)
	-- @param rR Red component of the color for the right-side text (0.0 - 1.0) (number)
	-- @param gR Green component of the color for the right-side text (0.0 - 1.0) (number)
	-- @param bR Blue component of the color for the right-side text (0.0 - 1.0) (number)
	------------------------------------
	-- AddDoubleLine

	------------------------------------
	--- Adds FontString objects to the tooltip, allowing it to display an additional line of text. This method is of little utility outside of Blizzard scripts, as the tooltip automatically creates new font strings for additional lines as needed.
	-- @name GameTooltip:AddFontStrings
	-- @class function
	-- @param left Reference to a FontString object for the left-side text of a new line (fontstring)
	-- @param right Reference to a FontString object for the right-side text of a new line (fontstring)
	------------------------------------
	-- AddFontStrings

	------------------------------------
	--- Adds a line of text to the tooltip. The tooltip is not automatically resized to fit the added line (and wrap it, if applicable); to do so, call the tooltip's :Show() method after adding lines.
	-- @name GameTooltip:AddLine
	-- @class function
	-- @param text Text to be added as a new line in the tooltip (string)
	-- @param r Red component of the text color (0.0 - 1.0) (number)
	-- @param g Green component of the text color (0.0 - 1.0) (number)
	-- @param b Blue component of the text color (0.0 - 1.0) (number)
	-- @param wrap True to cause the line to wrap if it is longer than other, non-wrapping lines in the tooltip or longer than the tooltip's forced width (boolean)
	------------------------------------
	-- AddLine

	------------------------------------
	---
	-- @name GameTooltip:AddSpellByID
	-- @class function
	------------------------------------
	-- AddSpellByID

	------------------------------------
	--- Adds a texture to the last tooltip line. The texture is sized to match the height of the line's text and positioned to the left of the text (indenting the text to provide room).
	-- @name GameTooltip:AddTexture
	-- @class function
	-- @param texture Path to a texture image file (string)
	------------------------------------
	-- AddTexture

	------------------------------------
	--- Adds text to the first line of the tooltip
	-- @name GameTooltip:AppendText
	-- @class function
	-- @param text Text to be appended to the tooltip's first line (string)
	------------------------------------
	-- AppendText

	------------------------------------
	--- Clears the tooltip's contents. Scripts scanning the tooltip contents should be aware that this method clears the text of all the tooltip's left-side font strings but hides the right-side font strings without clearing their text.
	-- @name GameTooltip:ClearLines
	-- @class function
	------------------------------------
	-- ClearLines

	------------------------------------
	--- Causes the tooltip to begin fading out
	-- @name GameTooltip:FadeOut
	-- @class function
	------------------------------------
	-- FadeOut

	------------------------------------
	--- Returns the method for anchoring the tooltip relative to its owner
	-- @name GameTooltip:GetAnchorType
	-- @class function
	-- @return anchor - Token identifying the method for anchoring the tooltip relative to its owner frame (string) <ul><li>ANCHOR_BOTTOMLEFT - Align the top right of the tooltip with the bottom left of the owner
	-- @return ANCHOR_CURSOR - Toolip follows the mouse cursor
	-- @return ANCHOR_LEFT - Align the bottom right of the tooltip with the top left of the owner
	-- @return ANCHOR_NONE - Tooltip appears in the default position
	-- @return ANCHOR_PRESERVE - Tooltip's position is saved between sessions (useful if the tooltip is made user-movable)
	-- @return ANCHOR_RIGHT - Align the bottom left of the tooltip with the top right of the owner
	-- @return ANCHOR_TOPLEFT - Align the bottom left of the tooltip with the top left of the owner
	-- @return ANCHOR_TOPRIGHT - Align the bottom right of the tooltip with the top right of the owner
	------------------------------------
	-- GetAnchorType

	------------------------------------
	--- Returns the name and hyperlink for the item displayed in the tooltip
	-- @name GameTooltip:GetItem
	-- @class function
	-- @return name - Name of the item whose information is displayed in the tooltip, or nil. (string)
	-- @return link - A hyperlink for the item (string, hyperlink)
	------------------------------------
	-- GetItem

	------------------------------------
	--- Returns the minimum width of the tooltip
	-- @name GameTooltip:GetMinimumWidth
	-- @class function
	-- @return width - Minimum width of the tooltip frame (in pixels) (number)
	------------------------------------
	-- GetMinimumWidth

	------------------------------------
	--- Returns the frame to which the tooltip refers and is anchored
	-- @name GameTooltip:GetOwner
	-- @class function
	-- @return owner - Reference to the Frame object to which the tooltip is anchored (frame)
	------------------------------------
	function GetOwner(self, ...)
		return IGAS:GetWrapper(self.__UI:GetOwner(...))
	end

	------------------------------------
	--- Returns the amount of space between tooltip's text and its right-side edge
	-- @name GameTooltip:GetPadding
	-- @class function
	-- @return padding - Amount of space between the right-side edge of the tooltip's text and the right-side edge of the tooltip frame (in pixels) (number)
	------------------------------------
	-- GetPadding

	------------------------------------
	--- Returns information about the spell displayed in the tooltip
	-- @name GameTooltip:GetSpell
	-- @class function
	-- @return spellName - Name of the spell, or nil if the information in the tooltip is not for a spell. (string)
	-- @return spellRank - Secondary text associated with the spell name (often a rank, e.g. "Rank 8") (string)
	-- @return spellID - Numeric identifier for the spell and rank (number, spellID)
	------------------------------------
	-- GetSpell

	------------------------------------
	--- Returns information about the unit displayed in the tooltip
	-- @name GameTooltip:GetUnit
	-- @class function
	-- @return name - Name of the unit displayed in the tooltip, or nil (string)
	-- @return unit - Unit identifier of the unit, or nil if the unit cannot be referenced by a unitID (string, unitID)
	------------------------------------
	-- GetUnit

	------------------------------------
	--- Returns whether the tooltip is displaying an item currently equipped by the player
	-- @name GameTooltip:IsEquippedItem
	-- @class function
	-- @return enabled - 1 if the tooltip is displaying information about an item currently equipped by the player; otherwise nil (1nil)
	------------------------------------
	-- IsEquippedItem

	------------------------------------
	--- Returns whether the tooltip has an owner frame
	-- @name GameTooltip:IsOwned
	-- @class function
	-- @return hasOwner - 1 if the tooltip has an owner frame; otherwise nil (1nil)
	------------------------------------
	-- IsOwned

	------------------------------------
	--- Returns whether the tooltip is displaying information for a given unit
	-- @name GameTooltip:IsUnit
	-- @class function
	-- @param unit A unit to query (string, unitID)
	-- @return isUnit - 1 if the tooltip is displaying information for the unit; otherwise nil (1nil)
	------------------------------------
	-- IsUnit

	------------------------------------
	--- Returns the number of lines of text currently shown in the tooltip
	-- @name GameTooltip:NumLines
	-- @class function
	-- @return numLines - Number of lines currently shown in the tooltip (number)
	------------------------------------
	-- NumLines

	------------------------------------
	--- Fills the tooltip with information about the contents of an action slot
	-- @name GameTooltip:SetAction
	-- @class function
	-- @param slot An action bar slot (number, actionID)
	------------------------------------
	-- SetAction

	------------------------------------
	--- Sets the method for anchoring the tooltip relative to its owner
	-- @name GameTooltip:SetAnchorType
	-- @class function
	-- @param ANCHOR_CURSOR Toolip follows the mouse cursor
	-- @param ANCHOR_LEFT Align the bottom right of the tooltip with the top left of the owner
	-- @param ANCHOR_NONE Tooltip appears in the default position
	-- @param ANCHOR_PRESERVE Tooltip's position is saved between sessions (useful if the tooltip is made user-movable)
	-- @param ANCHOR_RIGHT Align the bottom left of the tooltip with the top right of the owner
	-- @param ANCHOR_TOPLEFT Align the bottom left of the tooltip with the top left of the owner
	-- @param ANCHOR_TOPRIGHT Align the bottom right of the tooltip with the top right of the owner
	------------------------------------
	-- SetAnchorType

	------------------------------------
	--- Fills the tooltip with information about an item in the auction house
	-- @name GameTooltip:SetAuctionItem
	-- @class function
	-- @param list Auctions the player can browse and bid on or buy out
	-- @param owner Auctions the player placed
	------------------------------------
	-- SetAuctionItem

	------------------------------------
	--- Fills the tooltip with information about the item currently being set up for auction
	-- @name GameTooltip:SetAuctionSellItem
	-- @class function
	------------------------------------
	-- SetAuctionSellItem

	------------------------------------
	--- Fills the tooltip with information about a currency marked for watching on the Backpack UI
	-- @name GameTooltip:SetBackpackToken
	-- @class function
	-- @param index Index of a 'slot' for displaying currencies on the backpack (between 1 and MAX_WATCHED_TOKENS) (number)
	------------------------------------
	-- SetBackpackToken

	------------------------------------
	--- Fills the tooltip with information about an item in the player's bags
	-- @name GameTooltip:SetBagItem
	-- @class function
	-- @param container Index of one of the player's bags or other containers (number, containerID)
	-- @param slot Index of an item slot within the container (number, containerSlotID)
	-- @return hasCooldown - 1 if the item is currently on cooldown, otherwise nil (number, 1nil)
	-- @return repairCost - Cost of repairing the item (in copper, ignoring faction discounts) (number)
	------------------------------------
	-- SetBagItem

	------------------------------------
	--- Fills the tooltip with information about item recently sold to a vendor and available to be repurchased
	-- @name GameTooltip:SetBuybackItem
	-- @class function
	-- @param index Index of an item in the buyback listing (between 1 and GetNumBuybackItems()) (number)
	------------------------------------
	-- SetBuybackItem

	------------------------------------
	---
	-- @name GameTooltip:SetCurrencyByID
	-- @class function
	------------------------------------
	-- SetCurrencyByID

	------------------------------------
	--- Fills the tooltip with information about a special currency type. Note that passing the index of a header will crash the client.
	-- @name GameTooltip:SetCurrencyToken
	-- @class function
	-- @param index Index of a currency type in the currency list (between 1 and GetCurrencyListSize()) (number)
	------------------------------------
	-- SetCurrencyToken

	------------------------------------
	--- Fills the tooltip with information about an equipment set
	-- @name GameTooltip:SetEquipmentSet
	-- @class function
	-- @param name Name of the equipment set (string)
	------------------------------------
	-- SetEquipmentSet

	------------------------------------
	--- Fills the tooltip with information about a permanently socketed gem
	-- @name GameTooltip:SetExistingSocketGem
	-- @class function
	-- @param index Index of a gem socket (between 1 and GetNumSockets()) (number)
	-- @param toDestroy True to alter the tooltip display to indicate that this gem will be destroyed by socketing a new gem; false to show the normal tooltip for the gem (boolean)
	------------------------------------
	-- SetExistingSocketGem

	------------------------------------
	--- Fills the tooltip with a list of frames under the mouse cursor. Not relevant outside of addon development and debugging.
	-- @name GameTooltip:SetFrameStack
	-- @class function
	-- @param includeHidden True to include hidden frames in the list; false to list only visible frames (boolean)
	------------------------------------
	-- SetFrameStack

	------------------------------------
	--- Fills the tooltip with information about one of the player's glyphs
	-- @name GameTooltip:SetGlyph
	-- @class function
	-- @param socket Which socket's glyph to display (between 1 and NUM_GLYPH_SLOTS) (number, glyphIndex)
	-- @param talentGroup Which set of glyphs to display, if the player has Dual Talent Specialization enabled (number) <ul><li>1 - Primary Talents
	-- @param 2 Secondary Talents
	-- @param nil Currently active talents
	------------------------------------
	-- SetGlyph

	------------------------------------
	---
	-- @name GameTooltip:SetGlyphByID
	-- @class function
	------------------------------------
	-- SetGlyphByID

	------------------------------------
	--- Fills the tooltip with information about an item in the guild bank. Information is only available if the guild bank tab has been opened in the current play session.
	-- @name GameTooltip:SetGuildBankItem
	-- @class function
	-- @param tab Index of a guild bank tab (between 1 and GetNumGuildBankTabs()) (number)
	-- @param slot Index of an item slot in the guild bank tab (between 1 and MAX_GUILDBANK_SLOTS_PER_TAB) (number)
	------------------------------------
	-- SetGuildBankItem

	------------------------------------
	--- Fills the tooltip with information about an item, quest, spell, or other entity represented by a hyperlink
	-- @name GameTooltip:SetHyperlink
	-- @class function
	-- @param hyperlink A full hyperlink, or the linktype:linkdata portion thereof (string, hyperlink)
	------------------------------------
	-- SetHyperlink

	------------------------------------
	--- Fills the tooltip with information about the item currently equipped in the slot used the supplied item
	-- @name GameTooltip:SetHyperlinkCompareItem
	-- @class function
	-- @param hyperlink A full hyperlink, or the linktype:linkdata portion thereof, for an item to compare against the player's equipped similar item (string, hyperlink)
	-- @param index Index of the slot to compare against (1, 2, or 3), if more than one item of the equipment type can be equipped at once (e.g. rings and trinkets) (number)
	-- @return success - 1 if an item's information was loaded into the tooltip; otherwise nil (number, 1nil)
	------------------------------------
	-- SetHyperlinkCompareItem

	------------------------------------
	--- Fills the tooltip with information about an item attached to a message in the player's inbox
	-- @name GameTooltip:SetInboxItem
	-- @class function
	-- @param mailID Index of a message in the player's inbox (between 1 and GetInboxNumItems()) (number)
	-- @param attachmentIndex Index of an attachment to the message (between 1 and select(8,GetInboxHeaderInfo(mailID))) (number)
	------------------------------------
	-- SetInboxItem

	------------------------------------
	---
	-- @name GameTooltip:SetInstanceLockEncountersComplete
	-- @class function
	------------------------------------
	-- SetInstanceLockEncountersComplete

	------------------------------------
	--- Fills the tooltip with information about an equipped item
	-- @name GameTooltip:SetInventoryItem
	-- @class function
	-- @param unit A unit to query; only valid for 'player' or the unit currently being inspected (string, unitID)
	-- @param slot An inventory slot number, as can be obtained from GetInventorySlotInfo (number, inventoryID)
	-- @param nameOnly True to omit much of the item's information (stat bonuses, sockets, and binding) from the tooltip; false to show all of the item's information  (boolean)
	-- @return hasItem - 1 if the unit has an item in the given slot; otherwise nil (number, 1nil)
	-- @return hasCooldown - 1 if the item is currently on cooldown; otherwise nil (number, 1nil)
	-- @return repairCost - Cost to repair the item (in copper, ignoring faction discounts) (number)
	------------------------------------
	-- SetInventoryItem

	------------------------------------
	---
	-- @name GameTooltip:SetInventoryItemByID
	-- @class function
	------------------------------------
	-- SetInventoryItemByID

	------------------------------------
	---
	-- @name GameTooltip:SetLFGCompletionReward
	-- @class function
	------------------------------------
	-- SetLFGCompletionReward

	------------------------------------
	---
	-- @name GameTooltip:SetLFGDungeonReward
	-- @class function
	------------------------------------
	-- SetLFGDungeonReward

	------------------------------------
	---
	-- @name GameTooltip:SetLootCurrency
	-- @class function
	------------------------------------
	-- SetLootCurrency

	------------------------------------
	--- Fills the tooltip with information about an item available as loot
	-- @name GameTooltip:SetLootItem
	-- @class function
	-- @param slot Index of a loot slot (between 1 and GetNumLootItems()) (number)
	------------------------------------
	-- SetLootItem

	------------------------------------
	--- Fills the tooltip with information about an item currently up for loot rolling
	-- @name GameTooltip:SetLootRollItem
	-- @class function
	-- @param id Index of an item currently up for loot rolling (as provided in the START_LOOT_ROLL event) (number)
	------------------------------------
	-- SetLootRollItem

	------------------------------------
	--- Fills the tooltip with information about an alternate currency required to purchase an item from a vendor. Only applies to item-based currencies, not honor or arena points.
	-- @name GameTooltip:SetMerchantCostItem
	-- @class function
	-- @param index Index of an item in the vendor's listing (between 1 and GetMerchantNumItems()) (number)
	-- @param currency Index of one of the item currencies required to purchase the item (between 1 and select(3,GetMerchantItemCostInfo(index))) (number)
	------------------------------------
	-- SetMerchantCostItem

	------------------------------------
	--- Fills the tooltip with information about an item available for purchase from a vendor
	-- @name GameTooltip:SetMerchantItem
	-- @class function
	-- @param merchantIndex The index of an item in the merchant window, between 1 and GetMerchantNumItems(). (number)
	------------------------------------
	-- SetMerchantItem

	------------------------------------
	--- Sets the minimum width of the tooltip. Normally, a tooltip is automatically sized to match the width of its shortest line of text; setting a minimum width can be useful if the tooltip also contains non-text frames (such as an amount of money or a status bar).</p>
	--- <p>The tooltip is not automatically resized to the new width; to do so, call the tooltip's :Show() method.
	-- @name GameTooltip:SetMinimumWidth
	-- @class function
	-- @param width Minimum width of the tooltip frame (in pixels) (number)
	------------------------------------
	-- SetMinimumWidth

	------------------------------------
	--- Sets the frame to which the tooltip refers and is anchored
	-- @name GameTooltip:SetOwner
	-- @class function
	-- @param ANCHOR_CURSOR Toolip follows the mouse cursor
	-- @param ANCHOR_LEFT Align the bottom right of the tooltip with the top left of the owner
	-- @param ANCHOR_NONE Tooltip appears in the default position
	-- @param ANCHOR_PRESERVE Tooltip's position is saved between sessions (useful if the tooltip is made user-movable)
	-- @param ANCHOR_RIGHT Align the bottom left of the tooltip with the top right of the owner
	-- @param ANCHOR_TOPLEFT Align the bottom left of the tooltip with the top left of the owner
	-- @param ANCHOR_TOPRIGHT Align the bottom right of the tooltip with the top right of the owner
	------------------------------------
	-- SetOwner

	------------------------------------
	--- Sets the amount of space between tooltip's text and its right-side edge. Used in the default UI's ItemRefTooltip to provide space for a close button.
	-- @name GameTooltip:SetPadding
	-- @class function
	-- @param padding Amount of space between the right-side edge of the tooltip's text and the right-side edge of the tooltip frame (in pixels) (number)
	------------------------------------
	-- SetPadding

	------------------------------------
	--- Fills the tooltip with information about a pet action. Only provides information for pet action slots containing pet spells -- in the default UI, the standard pet actions (attack, follow, passive, aggressive, etc) are special-cased to show specific tooltip text.
	-- @name GameTooltip:SetPetAction
	-- @class function
	-- @param index Index of a pet action button (between 1 and NUM_PET_ACTION_SLOTS) (number)
	------------------------------------
	-- SetPetAction

	------------------------------------
	--- Fills the tooltip with information about one of the special actions available while the player possesses another unit
	-- @name GameTooltip:SetPossession
	-- @class function
	-- @param index Index of a possession bar action (between 1 and NUM_POSSESS_SLOTS) (number)
	------------------------------------
	-- SetPossession

	------------------------------------
	---
	-- @name GameTooltip:SetQuestCurrency
	-- @class function
	------------------------------------
	-- SetQuestCurrency

	------------------------------------
	--- Fills the tooltip with information about an item in a questgiver dialog
	-- @name GameTooltip:SetQuestItem
	-- @class function
	-- @param required Items required to complete the quest
	-- @param reward Items given as reward for the quest
	------------------------------------
	-- SetQuestItem

	------------------------------------
	---
	-- @name GameTooltip:SetQuestLogCurrency
	-- @class function
	------------------------------------
	-- SetQuestLogCurrency

	------------------------------------
	--- Fills the tooltip with information about an item related to the selected quest in the quest log
	-- @name GameTooltip:SetQuestLogItem
	-- @class function
	-- @param reward Items always given as reward for the quest
	------------------------------------
	-- SetQuestLogItem

	------------------------------------
	--- Fills the tooltip with information about the reward spell for the selected quest in the quest log
	-- @name GameTooltip:SetQuestLogRewardSpell
	-- @class function
	------------------------------------
	-- SetQuestLogRewardSpell

	------------------------------------
	--- Fills the tooltip with information about a usable item associated with a current quest
	-- @name GameTooltip:SetQuestLogSpecialItem
	-- @class function
	-- @param questIndex Index of a quest log entry with an associated usable item (between 1 and GetNumQuestLogEntries()) (number)
	------------------------------------
	-- SetQuestLogSpecialItem

	------------------------------------
	--- Fills the tooltip with information about the spell reward in a questgiver dialog
	-- @name GameTooltip:SetQuestRewardSpell
	-- @class function
	------------------------------------
	-- SetQuestRewardSpell

	------------------------------------
	---
	-- @name GameTooltip:SetReforgeItem
	-- @class function
	------------------------------------
	-- SetReforgeItem

	------------------------------------
	--- Fills the tooltip with information about an item attached to the outgoing mail message
	-- @name GameTooltip:SetSendMailItem
	-- @class function
	-- @param slot Index of an outgoing attachment slot (between 1 and ATTACHMENTS_MAX_SEND) (number)
	------------------------------------
	-- SetSendMailItem

	------------------------------------
	--- Fills the tooltip with information about an ability on the stance/shapeshift bar
	-- @name GameTooltip:SetShapeshift
	-- @class function
	-- @param index Index of an ability on the stance/shapeshift bar (between 1 and GetNumShapeshiftForms()) (number)
	------------------------------------
	-- SetShapeshift

	------------------------------------
	--- Fills the tooltip with information about the item currently being socketed
	-- @name GameTooltip:SetSocketedItem
	-- @class function
	------------------------------------
	-- SetSocketedItem

	------------------------------------
	--- Fills the tooltip with information about a gem added to a socket
	-- @name GameTooltip:SetSocketGem
	-- @class function
	-- @param index Index of a gem socket (between 1 and GetNumSockets()) (number)
	------------------------------------
	-- SetSocketGem

	------------------------------------
	---
	-- @name GameTooltip:SetSpellBookItem
	-- @class function
	------------------------------------
	-- SetSpellBookItem

	------------------------------------
	--- Fills the tooltip with information about a spell specified by ID
	-- @name GameTooltip:SetSpellByID
	-- @class function
	-- @param id Numeric ID of a spell (number, spellID)
	------------------------------------
	-- SetSpellByID

	------------------------------------
	--- Fills the tooltip with information about a talent
	-- @name GameTooltip:SetTalent
	-- @class function
	-- @param tabIndex Index of a talent tab (between 1 and GetNumTalentTabs()) (number)
	-- @param talentIndex Index of a talent option (between 1 and GetNumTalents()) (number)
	-- @param inspect true to return information for the currently inspected unit; false to return information for the player (boolean)
	-- @param pet true to return information for the player's pet; false to return information for the player (boolean)
	-- @param talentGroup Which set of talents to edit, if the player has Dual Talent Specialization enabled (number) <ul><li>1 - Primary Talents
	-- @param 2 Secondary Talents
	-- @param nil Currently active talents
	------------------------------------
	-- SetTalent

	------------------------------------
	--- Sets the tooltip's text. Any other content currently displayed in the tooltip will be removed or hidden, and the tooltip's size will be adjusted to fit the new text.
	-- @name GameTooltip:SetText
	-- @class function
	-- @param text Text to be displayed in the tooltip (string)
	-- @param r Red component of the text color (0.0 - 1.0) (number)
	-- @param g Green component of the text color (0.0 - 1.0) (number)
	-- @param b Blue component of the text color (0.0 - 1.0) (number)
	-- @param a Alpha (opacity) for the text (0.0 = fully transparent, 1.0 = fully opaque) (number)
	------------------------------------
	-- SetText

	------------------------------------
	--- Fills the tooltip with information about one of the player's active totems.. Totem functions are also used for ghouls summoned by a Death Knight's Raise Dead ability (if the ghoul is not made a controllable pet by the Master of Ghouls talent).
	-- @name GameTooltip:SetTotem
	-- @class function
	-- @param slot Which totem to query (number) <ul><li>1 - Fire (or Death Knight's ghoul)
	-- @param 2 Earth
	-- @param 3 Water
	-- @param 4 Air
	------------------------------------
	-- SetTotem

	------------------------------------
	--- Fills the tooltip with information about an item offered for trade by the player. See :SetTradeTargetItem() for items to be received from the trade.
	-- @name GameTooltip:SetTradePlayerItem
	-- @class function
	-- @param index Index of an item offered for trade by the player (between 1 and MAX_TRADE_ITEMS) (number)
	------------------------------------
	-- SetTradePlayerItem

	------------------------------------
	--- Fills the tooltip with information about an item created by a trade skill recipe or a reagent in the recipe
	-- @name GameTooltip:SetTradeSkillItem
	-- @class function
	-- @param skillIndex Index of a recipe in the trade skill list (between 1 and GetNumTradeSkills()) (number)
	-- @param reagentIndex Index of a reagent in the recipe (between 1 and GetTradeSkillNumReagents()); if omitted, displays a tooltip for the item created by the recipe (number)
	------------------------------------
	-- SetTradeSkillItem

	------------------------------------
	--- Fills the tooltip with information about an item offered for trade by the target. See :SetTradePlayerItem() for items to be traded away by the player.
	-- @name GameTooltip:SetTradeTargetItem
	-- @class function
	-- @param index Index of an item offered for trade by the target (between 1 and MAX_TRADE_ITEMS) (number)
	------------------------------------
	-- SetTradeTargetItem

	------------------------------------
	--- Fills the tooltip with information about a trainer service
	-- @name GameTooltip:SetTrainerService
	-- @class function
	-- @param index Index of an entry in the trainer service listing (between 1 and GetNumTrainerServices()) (number)
	------------------------------------
	-- SetTrainerService

	------------------------------------
	--- Fills the tooltip with information about a unit
	-- @name GameTooltip:SetUnit
	-- @class function
	-- @param unit A unit to query (string, unitid)
	------------------------------------
	-- SetUnit

	------------------------------------
	--- Fills the tooltip with information about a buff or debuff on a unit
	-- @name GameTooltip:SetUnitAura
	-- @class function
	-- @param unit A unit to query (string, unitID)
	-- @param index Index of a buff or debuff on the unit (number)
	-- @param filter A list of filters to use when resolving the index, separated by the pipe '|' character; e.g. "RAID|PLAYER" will query group buffs cast by the player (string) <ul><li>CANCELABLE - Show auras that can be cancelled
	-- @param HARMFUL Show debuffs only
	-- @param HELPFUL Show buffs only
	-- @param NOT_CANCELABLE Show auras that cannot be cancelled
	-- @param PLAYER Show auras the player has cast
	-- @param RAID Show auras the player can cast on party/raid members (as opposed to self buffs)
	------------------------------------
	-- SetUnitAura

	------------------------------------
	--- Fills the tooltip with information about a buff on a unit. This method is an alias for :SetUnitAura() with a built-in HELPFUL filter (which cannot be removed or negated with the HARMFUL filter).
	-- @name GameTooltip:SetUnitBuff
	-- @class function
	-- @param unit A unit to query (string, unitID)
	-- @param index Index of a buff or debuff on the unit (number)
	-- @param filter A list of filters to use when resolving the index, separated by the pipe '|' character; e.g. "RAID|PLAYER" will query group buffs cast by the player (string) <ul><li>CANCELABLE - Show auras that can be cancelled
	-- @param NOT_CANCELABLE Show auras that cannot be cancelled
	-- @param PLAYER Show auras the player has cast
	-- @param RAID Show auras the player can cast on party/raid members (as opposed to self buffs)
	------------------------------------
	-- SetUnitBuff

	------------------------------------
	--- Fills the tooltip with information about a debuff on a unit. This method is an alias for :SetUnitAura() with a built-in HARMFUL filter (which cannot be removed or negated with the HELPFUL filter).
	-- @name GameTooltip:SetUnitDebuff
	-- @class function
	-- @param unit A unit to query (string, unitID)
	-- @param index Index of a buff or debuff on the unit (number)
	-- @param filter A list of filters to use when resolving the index, separated by the pipe '|' character; e.g. "CANCELABLE|PLAYER" will query cancelable debuffs cast by the player (string) <ul><li>CANCELABLE - Show auras that can be cancelled
	-- @param NOT_CANCELABLE Show auras that cannot be cancelled
	-- @param PLAYER Show auras the player has cast
	-- @param RAID Show auras the player can cast on party/raid members (as opposed to self buffs)
	------------------------------------
	-- SetUnitDebuff

	------------------------------------
	--- Get the left text of the given index line
	-- @name GameTooltip:GetLeftText
	-- @class function
	-- @param index between 1 and self:NumLines()
	-- @usage GameTooltip:GetLeftText(1)
	------------------------------------
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

	------------------------------------
	--- Get the right text of the given index line
	-- @name GameTooltip:GetRightText
	-- @class function
	-- @param index between 1 and self:NumLines()
	-- @usage GameTooltip:GetRightText(1)
	------------------------------------
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

	------------------------------------
	--- Get the texutre of the given index line
	-- @name GameTooltip:GetTexture
	-- @class function
	-- @param index between 1 and self:NumLines()
	-- @usage GameTooltip:GetTexture(1)
	------------------------------------
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

	------------------------------------
	--- Get the money of the given index, default 1
	-- @name GameTooltip:GetMoney
	-- @class function
	-- @param index if nil, 1 would be the default
	-- @usage GameTooltip:GetMoney()
	------------------------------------
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
	-- Property
	------------------------------------------------------
	-- Owner
	property "Owner" {
		Get = function(self)
			return self:GetOwner()
		end,
		Set = function(self, owner)
			self:SetOwner(owner)
		end,
		Type = UIObject + nil,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Constructor(self, name, parent, ...)
		local fullname = (parent:GetName() or "").."."..name

		return CreateFrame("GameTooltip", fullname, parent, ...)
	end
endclass "GameTooltip"

partclass "GameTooltip"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(GameTooltip)
endclass "GameTooltip"