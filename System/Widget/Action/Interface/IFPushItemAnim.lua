-- Author      : Kurapica
-- Create Date : 2015/01/03
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Action.IFPushItemAnim", version) then
	return
end

function OnLoad(self)
	self:RegisterEvent("ITEM_PUSH")
end

function ITEM_PUSH(self, bagid, icon)
	if self[bagid+1] then
		self:ClearAllPoints()
		self:SetAllPoints(self[bagid+1])

		self.AnimIcon.TexturePath = icon
		self:Play(true)
	end
end

__Doc__[[IFPushItemAnim is used to provide the animation that push item into a bag.]]
interface "IFPushItemAnim"

	__Local__() __Cache__()
	class "PushItemAnim"
		inherit "Frame"

		local flyin_OnPlay(self)
			self.Parent.Visible = true
		end

		local flyin_OnFinished(self)
			self.Parent.Visible = false
		end

		------------------------------------------------------
		-- Method
		------------------------------------------------------
		function Play(self)
			self.AnimIcon.Flyin:Play(true)
		end

		------------------------------------------------------
		-- Constructor
		------------------------------------------------------
	    function PushItemAnim(self, ...)
	    	Super(self, ...)

			self.FrameStrata = "HIGH"
			self.MouseEnabled = false

	    	local animIcon = Texture("AnimIcon", self, "OVERLAY")
	    	animIcon:SetAllPoints(self)

	    	local flyin = AnimationGroup("Flyin", animIcon)

			local scale = Scale("Scale", flyin)
			scale.Duration = 1
			scale.Order = 1
			scale.FromScale = Dimension(0.125, 0.125)
			scale.ToScale = Dimension(1, 1)

			local alpha = Alpha("Alpha", flyin)
			alpha.Duration = 1
			alpha.Order = 1
			alpha.FromAlpha = 0
			alpha.ToAlpha = 1

			local path = Path("Path", flyin)
			path.Duration = 1
			path.Order = 1
			path.Curve = "SMOOTH"

			local cp1 = ControlPoint("Cp1", path)
			cp1.Offset = Dimension(-15, 30)

			local cp2 = ControlPoint("Cp2", path)
			cp2.Offset = Dimension(-75, 60)

			flyin.OnPlay = flyin_OnPlay
			flyin.OnFinished = flyin_OnFinished
	    end
	endclass "PushItemAnim"

	rycPushItemAnim = Recyle(PushItemAnim, "IGAS_PushItemAnim%d")

	_BagMap = {}

	__Doc__[[
		<desc>Attach bag with id</desc>
		<param name="bag">the region used for the bag</param>
		<param name="id" optional="true">the bag slot index</param>
	]]
	__Static__() __Arguments__{ Region + nil, Number + Boolean + nil }
	function AttachBag(bag, id)
		if bag then
			id = id and id >=0 and id or bag.ID
			self[id+1] = bag
		elseif id and id >= 0 then
			self[id+1] = nil
		end
	end

	------------------------------------------------------
	-- Dispose
	------------------------------------------------------
    function Dispose(self) _BagMap[self] = nil end

	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFPushItemAnim(self) AttachBag(self) end
endinterface "IFPushItemAnim"