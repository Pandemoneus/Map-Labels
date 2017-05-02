require "config"


local floor = math.floor

local ChunkSize = 32
local RegionSizeInChunks = math.min(math.max(2, RegionSize), 256)
local RegionOffsetInChunks = floor(RegionSizeInChunks / 2)
local RegionSizeInTiles = RegionSizeInChunks * ChunkSize
local RegionOffsetInTiles = RegionOffsetInChunks * ChunkSize
local SearchRadius = math.min(math.max(2, ResourceFieldSearchRadius), 20)
local SearchMin = -SearchRadius
local SearchMax = ResourceFieldSearchAllDirections and SearchRadius or 0


local function ResourceNameToDisplayName(resourceName)
  local s = ResourceDisplayName[resourceName]
  if not s then
    s, _ = string.gsub(resourceName, "(%W+)", " ")
    s, _ = string.gsub(s, "^(%w)", string.upper)
  end
  return s
end


local function AddChunkToRegions( chunk, regions )
  local regionX = floor((chunk.x - RegionOffsetInChunks) / RegionSizeInChunks)
  local regionY = floor((chunk.y - RegionOffsetInChunks) / RegionSizeInChunks)
  local regionKey = regionX .. "|" .. regionY
  local region = regions[regionKey]
  if not region then
    region = {x = regionX, y = regionY, chunks = {}}
    regions[regionKey] = region
  end

  local chunkX = chunk.x - RegionOffsetInChunks - regionX * RegionSizeInChunks
  local chunkY = chunk.y - RegionOffsetInChunks - regionY * RegionSizeInChunks
  local chunkKey = RegionSizeInChunks * chunkX + chunkY
  region.chunks[chunkKey] = true
end


local function AddTileToRegion(originX, originY, entity, tiles, fields)
  local tileX = floor(entity.position.x + 0.5) - originX
  local tileY = floor(entity.position.y + 0.5) - originY
  local tileKey = RegionSizeInTiles * tileX + tileY
  if tiles[tileKey] then return end
  local field = nil

  for dx = SearchMin, SearchMax do
    for dy = SearchMin, SearchMax do
      if dx ~= 0 or dy ~= 0 then
        local neighborKey = tileKey + RegionSizeInTiles * dx + dy
        local neighborField = tiles[neighborKey]
        if neighborField then

          if not field then
            field = neighborField
            field[#field + 1] = tileKey
            tiles[tileKey] = field

          elseif field ~= neighborField then
            for i = 1, #neighborField do
              local otherKey = neighborField[i]
              field[#field + 1] = otherKey
              tiles[otherKey] = field
              neighborField.ignore = true
            end
          end

        end
      end
    end
  end

  if not field then
    field = {tileKey}
    tiles[tileKey] = field
    fields[#fields + 1] = field
  end
end


local function CreateMapLabelsForRegion(surface, region, resourceName, displayName)
  local originX = RegionSizeInTiles * region.x + RegionOffsetInTiles
  local originY = RegionSizeInTiles * region.y + RegionOffsetInTiles
  local tiles = {}
  local fields = {}

  for chunkKey,_ in pairs(region.chunks) do
    local chunkX = floor(chunkKey / RegionSizeInChunks)
    local chunkY = chunkKey - RegionSizeInChunks * chunkX
    local x = originX + ChunkSize * chunkX
    local y = originY + ChunkSize * chunkY
    for _, entity in ipairs(surface.find_entities_filtered({name = resourceName, area = {{x, y}, {x + ChunkSize - 1, y + ChunkSize - 1}}})) do
      AddTileToRegion(originX, originY, entity, tiles, fields)
    end
  end

  for i = 1, #fields do
    local field = fields[i]
    if not field.ignore then
      local centroidX = 0
      local centroidY = 0
      local tileCount = #field
      for j = 1, tileCount do
        local tileKey = field[j]
        local tileX = floor(tileKey / RegionSizeInTiles)
        local tileY = tileKey - RegionSizeInTiles * tileX
        centroidX = centroidX + tileX
        centroidY = centroidY + tileY
      end
      local position = {originX + floor(centroidX / tileCount + 0.5), originY + floor(centroidY / tileCount + 0.5)}
      
      local chartTag = {position = position}
      
      local showResourceIcon = settings.global["map-labels-show-resource-icon"].value
      local showResourceName = settings.global["map-labels-show-resource-name"].value
      
      if showResourceIcon then
        local prototype = game.entity_prototypes[resourceName]
        local signalType = nil
          
        if prototype then
          if prototype.type == "resource" then
            if prototype.resource_category == "basic-fluid" and game.fluid_prototypes[resourceName] ~= nil then
              signalType = "fluid"
            elseif prototype.resource_category == "basic-solid" and game.item_prototypes[resourceName] ~= nil then
              signalType = "item"
            end
          end
        end
        
        if signalType ~= nil then
          local signalID = {type = signalType, name = resourceName}
          chartTag.icon = signalID
        end
      end
      
      if showResourceName then
        chartTag.text = displayName
      end

      if showResourceIcon or showResourceName then
        game.forces.player.add_chart_tag(surface.name, chartTag)
      end
    end
  end
end


local function CreateMapLabels()
  for _, surface in pairs(game.surfaces) do
    local regions = {}
    for chunk in surface.get_chunks() do
      if game.forces.player.is_chunk_charted(surface, chunk) then
        AddChunkToRegions(chunk, regions)
      end
    end

    for _, proto in pairs(game.entity_prototypes) do
      if proto.type == "resource" then
        local resourceName = proto.name
        local displayName = ResourceNameToDisplayName(resourceName)
        if displayName ~= "" then
          for _, region in pairs(regions) do
            CreateMapLabelsForRegion(surface, region, resourceName, displayName)
          end
        end
      end
    end
  end
end


local function DestroyMapLabels()
  for _, surface in pairs(game.surfaces) do
    for chunk in surface.get_chunks() do
      local x = ChunkSize * chunk.x
      local y = ChunkSize * chunk.y
      for _, chartTag in ipairs(game.forces.player.find_chart_tags(surface.name, {{x,y}, {x + ChunkSize, y + ChunkSize}})) do
        if not chartTag.last_user then
          chartTag.destroy()
        end
      end
    end
  end
end


local function InitPlayer(player)
  local gui = player.gui
  
  if settings.get_player_settings(player)["map-labels-show-button"].value then
    if not gui.top.MapLabelButton then
      gui.top.add{type="button", name = "MapLabelButton", caption = "Map Labels"}
    end
  else
    if gui.top.MapLabelButton then
      gui.top.MapLabelButton.destroy()
    end
  end
end

script.on_init( function(event)
  global.HaveMapLabels = false
  for _, player in ipairs(game.players) do
    InitPlayer(player)
  end
end)

script.on_event(defines.events.on_player_created, function(event)
  InitPlayer(game.players[event.player_index])
end)

script.on_configuration_changed(function(event)
  global.HaveMapLabels = false
  for _, player in pairs(game.players) do
    InitPlayer(player)
  end
end)

script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
  if event.setting == "map-labels-show-button" then
    InitPlayer(game.players[event.player_index])
  end
end)

local function toggleMapLables()
  if global.HaveMapLabels then
    DestroyMapLabels()
    global.HaveMapLabels = false
  else
    CreateMapLabels()
    global.HaveMapLabels = true
  end
end

script.on_event("map-labels-hotkey-toggle", function(event)
  toggleMapLables()
end)

script.on_event(defines.events.on_gui_click, function(event)
  if event.element.name == "MapLabelButton" then
    toggleMapLables()
  end
end)
