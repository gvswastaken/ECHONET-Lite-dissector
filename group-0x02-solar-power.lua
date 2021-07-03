local devicesuperclass = require("device-superclass")
local list = require("echonet-lite-codelist")
local properties = {
    [0x80] = "Operation status",
	[0xe0] = "Instantaneous electrity generated",
	[0xe1] = "Cumulative electrity generated",
}

-- ========================================================
-- ECHONET Lite epc parser
-- ========================================================

local function solarpower(classgroup, class, epc, pdc, edt, tree, edata)
    if classgroup:uint() == 0x02 and class:uint() == 0x79 then
        local label = properties[epc:uint()]
        if not label then
            devicesuperclass(classgroup, class, epc, pdc, edt, tree, edata, properties)
            do return end
        end
        tree:add(edata.fields.epc, epc, epc:uint(), nil, string.format("(%s)", label))
        tree:add(edata.fields.pdc, pdc)
        tree:append_text(string.format(": %s", label))
        if pdc:uint() == 0 or edt:len() == 0 then
            do return end
        end

		local edttree = tree:add(edata.fields.edt, edt)

		if epc:uint() == 0xe0 then
			edttree:append_text(string.format(" (Instantaneous electricity generated: %dW)", edt:uint()))
		end
		if epc:uint() == 0xe1 then
			edttree:append_text(string.format(" (Cumulative electricity generated: %dkWh)", edt:uint() / 1000))
		end
    end
end

return solarpower
