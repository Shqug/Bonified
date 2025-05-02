
bonified = {modpath = core.get_modpath 'bonified'}
local S = core.get_translator 'bonified'

-- New mesh appearance for bones + rename to bone pile
core.override_item('bones:bones', {
	description = S 'Pile of Bones',
	drawtype = 'mesh',
	mesh = 'bonified_bone_pile.obj',
	tiles = {'bonified_bone_pile_base.png', 'bonified_bone_pile.png'},
	use_texture_alpha = 'clip',
	paramtype = 'light',
	paramtype2 = '4dir',
	sunlight_propagates = true,
	
	collision_box = {
		type = 'fixed',
		fixed = {-0.5, -0.5, -0.5, 0.5, -4/16, 0.5}
	}
})

-- Bone item
core.register_craftitem('bonified:bone', {
	description = S 'Bone',
	inventory_image = 'bonified_bone.png',
	groups = {bone = 1}
})

core.register_craft {
	type = 'shapeless',
	output = 'bonified:bone 6',
	recipe = {'bones:bones'}
}

core.register_craft {
	output = 'bones:bones',
	recipe = {
		{'bonified:bone', 'bonified:bone', 'bonified:bone'},
		{'bonified:bone', 'bonified:bone', 'bonified:bone'}
	}
}

-- Dropping bones from soils
local soils = {
	{'default:dirt', 30},
	{'default:dirt_with_grass', 30},
	{'default:dirt_with_coniferous_litter', 30},
	{'default:dirt_with_rainforest_litter', 24},
	{'default:dirt_with_snow', 30},
	{'default:dry_dirt', 26},
	{'default:dry_dirt_with_dry_grass', 26},
	{'default:gravel', 26},
	{'default:sand', 30},
	{'default:desert_sand', 24},
	{'default:silver_sand', 20},
	{'default:clay', 18},
	{'default:permafrost', 16}
}

for _, v in ipairs(soils) do
	local old_drop = core.registered_nodes[v[1]].drop
	local new_drop
	
	if old_drop then
		if type(old_drop) == 'table' then
			new_drop = table.copy(old_drop)
			
			table.insert(new_drop.items, 1, {items = {'bonified:bone 3'}, rarity = math.ceil(v[2] * 1.75)})
			table.insert(new_drop.items, 2, {items = {'bonified:bone'}, rarity = v[2]})
		else
			new_drop = {
				max_items = 1,
				items = {
					{items = {'bonified:bone 3'}, rarity = math.ceil(v[2] * 1.75)},
					{items = {'bonified:bone'}, rarity = v[2]},
					{items = {old_drop}}
				}
			}
		end
	else
		new_drop = {
			max_items = 1,
			items = {
				{items = {'bonified:bone 3'}, rarity = math.ceil(v[2] * 1.75)},
				{items = {'bonified:bone'}, rarity = v[2]},
				{items = {v[1]}}
			}
		}
	end
	
	core.override_item(v[1], {drop = new_drop})
end

-- Bone block
core.register_node('bonified:bone_block', {
	description = S 'Bone Block',
	tiles = {'bonified_bone_block.png'},
	groups = {oddly_breakable_by_hand = 1, crumbly = 3},
	sounds = default.node_sound_gravel_defaults()
})

core.register_craft {
	type = 'shapeless',
	output = 'bonified:bone 4',
	recipe = {'bonified:bone_block'}
}

core.register_craft {
	output = 'bonified:bone_block',
	recipe = {
		{'bonified:bone', 'bonified:bone'},
		{'bonified:bone', 'bonified:bone'}
	}
}

