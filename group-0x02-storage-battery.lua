local devicesuperclass = require("device-superclass")
local list = require("echonet-lite-codelist")
local properties = {
    [0x80] = "Operation status",
	[0xcf] = "Working operation status",
	[0xda] = "Operation mode setting",
	[0xe4] = "Remaining stored electricity 3",
	[0xe6] = "Battery type",
	
}

-- ========================================================
-- ECHONET Lite epc parser
-- ========================================================

local function storagebattery(classgroup, class, epc, pdc, edt, tree, edata)
    if classgroup:uint() == 0x02 and class:uint() == 0x7d then
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

		if epc:uint() == 0xe4 then
			edttree:append_text(string.format(" (Remaining stored electricity 3: %d%%)", edt:uint()))
		end

		if epc:uint() == 0xcf then
			local state = {
		        [0x40] = "Other",
				[0x41] = "Rapid charging",
				[0x42] = "Charging",
				[0x43] = "Discharging",
				[0x44] = "Standby",
				[0x45] = "Test",
				[0x46] = "Automatic",
				[0x48] = "Restart",
				[0x49] = "Effective capacity recalculation processing"
			}
			edttree:append_text(string.format(" (Working operation status: %s)", state[edt:uint()]))
		end
	end
end

return storagebattery
