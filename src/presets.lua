-- ObfusQ - Roblox Luau Obfuscator Presets
-- Modified for full LuaU compatibility and Roblox environments

return {
    ["Minify"] = {
        -- LuaU for Roblox compatibility
        LuaVersion = "LuaU";
        VarNamePrefix = "";
        NameGenerator = "ConfuseMangled";
        PrettyPrint = false;
        Seed = 0;
        Steps = {}
    };
    ["RobloxLight"] = {
        -- LuaU for Roblox compatibility
        LuaVersion = "LuaU";
        VarNamePrefix = "";
        NameGenerator = "ConfuseMangled";
        PrettyPrint = false;
        Seed = 0;
        Steps = {
            {
                Name = "ConstantArray";
                Settings = {
                    Treshold    = 1;
                    StringsOnly = true;
                    Shuffle     = true;
                }
            },
            {
                Name = "WrapInFunction";
                Settings = {}
            },
        }
    };
    ["RobloxMedium"] = {
        -- LuaU for Roblox compatibility
        LuaVersion = "LuaU";
        VarNamePrefix = "";
        NameGenerator = "ConfuseMangled";
        PrettyPrint = false;
        Seed = 0;
        Steps = {
            {
                Name = "EncryptStrings";
                Settings = {};
            },
            {
                Name = "ConstantArray";
                Settings = {
                    Treshold    = 1;
                    StringsOnly = true;
                    Shuffle     = true;
                    Rotate      = true;
                    LocalWrapperTreshold = 0;
                }
            },
            {
                Name = "NumbersToExpressions";
                Settings = {}
            },
            {
                Name = "WrapInFunction";
                Settings = {}
            },
        }
    };
    ["RobloxStrong"] = {
        -- LuaU for Roblox compatibility
        LuaVersion = "LuaU";
        VarNamePrefix = "";
        NameGenerator = "ConfuseMangled";
        PrettyPrint = false;
        Seed = 0;
        Steps = {
            {
                Name = "EncryptStrings";
                Settings = {};
            },
            {
                Name = "ConstantArray";
                Settings = {
                    Treshold    = 2;
                    StringsOnly = false;
                    Shuffle     = true;
                    Rotate      = true;
                    LocalWrapperTreshold = 1;
                }
            },
            {
                Name = "ProxifyLocals";
                Settings = {}
            },
            {
                Name = "NumbersToExpressions";
                Settings = {}
            },
            {
                Name = "WrapInFunction";
                Settings = {}
            },
        }
    },
}

