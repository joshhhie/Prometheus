return {
    -- Target Roblox's Luau
    LuaVersion = "LuaU";
    -- Random variable prefix
    VarNamePrefix = "";
    -- Use difficult to read variable names
    NameGenerator = "MangledShuffled";
    -- Compact output
    PrettyPrint = false;
    -- Random seed
    Seed = 0;
    
    Steps = {
        {
            Name = "SplitStrings";
            Settings = {
                
            }
        },
        {
            Name = "Vmify";
            Settings = {
                -- Virtualizing the code is a strong obfuscation technique
            };
        },
        {
            Name = "EncryptStrings";
            Settings = {
                -- Encrypt strings to hide them
            };
        },
        {
            Name = "AntiTamper";
            Settings = {
                -- Prevent modification
                UseDebug = false;
            };
        },
        {
            Name = "ConstantArray";
            Settings = {
                Treshold    = 1;
                StringsOnly = false; -- Also include numbers if possible
                Shuffle     = true;
                Rotate      = true;
                LocalWrapperTreshold = 1;
            }
        },
        {
            Name = "NumbersToExpressions";
            Settings = {
                -- Turn simple numbers into complex math expressions
            }
        },
        {
            Name = "ProxifyLocals";
            Settings = {
                -- Hide local variables
            }
        },
    }
}