-- Bonemeal & Fertilizer
-- Strength is the chance (0-1) to instantly advance a growth stage
-- For crops this is rerolled until failure or 5 times, whichever is lower
-- For saplings this value is halved
if core.settings: get_bool('bonified.enable_bone_meal', true) and core.get_modpath 'farming' then
	function bonified.apply_fertilizer (strength)
		return function (itemstack, player, pointed)
			if core.is_protected(player: get_player_name(), pointed.under) then
				core.record_protection_violation(player: get_player_name(), pointed.under)
				return itemstack
			end
			
			if pointed.type == 'node' then
				local name = core.get_node(pointed.under).name
			
				if core.get_item_group(name, 'sapling') ~= 0 then
					itemstack: take_item()
					
					if math.random() <= strength * 0.5 then
						default.grow_sapling(pointed.under)
						
						for i = 1, math.random(6,12) do
							core.add_particle {
								pos = pointed.under + vector.new((math.random() - 0.5) * 2, (math.random() - 0.66) * 0.3, (math.random() - 0.5) * 2),
								velocity = vector.new(0, 3, 0),
								acceleration = vector.new(0, -5, 0),
								expirationtime = 0.35,
								glow = 5,
								size = 1,
								texture = 'bonified_fertilize_particle.png'
							}
						end
					end
					
					return itemstack
				end
				
				if (core.get_item_group(name, 'plant') ~= 0 or core.get_item_group(name, 'seed') ~= 0)
				and core.registered_nodes[name].next_plant then
					itemstack: take_item()
					
					local rolls = 0
					while math.random() <= strength and rolls < 6 do
						farming.grow_plant(pointed.under)
						
						for i = 1, math.random(3,5) do
							core.add_particle {
								pos = pointed.under + vector.new(math.random() - 0.5, (math.random() - 0.66) * 0.3, math.random() - 0.5),
								velocity = vector.new(0, 3, 0),
								acceleration = vector.new(0, -5, 0),
								expirationtime = 0.35,
								glow = 5,
								size = 1,
								texture = 'bonified_fertilize_particle.png'
							}
						end
						
						rolls = rolls + 1
					end
					
					return itemstack
				end
			end
		end
	end
	
	core.register_craftitem('bonified:bone_meal', {
		description = S 'Bone Meal',
		inventory_image = 'bonified_bone_meal.png',
		on_use = bonified.apply_fertilizer(core.settings: get 'bonified.bone_meal_strength' or 0.25)
	})
	
	core.register_craft {
		type = 'shapeless',
		output = 'bonified:bone_meal 4',
		recipe = {'bonified:bone'}
	}
	
	if core.get_modpath 'dye' then
		core.register_craft {
			type = 'shapeless',
			output = 'dye:white',
			recipe = {'bonified:bone_meal'}
		}
	end
	
	core.register_craftitem('bonified:fertilizer', {
		description = S 'Fertilizer',
		inventory_image = 'bonified_fertilizer.png',
		on_use = bonified.apply_fertilizer(core.settings: get 'bonified.fertilizer_strength' or 0.65)
	})
	
	if core.get_modpath 'flowers' then
			core.register_craft {
				type = 'shapeless',
				output = 'bonified:fertilizer 4',
				recipe = {'bonified:bone_meal', 'bonified:bone_meal', 'group:leaves', 'flowers:mushroom_brown'}
			}
	else
		core.register_craft {
			type = 'shapeless',
			output = 'bonified:fertilizer 4',
			recipe = {'bonified:bone_meal', 'bonified:bone_meal', 'group:leaves', 'default:clay'}
		}
	end
end

