_addon.name    = 'auto_corsair_ws'
_addon.author  = 'TheGwardian'
_addon.version = '2.1'
_addon.commands = {'corsws','acws'}

-- Localize frequently-used functions for faster access
local ffxi_get_player  = windower.ffxi.get_player
local send_command     = windower.send_command
local register_event   = windower.register_event
local os_clock         = os.clock
local string_format    = string.format

-- Load texts library for status display
local texts = require('texts')

-- Player reference
local player = nil

-- ###################### USER CONFIGURATION SECTION ######################

local tp_threshold  = 2750           -- Minimum TP to trigger WS
local wait_after_ws = 1              -- Seconds before party announce
local ws_name       = 'Last Stand'   -- Weaponskill name
local ws_cooldown   = 1.0            -- Min seconds between WS triggers

-- ###################### END USER CONFIGURATION ###########################

local ws_command    = nil
local last_ws_time  = 0

-- Create status display window
local status_display = texts.new('${current_content}', {
    pos = {
        x = 0,
        y = 200
    },
    bg = {
        alpha = 200,
        red = 0,
        green = 0,
        blue = 0,
        visible = true
    },
    flags = {
        bold = true,
        draggable = true
    },
    text = {
        size = 10,
        font = 'Consolas',
        alpha = 255,
        red = 255,
        green = 255,
        blue = 255
    },
    padding = 8
})

-- Update display text
local function update_display()
    local current_tp = 0
    if player and player.vitals then
        current_tp = player.vitals.tp or 0
    end
    
    local display_text = string_format(
        'Auto Corsair WS\n' ..
        '─────────────────────\n' ..
        'WS: %s\n' ..
        'TP Threshold: %d\n' ..
        'Current TP: %d\n' ..
        '─────────────────────',
        ws_name,
        tp_threshold,
        current_tp
    )
    
    status_display.current_content = display_text
end

-- Weaponskill name mapping (short name -> full name)
local ws_map = {
    -- Marksmanship Weaponskills (Corsair-accessible)
    hotshot       = "Hot Shot",
    splitshot     = "Split Shot",
    snipershot    = "Sniper Shot",
    slugshot      = "Slug Shot",
    detonator     = "Detonator",
    numbingshot   = "Numbing Shot",
    laststand     = "Last Stand",
    coronach      = "Coronach",
    wildfire      = "Wildfire",
    leaden        = "Leaden Salute",
    terminus      = "Terminus",
    
    -- Sword Weaponskills
    savage        = "Savage Blade",
    sang          = "Sanguine Blade",
    req           = "Requiescat",
    chant         = "Chant du Cygne",
    vorpal        = "Vorpal Blade",
    swift         = "Swift Blade",
    circle        = "Circle Blade",
    rlb           = "Red Lotus Blade",
    seraph        = "Seraph Blade",
    shining       = "Shining Blade",
    fast          = "Fast Blade",
    flat          = "Flat Blade",
}

-- Build the weaponskill command with party announce
local function rebuild_ws_command()
    if not ws_name or ws_name == "" then
        return
    end
    ws_command = string_format('input /ws "%s" <t>; wait %d; input /p %s -> <t>',
        ws_name, wait_after_ws, ws_name)
end

-- Execute weaponskill
local function execute_ws()
    send_command(ws_command)
    last_ws_time = os_clock()
end

-- Main logic: Check TP and trigger WS when ready
register_event('prerender', function()
    -- Fetch player fresh each frame
    player = ffxi_get_player()
    
    if not player then
        return
    end

    -- Update display every frame
    update_display()

    -- Only WS if engaged (status == 1)
    if player.status ~= 1 then
        return
    end

    -- Check cooldown first
    if (os_clock() - last_ws_time) < ws_cooldown then
        return
    end

    -- Check TP threshold
    local vitals = player.vitals
    if not vitals then
        return
    end
    
    local tp = vitals.tp
    if tp and tp >= tp_threshold then
        execute_ws()
    end
end)

--------------------------------------------------------------------------------
-- Handle chat commands: set threshold, show status, or help
--------------------------------------------------------------------------------
register_event('addon command', function(cmd, ...)
    if not cmd then
        windower.add_to_chat(207, '[auto_corsair_ws] Current WS: ' .. ws_name)
        windower.add_to_chat(207, '[auto_corsair_ws] Usage: //acws <ws_name> or //acws status')
        return
    end
    
    cmd = cmd:lower()
    
    if cmd == 'status' then
        windower.add_to_chat(207, '[auto_corsair_ws] Current WS: ' .. ws_name)
        windower.add_to_chat(207, '[auto_corsair_ws] TP Threshold: ' .. tp_threshold)
        windower.add_to_chat(207, '[auto_corsair_ws] Cooldown: ' .. ws_cooldown .. 's')
        return
    end
    
    -- Check if it's a short name in the map
    local new_ws = ws_map[cmd]
    
    -- If not in map, treat as full weaponskill name
    if not new_ws then
        new_ws = table.concat({cmd, ...}, ' ')
        -- Capitalize first letter of each word
        new_ws = new_ws:gsub("(%a)([%w_']*)", function(first, rest)
            return first:upper() .. rest:lower()
        end)
    end
    
    ws_name = new_ws
    rebuild_ws_command()
    update_display()
    windower.add_to_chat(158, '[auto_corsair_ws] Weaponskill changed to: ' .. ws_name)
end)

-- Build command at load
rebuild_ws_command()

-- Show display on load
status_display:show()
update_display()

-- Reset cooldown on zone change
register_event('zone change', function()
    last_ws_time = 0
end)
