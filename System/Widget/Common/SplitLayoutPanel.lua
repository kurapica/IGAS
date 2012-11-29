-- Author      : Kurapica
-- Create Date : 5/29/2012
-- ChangeLog

----------------------------------------------------------------------------------------------------------------------------------------
--- SplitLayoutPanel
-- <br><br>inherit <a href=".\DockLayoutPanel.html">SplitLayoutPanel</a> For all methods, properties and scriptTypes
-- @name SplitLayoutPanel
----------------------------------------------------------------------------------------------------------------------------------------

local version = 1
if not IGAS:NewAddon("IGAS.Widget.SplitLayoutPanel", version) then
	return
end

class "SplitLayoutPanel"
	inherit "DockLayoutPanel"
	
	local function OnEnter(self)
		self:GetChild("HighLight").Visible = true
	end
	
	local function OnLeave(self)
		self:GetChild("HighLight").Visible = false
	end
	
	local function OnMouseUp(self)
		local parent = self.Parent
		
		parent:StopMovingOrSizing()
		
		if parent.__DockLayout_DIR == DockLayoutPanel.Direction.NORTH or
				parent.__DockLayout_DIR == DockLayoutPanel.Direction.SOUTH then	
			Super.AddWidget(parent.Parent, parent, parent.__DockLayout_DIR, parent.Height, "px")
		elseif parent.__DockLayout_DIR == DockLayoutPanel.Direction.EAST or
				parent.__DockLayout_DIR == DockLayoutPanel.Direction.WEST then
			Super.AddWidget(parent.Parent, parent, parent.__DockLayout_DIR, parent.Width, "px")
		end		
	end
	
	local function OnMouseDown(self)
		local parent = self.Parent
		
		if parent.__DockLayout_DIR == DockLayoutPanel.Direction.NORTH then
			parent:StartSizing("BOTTOM")
		elseif parent.__DockLayout_DIR == DockLayoutPanel.Direction.EAST then
			parent:StartSizing("LEFT")
		elseif parent.__DockLayout_DIR == DockLayoutPanel.Direction.SOUTH then	
			parent:StartSizing("TOP")
		elseif parent.__DockLayout_DIR == DockLayoutPanel.Direction.WEST then
			parent:StartSizing("RIGHT")
		end
	end
	
	local function BuildSeperate(self, widget)
		if not widget:GetChild("DockLayoutPanel_Seperate") and widget.__DockLayout_DIR and widget.__DockLayout_DIR ~= DockLayoutPanel.Direction.REST then
			local seperate = Frame("DockLayoutPanel_Seperate", widget)			
			
			widget.Resizable = true
			seperate.MouseEnabled = true
			
			if widget.__DockLayout_DIR == DockLayoutPanel.Direction.NORTH then
				seperate:SetPoint("TOPLEFT", widget, "BOTTOMLEFT", 0, 4)
				seperate:SetPoint("TOPRIGHT", widget, "BOTTOMRIGHT", 0, 4)
				
				seperate.Height = 8
			elseif widget.__DockLayout_DIR == DockLayoutPanel.Direction.EAST then
				seperate:SetPoint("TOPRIGHT", widget, "TOPLEFT", 4, 0)
				seperate:SetPoint("BOTTOMRIGHT", widget, "BOTTOMLEFT", 4, 0)
				
				seperate.Width = 8
			elseif widget.__DockLayout_DIR == DockLayoutPanel.Direction.SOUTH then				
				seperate:SetPoint("BOTTOMLEFT", widget, "TOPLEFT", 0, -4)
				seperate:SetPoint("BOTTOMRIGHT", widget, "TOPRIGHT", 0, -4)
				
				seperate.Height = 8
			elseif widget.__DockLayout_DIR == DockLayoutPanel.Direction.WEST then
				seperate:SetPoint("TOPLEFT", widget, "TOPRIGHT", -4, 0)
				seperate:SetPoint("BOTTOMLEFT", widget, "BOTTOMRIGHT", -4, 0)
				
				seperate.Width = 8
			end
			
			local highLight = Texture("HighLight", seperate, "BACKGROUND")
			highLight:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
			highLight:SetBlendMode("ADD")
			highLight:SetAllPoints(seperate)
			highLight.Visible = false
			
			seperate.OnEnter = OnEnter
			seperate.OnLeave = OnLeave
			seperate.OnMouseUp = OnMouseUp
			seperate.OnMouseDown = OnMouseDown
		end
	end
	
	------------------------------------------------------
	-- Enum
	------------------------------------------------------
	
	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------	
	
	------------------------------------
	--- Add Widget to the panel
	-- @name SplitLayoutPanel:AddWidget
	-- @class function
	-- @param direction
	-- @param widget
	-- @param size
	-- @param unit
	-- @return index
	------------------------------------
	function AddWidget(self, widget, direction, size, unit)
		local index = Super.AddWidget(self, widget, direction, size, unit)		
		
		BuildSeperate(self, widget)
		
		return index
	end
	
	------------------------------------
	--- Insert Widget to the panel
	-- @name SplitLayoutPanel:InsertWidget
	-- @class function
	-- @param index the index to be insert
	-- @param widget
	-- @return index
	------------------------------------
	function InsertWidget(self, before, widget, direction, size, unit)
		local index = Super.InsertWidget(self, before, widget, direction, size, unit)
	
		BuildSeperate(self, widget)
		
		return index
	end
	
	------------------------------------
	--- Remove Widget to the panel
	-- @name SplitLayoutPanel:RemoveWidget
	-- @class function
	-- @param index|name index or the name that need to be removed
	-- @param withoutDispose optional, true if need get the removed widget
	-- @return widget if withoutDispose is set to true
	------------------------------------
	function RemoveWidget(self, index, withoutDispose)
		local obj = Super.RemoveWidget(self, index, withoutDispose)
		
		if obj and obj:GetChild("DockLayoutPanel_Seperate") then
			obj:GetChild("DockLayoutPanel_Seperate"):Dispose()
		end
		
		return obj
	end
	
	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------	
	
	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function SplitLayoutPanel(name, parent)
		local panel = Super(name, parent)
		
		return panel
	end
endclass "SplitLayoutPanel"