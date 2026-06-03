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
		fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5}
	},
	selection_box = {
		type = 'fixed',
		fixed = {-0.5, -0.5, -0.5, 0.5, 1.5/16, 0.5}
	}
})

core.register_craft {
	type = 'shapeless',
	output = 'bonified:bone 5',
	recipe = {'bones:bones'},
	replacements = {{'bones:bones', 'bonified:skull'}}
}

core.register_craft {
	output = 'bones:bones',
	recipe = {
		{'bonified:bone', 'bonified:skull', 'bonified:bone'},
		{'bonified:bone', 'bonified:bone', 'bonified:bone'}
	}
}

-- Bone item
core.register_craftitem('bonified:bone', {
	description = S 'Bone',
	inventory_image = 'bonified_bone.png',
	groups = {bone = 1, stick = 1}
})

-- Dropping bones from soils
-- Second entry is rarity; 1 in X chance to drop one bone, 1 in 1.75X to drop 3 bones
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

-- Skull nodes
-- Used to snap the skull to angles 1/8th of 240
local multiples_15_lookup = {
	0,
	30,
	60,
	90,
	120,
	150,
	180,
	210
}

local function rotate_skull (pos, placer, itemstack, pointed_thing)
	if not (placer and placer: is_player()) then return end
	
	local ray = Raycast(placer: get_pos() + vector.new(0, placer: get_properties().eye_height, 0), pointed_thing.under, false, false)
	for pointed in ray do
		if pointed.under == pointed_thing.under then
			if pointed.intersection_normal.y == 0 then
				core.swap_node(pos, {name = 'bonified:skull_wall', param2 = core.dir_to_fourdir(placer: get_look_dir())})
				return
			end
		end
	end
	
	local angle = -placer: get_look_horizontal()*120/math.pi
	if angle < 0 then angle = 240 - angle end
	if angle > 239 then angle = angle - 240 end
	local angle = math.max(0, math.min(math.floor(angle), 239))
	
	local smallest_diff = 240
	local nearest = 0
	for _, snap_angle in ipairs(multiples_15_lookup) do
		local diff = math.abs(angle - snap_angle)
		if diff < smallest_diff then
			nearest = snap_angle
			smallest_diff = diff
		end
	end
	
	local node = core.get_node(pos)
	node.param2 = nearest
	core.swap_node(pos, node)
end

core.register_node('bonified:skull', {
	description = S 'Skull',
	drawtype = 'mesh',
	mesh = 'bonified_skull.obj',
	tiles = {'bonified_bone_pile.png'},
	use_texture_alpha = 'clip',
	paramtype = 'light',
	paramtype2 = 'degrotate',
	sunlight_propagates = true,
	
	collision_box = {
		type = 'fixed',
		fixed = {-6/24, -0.5, -6/24, 6/24, 0, 6/24}
	},
	selection_box = {
		type = 'fixed',
		fixed = {-6/24, -0.5, -6/24, 6/24, 0, 6/24}
	},
	
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_wood_defaults(),
	
	node_placement_prediction = 'air',
	after_place_node = rotate_skull
})

core.register_node('bonified:skull_wall', {
	drawtype = 'mesh',
	mesh = 'bonified_skull_wall.obj',
	tiles = {'bonified_bone_pile.png'},
	use_texture_alpha = 'clip',
	paramtype = 'light',
	paramtype2 = '4dir',
	sunlight_propagates = true,
	
	collision_box = {
		type = 'fixed',
		fixed = {-6/24, -6/24, 0.5, 6/24, 6/24, 0}
	},
	selection_box = {
		type = 'fixed',
		fixed = {-6/24, -6/24, 0.5, 6/24, 6/24, 0}
	},
	
	groups = {cracky = 3, oddly_breakable_by_hand = 3, not_in_creative_inventory},
	sounds = default.node_sound_wood_defaults(),
	
	drop = 'bonified:skull'
})

-- Bone block
core.register_node('bonified:bone_bale', {
	description = S 'Bone Block',
	tiles = {'bonified_bone_block_top.png', 'bonified_bone_block_top.png', 'bonified_bone_block_side.png'},
	groups = {oddly_breakable_by_hand = 1, choppy = 3},
	is_ground_content = false,
	paramtype2 = 'facedir',
	sounds = default.node_sound_gravel_defaults(),
	on_place = core.rotate_node
})

core.register_craft {
	type = 'shapeless',
	output = 'bonified:bone 4',
	recipe = {'bonified:bone_bale'}
}

core.register_craft {
	output = 'bonified:bone_bale',
	recipe = {
		{'bonified:bone', 'bonified:bone'},
		{'bonified:bone', 'bonified:bone'}
	}
}

core.register_alias('bonified:bone_block', 'bonified:bone_gravel')

core.register_node('bonified:bone_gravel', {
	description = S 'Bone Gravel',
	tiles = {'bonified_bone_gravel.png'},
	groups = {oddly_breakable_by_hand = 1, crumbly = 3, falling_node = 1},
	is_ground_content = false,
	sounds = default.node_sound_gravel_defaults()
})

core.register_craft {
	output = 'bonified:bone_gravel 3',
	recipe = {
		{'bonified:bone_bale', 'bonified:bone_bale'}
	}
}

core.register_craft {
	type = 'shapeless',
	output = 'bonified:bone 2',
	recipe = {'bonified:bone_gravel'}
}