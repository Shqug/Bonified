local S = core.get_translator 'bonified'

core.register_node('bonified:bone_bricks', {
	description = S 'Bone Bricks',
	tiles = {'bonified_bone_bricks.png'},
	groups = {oddly_breakable_by_hand = 3, cracky = 3, bone = 1},
	is_ground_content = false,
	sounds = default.node_sound_stone_defaults()
})

core.register_craft {
	output = 'bonified:bone_bricks 16',
	recipe = {
		{'bonified:bone_block', 'bonified:bone_block'},
		{'bonified:bone_block', 'bonified:bone_block'}
	}
}

core.register_node('bonified:bone_bricks_chiselled', {
	description = S 'Chiselled Bone Bricks',
	tiles = {'bonified_bone_bricks_chiselled.png'},
	groups = {oddly_breakable_by_hand = 3, cracky = 3, bone = 1},
	is_ground_content = false,
	sounds = default.node_sound_stone_defaults()
})

core.register_craft {
	output = 'bonified:bone_bricks_chiselled 4',
	recipe = {
		{'bonified:bone_bricks', 'bonified:bone_bricks'},
		{'bonified:bone_bricks', 'bonified:bone_bricks'}
	}
}

core.register_node('bonified:fossil_bricks', {
	description = S 'Fossil Bricks',
	tiles = {'bonified_fossil_bricks.png'},
	groups = {oddly_breakable_by_hand = 3, cracky = 3, bone = 1},
	is_ground_content = false,
	sounds = default.node_sound_stone_defaults()
})

core.register_craft {
	output = 'bonified:fossil_bricks 24',
	recipe = {
		{'bonified:fossil_block', 'bonified:fossil_block'},
		{'bonified:fossil_block', 'bonified:fossil_block'}
	}
}

core.register_node('bonified:fossil_bricks_chiselled', {
	description = S 'Chiselled Fossil Bricks',
	tiles = {'bonified_fossil_bricks_chiselled.png'},
	groups = {oddly_breakable_by_hand = 3, cracky = 3, bone = 1},
	is_ground_content = false,
	sounds = default.node_sound_stone_defaults()
})

core.register_craft {
	output = 'bonified:fossil_bricks_chiselled 4',
	recipe = {
		{'bonified:fossil_bricks', 'bonified:fossil_bricks'},
		{'bonified:fossil_bricks', 'bonified:fossil_bricks'}
	}
}

if core.get_modpath 'stairs' then
	stairs.register_stair_and_slab(
		'bone_bricks',
		'bonified:bone_bricks',
		{oddly_breakable_by_hand = 3, cracky = 3, bone = 1},
		{'bonified_bone_bricks.png'},
		S 'Bone Brick Stairs', S 'Bone Brick Slab',
		default.node_sound_stone_defaults(), true,
		S 'Bone Brick Stairs (Inner Corner)', S 'Bone Brick Stairs (Outer Corner)'
	)
	
	stairs.register_stair_and_slab(
		'fossil_bricks',
		'bonified:fossil_bricks',
		{cracky = 2, bone = 1},
		{'bonified_fossil_bricks.png'},
		S 'Fossil Brick Stairs', S 'Fossil Brick Slab',
		default.node_sound_stone_defaults(), true,
		S 'Fossil Brick Stairs (Inner Corner)', S 'Fossil Brick Stairs (Outer Corner)'
	)
end

if core.get_modpath 'walls' then
	walls.register(':bonified:fossil_wall', S 'Fossil Brick Wall', {'bonified_fossil_bricks.png'},
		'bonified:fossil_bricks', default.node_sound_stone_defaults())
end

local fence_collisionbox_add = core.settings: get_bool 'enable_fence_tall' and 8/24 or 0

