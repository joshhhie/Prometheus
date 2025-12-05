-- ObfusQ - Roblox Luau Obfuscator
-- Modified for LuaU and enhanced obfuscation capabilities
-- Refactored structure for uniqueness

-- Configure package.path for require
local function get_module_dir()
	local trace = debug.getinfo(2, "S").source:sub(2)
	return trace:match("(.*[/%\\])")
end

local old_pkg_path = package.path
package.path = get_module_dir() .. "?.lua;" .. package.path

-- Luau Compatibility - Math utilities
if not pcall(function()
    return math.random(1, 2^40)
end) then
    local legacy_random = math.random
    math.random = function(a, b)
        if not a and b then
            return legacy_random()
        end
        if not b then
            return math.random(1, a)
        end
        if a > b then
            a, b = b, a
        end
        local delta = b - a
        assert(delta >= 0)
        if delta > 2 ^ 31 - 1 then
            return math.floor(legacy_random() * delta + a)
        else
            return legacy_random(a, b)
        end
    end
end

-- Roblox metatable support
_G.newproxy = _G.newproxy or function(arg)
    if arg then
        return setmetatable({}, {})
    end
    return {}
end

-- Load ObfusQ Modules
local ProcessingPipeline = require("prometheus.pipeline")
local SyntaxHighlighter = require("highlightlua")
local ConsoleColors = require("colors")
local MessageLogger = require("logger")
local PresetConfigs = require("presets")
local GlobalConfig = require("config")
local CoreUtils = require("prometheus.util")

-- Restore package.path
package.path = old_pkg_path

-- Export modules with new names
return {
    ProcessingPipeline = ProcessingPipeline
    SyntaxHighlighter = SyntaxHighlighter
    ConsoleColors = ConsoleColors
    MessageLogger = MessageLogger
    GlobalConfig = CoreUtils.readonly(GlobalConfig)
    PresetConfigs = PresetConfigs
    CoreUtils = CoreUtils
}