-- Bone tools
-- The gimmick of bone tools is they have similar durability to steel and start out slightly worse,
-- but as they wear down they become more effective.
if core.settings: get_bool('bonified.enable_bone_tools', true) then
	local last_bt_update = os.time()
	
	core.register_globalstep(function (dtime)
		if os.time() - last_bt_update >= 1.5 then
			for _, player in ipairs(core.get_connected_players()) do
				local itemstack = player: get_wielded_item()
				if core.get_item_group(itemstack: get_name(), 'bone_tool') ~= 0 then
					-- Approaches 0.5 as wear maxes out
					local wear_diff_ratio_inverse = (65535 - (itemstack: get_wear() * 0.5)) / 65535
					-- Approaches 2
					local wear_diff_ratio = 1 / wear_diff_ratio_inverse
					
					local caps = itemstack: get_definition().tool_capabilities
					
					local new_groupcaps = {}
					for name, group in pairs(caps.groupcaps) do
						local new_times = {}
						
						for i, t in ipairs(group.times) do
							new_times[i] = t * wear_diff_ratio_inverse
						end
						
						new_groupcaps[name] = {times = new_times, uses = group.uses, maxlevel = group.maxlevel}
					end
					
					itemstack: get_meta(): set_tool_capabilities {
						max_drop_level = caps.max_drop_level,
						full_punch_interval = caps.full_punch_interval * wear_diff_ratio_inverse,
						groupcaps = new_groupcaps,
						damage_groups = new_damage_groups
					}
					
					player: set_wielded_item(itemstack)
				end
			end
			
			last_bt_update = os.time()
		end
	end)

	function bonified.register_bone_tool(name, def)
		def.groups = def.groups or {}
		def.groups.bone_tool = 1
		
		def.wear_color = {
			blend = 'linear',
			color_stops = {
				[0.0] = '#ff0044',
				[0.5] = '#ff9539',
				[1.0] = '#ffe5a4'
			}
		}
		
		core.register_tool(name, def)
	end
	
	bonified.register_bone_tool('bonified:tool_pick_bone', {
		description = S 'Bone Pickaxe',
		inventory_image = 'bonified_pick_bone.png',
		tool_capabilities = {
			full_punch_interval = 1.0,
			max_drop_level=1,
			groupcaps={
				cracky = {times={[1]=4.50, [2]=1.80, [3]=0.90}, uses=30, maxlevel=2},
			},
			damage_groups = {fleshy=4},
		},
		sound = {breaks = 'default_tool_breaks'},
		groups = {pickaxe = 1}
	})
	
	core.register_craft {
		output = 'bonified:tool_pick_bone',
		recipe = {
			{'bonified:bone_block', 'bonified:bone_block', 'bonified:bone_block'},
			{'', 'default:stick', ''},
			{'', 'default:stick', ''}
		}
	}
	
	bonified.register_bone_tool('bonified:tool_shovel_bone', {
		description = S 'Bone Shovel',
		inventory_image = 'bonified_shovel_bone.png',
		wield_image = 'bonified_shovel_bone.png^[transformR90',
		tool_capabilities = {
			full_punch_interval = 1.1,
			max_drop_level=1,
			groupcaps={
				crumbly = {times={[1]=1.65, [2]=1.05, [3]=0.45}, uses=35, maxlevel=2},
			},
			damage_groups = {fleshy=3},
		},
		sound = {breaks = 'default_tool_breaks'},
		groups = {shovel = 1}
	})
	
	core.register_craft {
		output = 'bonified:tool_shovel_bone',
		recipe = {
			{'', 'bonified:bone_block', ''},
			{'', 'default:stick', ''},
			{'', 'default:stick', ''}
		}
	}
	
	bonified.register_bone_tool('bonified:tool_axe_bone', {
		description = S 'Bone Axe',
		inventory_image = 'bonified_axe_bone.png',
		tool_capabilities = {
			full_punch_interval = 1.0,
			max_drop_level=1,
			groupcaps={
				choppy={times={[1]=2.75, [2]=1.70, [3]=1.15}, uses=30, maxlevel=2},
			},
			damage_groups = {fleshy=4},
		},
		sound = {breaks = 'default_tool_breaks'},
		groups = {axe = 1}
	})
	
	core.register_craft {
		output = 'bonified:tool_axe_bone',
		recipe = {
			{'bonified:bone_block', 'bonified:bone_block', ''},
			{'bonified:bone_block', 'default:stick', ''},
			{'', 'default:stick', ''}
		}
	}
	
	bonified.register_bone_tool('bonified:tool_sword_bone', {
		description = S 'Bone Sword',
		inventory_image = 'bonified_sword_bone.png',
		tool_capabilities = {
			full_punch_interval = 0.8,
			max_drop_level=1,
			groupcaps={
				snappy={times={[1]=2.75, [2]=1.30, [3]=0.375}, uses=30, maxlevel=2},
			},
			damage_groups = {fleshy=6},
		},
		sound = {breaks = 'default_tool_breaks'},
		groups = {sword = 1}
	})
	
	core.register_craft {
		output = 'bonified:tool_sword_bone',
		recipe = {
			{'', 'bonified:bone_block', ''},
			{'', 'bonified:bone_block', ''},
			{'', 'default:stick', ''}
		}
	}
end

-- Stone & permafrost fossils
core.register_craftitem('bonified:fossil', {
	description = S 'Ancient Fossil',
	inventory_image = 'bonified_fossil.png'
})

local stone_fossil_def = table.copy(core.registered_nodes['default:stone'])
stone_fossil_def.tiles[1] = stone_fossil_def.tiles[1] .. '^bonified_fossil_ore.png'
stone_fossil_def.description = S 'Stone with Fossils'
stone_fossil_def.type = nil
stone_fossil_def.drop = {
	max_items = 3,
	items = {
		{items = {'bonified:fossil 2'}, rarity = 9},
		{items = {'bonified:bone 3'}, rarity = 6},
		{items = {'bonified:fossil'}, rarity = 5},
		{items = {'bonified:fossil'}, rarity = 3},
		{items = {'bonified:bone 2'}}
	}
}
core.register_node('bonified:stone_with_fossil', stone_fossil_def)