core.register_node('bonified:bone_fence', {
	description = S 'Bone Fence',
	tiles = {'bonified_bone_fence_top.png', 'bonified_bone_fence_top.png', 'bonified_bone_fence_side.png', 'bonified_bone_fence_side.png', 'bonified_bone_fence_side.png^bonified_bone_fence_front.png'},
	inventory_image = 'bonified_bone_fence_inv.png',
	groups = {oddly_breakable_by_hand = 3, cracky = 3, fence = 1},
	sounds = default.node_sound_stone_defaults(),
	
	connects_to = {'group:fence', 'group:wood', 'group:tree', 'group:wall', 'group:stone', 'group:bone'},
	paramtype = 'light',
	drawtype = 'nodebox',
	sunlight_propagates = true,
	is_ground_content = false,
	
	node_box = {
		type = 'connected',
		fixed = {
			{-2/24, -0.5, -2/24, 2/24, 7/24, 2/24},
			{-3/24, 7/24, -2/24, 3/24, 0.5, 2/24}
		},
		
		connect_front = {-1/24, -0.5, -0.5, 1/24, 6/24, -2/24},
		connect_back = {-1/24, -0.5, 0.5, 1/24, 6/24, 2/24},
		connect_left = {-0.5, -0.5, -1/24, -2/24, 6/24, 1/24},
		connect_right = {0.5, -0.5, -1/24, 2/24, 6/24, 1/24},
	},
	
	collision_box = {
		type = 'connected',
		fixed = {-2/24, -0.5, -2/24, 2/24, 0.5 + fence_collisionbox_add, 2/24},
		connect_front = {-2/24, -0.5, -0.5, 2/24, 0.5 + fence_collisionbox_add, -2/24},
		connect_back = {-2/24, -0.5, 0.5, 2/24, 0.5 + fence_collisionbox_add, 2/24},
		connect_left = {-0.5, -0.5, -2/24, -2/24, 0.5 + fence_collisionbox_add, 2/24},
		connect_right = {0.5, -0.5, -2/24, 2/24, 0.5 + fence_collisionbox_add, 2/24},
	},
	
	selection_box = {
		type = 'connected',
		fixed = {-2/24, -0.5, -2/24, 2/24, 0.5, 2/24},
		connect_front = {-2/24, -0.5, -0.5, 2/24, 7/24, -2/24},
		connect_back = {-2/24, -0.5, 0.5, 2/24, 7/24, 2/24},
		connect_left = {-0.5, -0.5, -2/24, -2/24, 7/24, 2/24},
		connect_right = {0.5, -0.5, -2/24, 2/24, 7/24, 2/24},
	}
})

core.register_craft {
	recipe = {
		{'bonified:bone_block', 'bonified:bone', 'bonified:bone_block'},
		{'bonified:bone_block', 'bonified:bone', 'bonified:bone_block'}
	},
	output = 'bonified:bone_fence 16'
}

core.register_node('bonified:bone_fence_rail', {
	description = S 'Bone Fence Rail',
	tiles = {'bonified_bone_fence_rail_top.png', 'bonified_bone_fence_rail_top.png', 'bonified_bone_fence_rail_side.png'},
	inventory_image = 'bonified_bone_fence_rail_side.png',
	groups = {oddly_breakable_by_hand = 3, cracky = 3, fence = 1},
	sounds = default.node_sound_stone_defaults(),
	
	connects_to = {'group:fence', 'group:wall'},
	paramtype = 'light',
	drawtype = 'nodebox',
	sunlight_propagates = true,
	is_ground_content = false,
	
	node_box = {
		type = 'connected',
		fixed = {
			{-2/24, -8/24, -2/24, 2/24, 8/24, 2/24},
		},
		
		connect_front = {
			{-1/24, 4/24, -1/2, 1/24, 7/24, -2/24},
			{-1/24, -7/24, -1/2, 1/24, -4/24, -2/24}
		},
		connect_left = {
			{-1/2, 4/24, -1/24, -2/24, 7/24, 1/24},
			{-1/2, -7/24, -1/24, -2/24, -4/24, 1/24}
		},
		connect_back = {
			{-1/24, 4/24, 2/24, 1/24, 7/24, 1/2},
			{-1/24, -7/24, 2/24, 1/24, -4/24, 1/2}
		},
		connect_right = {
			{ 2/24, 4/24, -1/24, 1/2, 7/24, 1/24},
			{ 2/24, -7/24, -1/24, 1/2, -4/24, 1/24}
		}
	},
	
	collision_box = {
		type = 'connected',
		fixed = {-2/24, -0.5, -2/24, 2/24, 0.5 + fence_collisionbox_add, 2/24},
		connect_front = {-2/24, -0.5, -0.5, 2/24, 0.5 + fence_collisionbox_add, -2/24},
		connect_back = {-2/24, -0.5, 0.5, 2/24, 0.5 + fence_collisionbox_add, 2/24},
		connect_left = {-0.5, -0.5, -2/24, -2/24, 0.5 + fence_collisionbox_add, 2/24},
		connect_right = {0.5, -0.5, -2/24, 2/24, 0.5 + fence_collisionbox_add, 2/24},
	},
	
	selection_box = {
		type = 'connected',
		fixed = {-2/24, -8/24, -2/24, 2/24, 8/24, 2/24},
		connect_front = {-2/24, -7/24, -0.5, 2/24, 7/24, -2/24},
		connect_back = {-2/24, -7/24, 0.5, 2/24, 7/24, 2/24},
		connect_left = {-0.5, -7/24, -2/24, -2/24, 7/24, 2/24},
		connect_right = {0.5, -7/24, -2/24, 2/24, 7/24, 2/24},
	}
})

core.register_craft {
	recipe = {
		{'bonified:bone', '', 'bonified:bone'},
		{'bonified:bone', '', 'bonified:bone'}
	},
	output = 'bonified:bone_fence_rail 16'
}