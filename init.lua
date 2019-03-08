-- DEFINE On WHICH AXE THE MOD SHOULD DECIDE
local VARIABLE = "x"

-- DEFINE HERE COLORS
local colors ={}
colors["Transition Zone"] = 0x0000FF -- Blue
colors["Building Zone"] = 0x00FF00 -- Green
colors["Farming Zone"] = 0xFF0000 -- Red

-- DEFINE HERE UPDATE INTERVAL IN SECONDS:
local INTERVAL = 2

local hud = {}
local current_zone = {}
local old_zone = {}
local delta = 0



function buildingfarmingzone_define(player)
  local position = player:get_pos()
  -- DEFINE HERE THE COORDINATES YOU COULD ALSO CHANGE THE NAMES HERE (BUT THEN YOU HAVE TO CHANGE THE NAMES at "colors[....]" too!!!!)
  -- IF YOU DONT WANT TO HAVE NO TRANSITION ZONE THEN CHANGE THE SECOND VARIABLE FROM IF TO 0
  if position[VARIABLE] > -200 and position[VARIABLE] < 200 then
    return "Transition Zone"
  elseif position[VARIABLE] >= 200 then
    return "Building Zone"
  else -- < 0
    return "Farming Zone"
  end
end

minetest.register_on_joinplayer(function(player)
  hud[player] = player:hud_add({
    hud_elem_type = "text",
    name = "Zones",
    number = 0xFF0000,
    position = {x=1, y=1},
    offset = {x=-120, y=-10},
    text = "",
    scale = {x=200, y=60},
    alignment = {x=1, y=-1},
  })
end)

minetest.register_on_leaveplayer(function(player)
  player:hud_remove("Zones")
  hud[player] = nil
  current_zone[player] = nil
    old_zone[player] = nil
end)



minetest.register_globalstep(function(dtime)
  if delta > INTERVAL then
    for _, player in pairs(minetest.get_connected_players()) do
      current_zone[player] = buildingfarmingzone_define(player)
      if current_zone[player] ~= old_zone[player] then
        player:hud_change(hud[player] , "text", current_zone[player])
        player:hud_change(hud[player] , "number", colors[current_zone[player]])
        old_zone[player] = current_zone[player]
      end
    end
    delta = 0
  else
    delta = delta + dtime
  end
end)