core.register_ore {
	ore_type       = 'scatter',
	ore            = 'bonified:stone_with_fossil',
	wherein        = 'default:stone',
	clust_scarcity = 24^3,
	clust_num_ores = 4,
	clust_size     = 3,
	y_max          = -150,
	y_min          = -300
}

local permafrost_fossil_def = table.copy(core.registered_nodes['default:permafrost'])
permafrost_fossil_def.tiles[1] = permafrost_fossil_def.tiles[1] .. '^bonified_fossil_ore.png'
permafrost_fossil_def.description = S 'Permafrost with Fossils'
permafrost_fossil_def.type = nil
permafrost_fossil_def.drop = {
	max_items = 3,
	items = {
		{items = {'bonified:fossil 2'}, rarity = 9},
		{items = {'bonified:bone 3'}, rarity = 6},
		{items = {'bonified:fossil'}, rarity = 5},
		{items = {'bonified:fossil'}, rarity = 3},
		{items = {'bonified:bone 2'}}
	}
}
core.register_node('bonified:permafrost_with_fossil', permafrost_fossil_def)

core.register_ore {
	ore_type       = 'scatter',
	ore            = 'bonified:permafrost_with_fossil',
	wherein        = {'default:permafrost', 'default:permafrost_with_stones'},
	clust_scarcity = 32^3,
	clust_num_ores = 7,
	clust_size     = 3,
	y_max          = 80,
	y_min          = 0
}

-- Fossil meal
if core.settings: get_bool('bonified.enable_bone_meal', true) then
	core.register_craftitem('bonified:fossil_meal', {
		description = S 'Fossil Meal',
		inventory_image = 'bonified_fossil_meal.png',
		on_use = bonified.apply_fertilizer(core.settings: get 'bonified.fossil_meal_strength' or 0.95)
	})

	core.register_craft {
		type = 'shapeless',
		output = 'bonified:fossil_meal 4',
		recipe = {'bonified:fossil'}
	}
end

-- Fossil block
core.register_node('bonified:fossil_block', {
	description = S 'Fossil Block',
	tiles = {'bonified_fossil_block.png'},
	groups = {oddly_breakable_by_hand = 1, crumbly = 3},
	sounds = default.node_sound_gravel_defaults()
})

core.register_craft {
	type = 'shapeless',
	output = 'bonified:fossil 4',
	recipe = {'bonified:fossil_block'}
}

core.register_craft {
	output = 'bonified:fossil_block',
	recipe = {
		{'bonified:fossil', 'bonified:fossil'},
		{'bonified:fossil', 'bonified:fossil'}
	}
}

-- Fossil tools
-- Fossil tools are basically just mese tools with more durability
if core.settings: get_bool('bonified.enable_fossil_tools', true) then
	core.register_tool('bonified:tool_pick_fossil', {
		description = S 'Ancient Pickaxe',
		inventory_image = 'bonified_pick_fossil.png',
		tool_capabilities = {
			full_punch_interval = 0.9,
			max_drop_level=3,
			groupcaps={
				cracky = {times={[1]=2.4, [2]=1.2, [3]=0.60}, uses=50, maxlevel=3},
			},
			damage_groups = {fleshy=5},
		},
		sound = {breaks = 'default_tool_breaks'},
		groups = {pickaxe = 1}
	})

	core.register_craft {
		output = 'bonified:tool_pick_fossil',
		recipe = {
			{'bonified:fossil', 'bonified:fossil_block', 'bonified:fossil'},
			{'', 'bonified:bone', ''},
			{'', 'bonified:bone', ''}
		}
	}
	
	core.register_tool('bonified:tool_shovel_fossil', {
		description = S 'Ancient Shovel',
		inventory_image = 'bonified_shovel_fossil.png',
		wield_image = 'bonified_shovel_fossil.png^[transformR90',
		tool_capabilities = {
			full_punch_interval = 1.0,
			max_drop_level=3,
			groupcaps={
				crumbly = {times={[1]=1.20, [2]=0.60, [3]=0.30}, uses=50, maxlevel=3},
			},
			damage_groups = {fleshy=4},
		},
		sound = {breaks = 'default_tool_breaks'},
		groups = {shovel = 1}
	})
	
	core.register_craft {
		output = 'bonified:tool_shovel_fossil',
		recipe = {
			{'', 'bonified:fossil_block', ''},
			{'', 'bonified:bone', ''},
			{'', 'bonified:bone', ''}
		}
	}
	
	core.register_tool('bonified:tool_axe_fossil', {
		description = S 'Ancient Axe',
		inventory_image = 'bonified_axe_fossil.png',
		tool_capabilities = {
			full_punch_interval = 0.9,
			max_drop_level=1,
			groupcaps={
				choppy={times={[1]=2.20, [2]=1.00, [3]=0.60}, uses=50, maxlevel=3},
			},
			damage_groups = {fleshy=6},
		},
		sound = {breaks = 'default_tool_breaks'},
		groups = {axe = 1}
	})
	
	core.register_craft {
		output = 'bonified:tool_axe_fossil',
		recipe = {
			{'bonified:fossil', 'bonified:fossil_block', ''},
			{'bonified:fossil', 'bonified:bone', ''},
			{'', 'bonified:bone', ''}
		}
	}
	
	core.register_tool('bonified:tool_sword_fossil', {
		description = S 'Ancient Sword',
		inventory_image = 'bonified_sword_fossil.png',
		tool_capabilities = {
			full_punch_interval = 0.45,
			max_drop_level=1,
			groupcaps={
				snappy={times={[1]=2.0, [2]=1.00, [3]=0.35}, uses=50, maxlevel=3},
			},
			damage_groups = {fleshy=7},
		},
		sound = {breaks = 'default_tool_breaks'},
		groups = {sword = 1}
	})
	
	core.register_craft {
		output = 'bonified:tool_sword_fossil',
		recipe = {
			{'', 'bonified:fossil', ''},
			{'', 'bonified:fossil_block', ''},
			{'', 'bonified:bone', ''}
		}
	}
