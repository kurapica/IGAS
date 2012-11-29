-- Author      : Kurapica
-- Create Date : 2012/06/03
-- ChangeLog   :

----------------------------------------------------------------------------------------------------------------------------------------
--- Error
-- @name Error
----------------------------------------------------------------------------------------------------------------------------------------

local version = 1

if not IGAS:NewAddon("IGAS.Error", version) then
	return
end

namespace "System"

class "Error"
	
endclass "Error"