-- Author      : Kurapica
-- Create Date : 2013/11/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Action.BagHandler", version) then
	return
end

_Enabled = false

_BagSlotMap = {
	0 = "BackSlot",
	1 = "Bag0Slot",
	2 = "Bag1Slot",
	3 = "Bag2Slot",
	4 = "Bag3Slot",
}

function OnEnable(self)
	self:RegisterEvent("ITEM_LOCK_CHANGED")
	self:RegisterEvent("CURSOR_UPDATE")

	self:RegisterEvent("BAG_UPDATE_DELAYED")
	self:RegisterEvent("INVENTORY_SEARCH_UPDATE")

	for i, slot in pairs(_BagSlotMap) do
		local id, texture = GetInventorySlotInfo(slot)
		_BagSlotMap[i] = { id = id, texture = texture, slot = slot }
	end

	OnEnable = nil
end

function ITEM_LOCK_CHANGED(self, bag, slot)
	if not slot then
		for i, map in pairs(_BagSlotMap) do
			if map.id == bag then
				local flag = IsInventoryItemLocked(bag)
				for _, btn in handler() do
					if btn.ActionTarget == i then btn.IconLocked = flag end
				end
				break
			end
		end
	end
end

function CURSOR_UPDATE(self)
	for _, btn in handler() do
		local target = _BagSlotMap[self.ActionTarget]
		if target then
			btn.HighlightLocked = CursorCanGoInSlot(target.id)
		end
	end
end

function BAG_UPDATE_DELAYED(self)
	handler:Refresh()
end

function INVENTORY_SEARCH_UPDATE(self)
	for _, btn in handler() do
		btn.ShowSearchOverlay = IsContainerFiltered(self.ActionTarget)
	end
end

handler = ActionTypeHandler {
	Name = "bag",
	DragStyle = "Keep",
	ReceiveStyle = "Keep",
	PickupSnippet = "Custom",
	ReceiveSnippet = "Custom",
	OnEnableChanged = function(self) _Enabled = self.Enabled end,
}

-- Overwrite methods
function handler:PickupAction(target)
	return PickupBagFromSlot(_BagSlotMap[target].id)
end

function handler:ReceiveAction(target, detail)
	return PutItemInBackpack()
end

function handler:HasAction()
	return _BagSlotMap[self.ActionTarget] and true or false
end

function handler:GetActionTexture()
	local target = self.ActionTarget
	if _BagSlotMap[target] then
		return GetInventoryItemTexture("player", _BagSlotMap[target].id) or _BagSlotMap[target].texture
	end
end

function handler:SetTooltip(GameTooltip)
	local target = self.ActionTarget
	if _BagSlotMap[target] then
		local id = _BagSlotMap[target].id
		if ( GameTooltip:SetInventoryItem("player", id) ) then
			local bindingKey = GetBindingKey("TOGGLEBAG"..(5 -  target))
			if ( bindingKey ) then
				GameTooltip:AppendText(" "..NORMAL_FONT_COLOR_CODE.."("..bindingKey..")"..FONT_COLOR_CODE_CLOSE);
			end
			if (not IsInventoryItemProfessionBag("player", ContainerIDToInventoryID(target))) then
				for i = LE_BAG_FILTER_FLAG_EQUIPMENT, NUM_LE_BAG_FILTER_FLAGS do
					if ( GetBagSlotFlag(target, i) ) then
						GameTooltip:AddLine(BAG_FILTER_ASSIGNED_TO:format(BAG_FILTER_LABELS[i]))
						break
					end
				end
			end
			GameTooltip:Show()
		else
			GameTooltip:SetText(EQUIP_CONTAINER, 1.0, 1.0, 1.0)
		end
	end
end

-- Expand IFActionHandler
interface "IFActionHandler"
	__Local__() __Default__(0)
	struct "BagSlot" {
		function (value)
			assert(type(value) == "number", "%s must be number.")
			assert(value >= 0 and value <= 4, "%s must between [0-4]")
			return math.floor(value)
		end
	}

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	__Doc__[[The action button's content if its type is 'bag']]
	property "BagSlot" {
		Get = function(self)
			return self:GetAttribute("actiontype") == "bag" and tonumber(self:GetAttribute("bag"))
		end,
		Set = function(self, value)
			self:SetAction("bag", value)
		end,
		Type = BagSlot,
	}

	__Doc__[[Whether the search overlay will be shown]]
	__Optional__() property "ShowSearchOverlay" { Type = Boolean }
endinterface "IFActionHandler"