end

-- Armor
if core.get_modpath '3d_armor' and core.settings: get_bool('bonified.enable_armor', true) then
	dofile(bonified.modpath .. '/armor.lua')
end

-- Dungeon loot
if core.get_modpath 'dungeon_loot' and core.settings: get_bool('bonified.enable_dungeon_loot', true) then
	dofile(bonified.modpath .. '/dungeon_loot.lua')
end

-- Decorative bone nodes
core.register_node('bonified:bone_bricks', {
	description = S 'Bone Bricks',
	tiles = {'bonified_bone_bricks.png'},
	groups = {oddly_breakable_by_hand = 3, cracky = 3},
	sounds = default.node_sound_stone_defaults()
})

core.register_craft {
	output = 'bonified:bone_bricks 16',
	recipe = {
		{'bonified:bone_block', 'bonified:bone_block'},
		{'bonified:bone_block', 'bonified:bone_block'}
	}
}

core.register_node('bonified:fossil_bricks', {
	description = S 'Fossil Bricks',
	tiles = {'bonified_fossil_bricks.png'},
	groups = {oddly_breakable_by_hand = 3, cracky = 3},
	sounds = default.node_sound_stone_defaults()
})

core.register_craft {
	output = 'bonified:fossil_bricks 24',
	recipe = {
		{'bonified:fossil_block', 'bonified:fossil_block'},
		{'bonified:fossil_block', 'bonified:fossil_block'}
	}
}

if core.get_modpath 'stairs' then
	stairs.register_stair_and_slab(
		'bone_bricks',
		'bonified:bone_bricks',
		{oddly_breakable_by_hand = 3, cracky = 3},
		{'bonified_bone_bricks.png'},
		S 'Bone Brick Stairs', S 'Bone Brick Slab',
		default.node_sound_stone_defaults(), true,
		S 'Bone Brick Stairs (Inner Corner)', S 'Bone Brick Stairs (Outer Corner)'
	)
	
	stairs.register_stair_and_slab(
		'fossil_bricks',
		'bonified:fossil_bricks',
		{cracky = 2},
		{'bonified_fossil_bricks.png'},
		S 'Fossil Brick Stairs', S 'Fossil Brick Slab',
		default.node_sound_stone_defaults(), true,
		S 'Fossil Brick Stairs (Inner Corner)', S 'Fossil Brick Stairs (Outer Corner)'
	)
end

if core.get_modpath 'walls' then
	walls.register(':bonified:bone_wall', S 'Bone Brick Wall', {'bonified_bone_bricks.png'},
		'bonified:bone_bricks', default.node_sound_stone_defaults())
		
	walls.register(':bonified:fossil_wall', S 'Fossil Brick Wall', {'bonified_fossil_bricks.png'},
		'bonified:fossil_bricks', default.node_sound_stone_defaults())
end
