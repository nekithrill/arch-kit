local home = os.getenv("HOME")
local base = home .. "/.config/hypr/hyprland/"

-- load helper
local function load(path)
    local ok, err = pcall(dofile, path)
    if not ok then
        print("[Hypr config error]: " .. path .. "\n" .. err)
    end
end

-- 0. ENVIRONMENT
load(base .. "env.lua")
-- load(base .. "env-nvidia.lua")

-- 1. CORE DATA (must be first)
load(base .. "variables.lua")
load(base .. "themes.lua")

-- 2. HARDWARE / INPUT
load(base .. "monitors.lua")
load(base .. "input.lua")

-- 3. WM BEHAVIOR
load(base .. "rules.lua")
load(base .. "keybindings.lua")
load(base .. "misc.lua")

-- 4. VISUAL LAYER
load(base .. "appearance.lua")
load(base .. "animations.lua")

-- 5. SERVICES (last)
load(base .. "autostart.lua")