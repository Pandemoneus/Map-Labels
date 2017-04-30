-- Size of a region, in chunks (default is 56 to be a multiple of RSO's value)

RegionSize = 56



-- Search radius for finding neighbors in the same resource field (default is 1, max is 20 which is rather slow)

ResourceFieldSearchRadius = 20



-- Whether to search in all directions (default is false, not needed if find_entities_filtered returns results sorted by position)

ResourceFieldSearchAllDirections = false



-- Preferred names for resources on map, or blank to hide (default is to replace non-alphanumeric characters with space, upper-case the first letter, and prepend a tilde)

ResourceDisplayName = {}

-- Bob's Ores
ResourceDisplayName["gold-ore"] = "Gold"
ResourceDisplayName["lead-ore"] = "Galena"
ResourceDisplayName["silver-ore"] = "Silver"
ResourceDisplayName["tin-ore"] = "Tin"
ResourceDisplayName["tungsten-ore"] = "Tungsten"
ResourceDisplayName["zinc-ore"] = "Zinc"
ResourceDisplayName["bauxite-ore"] = "Bauxite"
ResourceDisplayName["rutile-ore"] = "Rutile"
ResourceDisplayName["nickel-ore"] = "Nickel"
ResourceDisplayName["cobalt-ore"] = "Cobaltite"
ResourceDisplayName["quartz"] = "Quartz"
ResourceDisplayName["sulfur"] = "Sulfur"
ResourceDisplayName["gem-ore"] = "Gemstones"

-- Angel's Infinite Ores
ResourceDisplayName["infinite-iron-ore"] = ""
ResourceDisplayName["infinite-copper-ore"] = ""
ResourceDisplayName["infinite-coal"] = ""
ResourceDisplayName["infinite-stone"] = ""
ResourceDisplayName["infinite-bauxite-ore"] = ""
ResourceDisplayName["infinite-cobalt-ore"] = ""
ResourceDisplayName["infinite-zinc-ore"] = ""
ResourceDisplayName["infinite-tin-ore"] = ""
ResourceDisplayName["infinite-quartz"] = ""
ResourceDisplayName["infinite-gem-ore"] = ""
ResourceDisplayName["infinite-gold-ore"] = ""
ResourceDisplayName["infinite-lead-ore"] = ""
ResourceDisplayName["infinite-nickel-ore"] = ""
ResourceDisplayName["infinite-rutile-ore"] = ""
ResourceDisplayName["infinite-silver-ore"] = ""
ResourceDisplayName["infinite-sulfur"] = ""
ResourceDisplayName["infinite-tungsten-ore"] = ""
ResourceDisplayName["infinite-uranium-ore"] = ""

-- Angel's Ores
ResourceDisplayName["angels-fissure"] = "Fissure"
ResourceDisplayName["angels-ore1"] = "Saphirite"
ResourceDisplayName["infinite-angels-ore1"] = ""
ResourceDisplayName["angels-ore2"] = "Jivolite"
ResourceDisplayName["infinite-angels-ore2"] = ""
ResourceDisplayName["angels-ore3"] = "Stiratite"
ResourceDisplayName["infinite-angels-ore3"] = ""
ResourceDisplayName["angels-ore4"] = "Crotinnium"
ResourceDisplayName["infinite-angels-ore4"] = ""
ResourceDisplayName["angels-ore5"] = "Rubyte"
ResourceDisplayName["infinite-angels-ore5"] = ""
ResourceDisplayName["angels-ore6"] = "Bobmonium"
ResourceDisplayName["infinite-angels-ore6"] = ""
ResourceDisplayName["angels-natural-gas"] = "Gas"

ResourceDisplayName["crude-oil" ] = "Oil"

ResourceDisplayName["iron-ore"] = "Iron"
ResourceDisplayName["copper-ore"] = "Copper"
ResourceDisplayName["stone"] = "Stone"
ResourceDisplayName["uranium-ore"] = "Uranium"