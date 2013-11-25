-- Author      : Kurapica
-- Create Date : 2013/11/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Action.FlyoutHandler", version) then
	return
end

MAX_SKILLLINE_TABS = _G.MAX_SKILLLINE_TABS

enum "FlyoutDirection" {
	"UP",
	"DOWN",
	"LEFT",
	"RIGHT",
}
