-- ########################################################
-- ECHONET Lite Wireshark dissector
-- ########################################################
--
--   Author : Yuki MIZUNO
--   Version: 0.0.1
--   License: MIT
--
-- ########################################################
--
--  Copyright (c) 2016 Yuki MIZUNO
--  This software is released under the MIT License.
--  http://opensource.org/licenses/MIT
--

edata = Proto("echonetlite.edata", "ECHONET Lite Data (EDATA)")

-- ========================================================
-- ECHONET Lite Header value table
-- ========================================================

esv = {
    [0x60] = "SetI",
    [0x61] = "SetC",
    [0x62] = "Get",
    [0x63] = "INF_REQ",
    [0x6E] = "SetGet",
    [0x71] = "Set_Res",
    [0x72] = "Get_Res",
    [0x73] = "INF",
    [0x74] = "INFC",
    [0x7A] = "INFC_Res",
    [0x7E] = "SetGet_Res",
    [0x50] = "SetI_SNA",
    [0x51] = "SetC_SNA",
    [0x52] = "Get_SNA",
    [0x53] = "INF_SNA",
    [0x5E] = "SetGet_SNA"
}

-- ========================================================
-- ECHONET Lite Data fields definition.
-- ========================================================

edata.fields.seoj = ProtoField.uint24("echonetlite.edata.seoj", "Source ECHONET Lite object (SEOJ)", base.HEX)
edata.fields.seojgroup = ProtoField.uint8("echonetlite.edata.seoj.classgroup", "Class group code", base.HEX)
edata.fields.seojclass = ProtoField.uint8("echonetlite.edata.seoj.class", "Class code", base.HEX)
edata.fields.seojinstance = ProtoField.uint8("echonetlite.edata.seoj.instance", "Instance code", base.HEX)
edata.fields.deoj = ProtoField.uint24("echonetlite.edata.deoj", "Destination ECHONET Lite object (DEOJ)", base.HEX)
edata.fields.deojgroup = ProtoField.uint8("echonetlite.edata.deoj.classgroup", "Class group code", base.HEX)
edata.fields.deojclass = ProtoField.uint8("echonetlite.edata.deoj.class", "Class code", base.HEX)
edata.fields.deojinstance = ProtoField.uint8("echonetlite.edata.deoj.instance", "Instance code", base.HEX)
edata.fields.esv  = ProtoField.uint8("echonetlite.edata.esv", "ECHONET Lite service (ESV)",  base.HEX, esv)
edata.fields.opc  = ProtoField.uint8("echonetlite.edata.opc", "Property size (OPC)",  base.DEC)

-- ========================================================
-- Parse ECHONET Lite Data fields.
-- ========================================================

function edata.dissector(buffer, pinfo, tree)
    local data_len = buffer:len()

    local subtree = tree:add(edata, buffer(0, data_len))

    local seojtree = subtree:add(edata.fields.seoj, buffer(0, 3))
    seojtree:add(edata.fields.seojgroup, buffer(0, 1))
    seojtree:add(edata.fields.seojclass, buffer(1, 1))
    seojtree:add(edata.fields.seojinstance, buffer(2, 1))

    local deojtree = subtree:add(edata.fields.deoj, buffer(3, 3))
    deojtree:add(edata.fields.deojgroup, buffer(3, 1))
    deojtree:add(edata.fields.deojclass, buffer(4, 1))
    deojtree:add(edata.fields.deojinstance, buffer(5, 1))

    subtree:add(edata.fields.esv,  buffer(6, 1))
    subtree:add(edata.fields.opc,  buffer(7, 1))
end
