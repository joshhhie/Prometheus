-- ObfusQ Command Line Interface
-- Roblox Luau Obfuscator

local function get_module_dir()
	local trace = debug.getinfo(2, "S").source:sub(2)
	return trace:match("(.*[/%\\])")
end
package.path = get_module_dir() .. "?.lua;" .. package.path

local ObfusQ = require("prometheus")
ObfusQ.MessageLogger.logLevel = ObfusQ.MessageLogger.LogLevel.Info

local function check_file(path)
    local handle = io.open(path, "rb")
    if handle then handle:close() end
    return handle ~= nil
end

string.split = function(str, sep)
    local result = {}
    local pattern = string.format("([^%s]+)", sep)
    str:gsub(pattern, function(c) result[#result+1] = c end)
    return result
end

local function read_file_lines(path)
    if not check_file(path) then return {} end
    local result = {}
    for line in io.lines(path) do
      result[#result + 1] = line
    end
    return result
end

local active_config
local input_file
local output_file
local target_luau_version
local should_pretty_print

ObfusQ.ConsoleColors.enabled = true

-- Parse command line arguments
local i = 1
while i <= #arg do
    local current_arg = arg[i]
    if current_arg:sub(1, 2) == "--" then
        if current_arg == "--preset" or current_arg == "--p" then
            if active_config then
                ObfusQ.MessageLogger:warn("Config was set multiple times")
            end
            i = i + 1
            local selected_preset = ObfusQ.PresetConfigs[arg[i]]
            if not selected_preset then
                ObfusQ.MessageLogger:error(string.format("Preset \"%s\" not found!", tostring(arg[i])))
            end
            active_config = selected_preset
        elseif current_arg == "--config" or current_arg == "--c" then
            i = i + 1
            local cfg_filename = tostring(arg[i])
            if not check_file(cfg_filename) then
                ObfusQ.MessageLogger:error(string.format("Config file \"%s\" not found!", cfg_filename))
            end
            local cfg_content = table.concat(read_file_lines(cfg_filename), "\n")
            local cfg_func = loadstring(cfg_content)
            setfenv(cfg_func, {})
            active_config = cfg_func()
        elseif current_arg == "--out" or current_arg == "--o" then
            i = i + 1
            if output_file then
                ObfusQ.MessageLogger:warn("Output file specified multiple times")
            end
            output_file = arg[i]
        elseif current_arg == "--nocolors" then
            ObfusQ.ConsoleColors.enabled = false
        elseif current_arg == "--LuaU" then
            target_luau_version = "LuaU"
        elseif current_arg == "--pretty" then
            should_pretty_print = true
        elseif current_arg == "--saveerrors" then
            ObfusQ.MessageLogger.errorCallback = function(...)
                print(ObfusQ.ConsoleColors(ObfusQ.GlobalConfig.NameUpper .. ": " .. ..., "red"))
                local message = table.concat({...}, " ")
                local error_file = input_file:sub(-4) == ".lua" and input_file:sub(0, -5) .. ".error.txt" or input_file .. ".error.txt"
                local handle = io.open(error_file, "w")
                handle:write(message)
                handle:close()
                os.exit(1)
            end
        else
            ObfusQ.MessageLogger:warn(string.format("Option \"%s\" is not recognized", current_arg))
        end
    else
        if input_file then
            ObfusQ.MessageLogger:error(string.format("Unexpected argument \"%s\"", arg[i]))
        end
        input_file = tostring(arg[i])
    end
    i = i + 1
end

if not input_file then
    ObfusQ.MessageLogger:error("No input file specified")
end

if not active_config then
    ObfusQ.MessageLogger:warn("No config specified, using RobloxMedium preset")
    active_config = ObfusQ.PresetConfigs.RobloxMedium
end

active_config.LuaVersion = target_luau_version or active_config.LuaVersion
active_config.PrettyPrint = should_pretty_print ~= nil and should_pretty_print or active_config.PrettyPrint

if not check_file(input_file) then
    ObfusQ.MessageLogger:error(string.format("File \"%s\" not found", input_file))
end

if not output_file then
    if input_file:sub(-4) == ".lua" then
        output_file = input_file:sub(0, -5) .. ".obfuscated.lua"
    else
        output_file = input_file .. ".obfuscated.lua"
    end
end

local source_code = table.concat(read_file_lines(input_file), "\n")
local processing_pipeline = ObfusQ.ProcessingPipeline:fromConfig(active_config)
local obfuscated_code = processing_pipeline:apply(source_code, input_file)
ObfusQ.MessageLogger:info(string.format("Writing output to \"%s\"", output_file))

local handle = io.open(output_file, "w")
handle:write(obfuscated_code)
handle:close()

