-- Author      : Kurapica
-- Create Date : 2012/07/24
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.IFCooldown", version) then
	return
end

----------------------------------------------------------
--- IFCooldown
-- @type Interface
-- @name IFCooldown
----------------------------------------------------------
interface "IFCooldown"
	------------------------------------------------------
	-- Script
	------------------------------------------------------
	------------------------------------
	--- ScriptType, Run when the object's cooldown need update
	-- @name OnCooldownUpdate
	-- @type script
	-- @usage function obj:OnCooldownUpdate(start, duration)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnCooldownUpdate"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	
	------------------------------------------------------
	-- Property
	------------------------------------------------------
	
	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
endinterface "IFCooldown"
