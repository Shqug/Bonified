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

core.register_alias('bonified:bone_brick_wall', 'bonified:bone_fence')

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

local function torch_on_place (itemstack, player, pointed)
	local node = core.get_node(pointed.under)
	local def = core.registered_nodes[node.name]
	if def and def.on_rightclick and not (player and player: is_player() and player: get_player_control().sneak) then
		return def.on_rightclick(pointed.under, node, player, itemstack, pointed) or itemstack
	end

	local surface = core.dir_to_wallmounted(vector.subtract(pointed.under, pointed.above))
	local new_stack = itemstack
	if surface == 0 then
		new_stack: set_name 'bonified:bone_torch_ceiling'
	elseif surface == 1 then
		new_stack: set_name 'bonified:bone_torch'
	else
		new_stack: set_name 'bonified:bone_torch_wall'
	end

	itemstack = core.item_place(new_stack, player, pointed, wdir)
	itemstack: set_name 'bonified:bone_torch'

	return itemstack
end

local bone_torch_def = table.copy(core.registered_nodes['default:torch'])
bone_torch_def.description = S 'Bone Torch'
bone_torch_def.inventory_image = 'bonified_bone_torch.png'
bone_torch_def.wield_image = 'bonified_bone_torch.png'
bone_torch_def.tiles = {{
	name = 'bonified_bone_torch_animated.png',
	animation = {type = 'vertical_frames', aspect_w = 16, aspect_h = 16, length = 2}
}}
bone_torch_def.drop = 'bonified:bone_torch'
bone_torch_def.on_place = torch_on_place
core.register_node('bonified:bone_torch', bone_torch_def)

local bone_torch_wall_def = table.copy(core.registered_nodes['default:torch_wall'])
bone_torch_wall_def.tiles = {{
	name = 'bonified_bone_torch_animated.png',
	animation = {type = 'vertical_frames', aspect_w = 16, aspect_h = 16, length = 2}
}}
bone_torch_wall_def.drop = 'bonified:bone_torch'
core.register_node('bonified:bone_torch_wall', bone_torch_wall_def)

local bone_torch_ceiling_def = table.copy(core.registered_nodes['default:torch_ceiling'])
bone_torch_ceiling_def.tiles = {{
	name = 'bonified_bone_torch_animated.png',
	animation = {type = 'vertical_frames', aspect_w = 16, aspect_h = 16, length = 2}
}}
bone_torch_ceiling_def.drop = 'bonified:bone_torch'
core.register_node('bonified:bone_torch_ceiling', bone_torch_ceiling_def)

core.register_craft {
	recipe = {
		{'group:coal'},
		{'bonified:bone'}
	},
	output = 'bonified:bone_torch 6'
}

local function lantern_on_place (itemstack, player, pointed)
	local node = core.get_node(pointed.under)
	local def = core.registered_nodes[node.name]
	if def and def.on_rightclick and not (player and player: is_player() and player: get_player_control().sneak) then
		return def.on_rightclick(pointed.under, node, player, itemstack, pointed) or itemstack
	end

	local surface = core.dir_to_wallmounted(vector.subtract(pointed.under, pointed.above))
	local new_stack = itemstack
	if surface == 0 then
		new_stack: set_name 'bonified:fossil_lantern_ceiling'
	else
		new_stack: set_name 'bonified:fossil_lantern'
	end

	itemstack = core.item_place(new_stack, player, pointed, wdir)
	itemstack: set_name 'bonified:fossil_lantern'

	return itemstack
end

core.register_node('bonified:fossil_lantern', {
	description = S 'Ancient Lantern',
	tiles = {'bonified_fossil_lantern_top.png', 'bonified_fossil_lantern_bottom.png', 'bonified_fossil_lantern_side.png'},
	use_texture_alpha = 'clip',
	paramtype = 'light',
	sunlight_propagates = true,
	groups = {choppy = 3, oddly_breakable_by_hand = 2},
	light_source = 12,
	on_place = lantern_on_place,
	sounds = default.node_sound_stone_defaults(),
	drawtype = 'nodebox',
	node_box = {
		type = 'fixed',
		fixed = {
			{-8/24, -0.5, -8/24, 8/24, -10/24, 8/24},
			{-6/24, -10/24, -6/24, 6/24, 7/24, 6/24},
			{-8/24, 3/24, -8/24, 8/24, 5/24, 8/24},
			{-3/24, 7/24, -0.001, 3/24, 10/24, 0}
		}
	}
})

core.register_node('bonified:fossil_lantern_ceiling', {
	tiles = {'bonified_fossil_lantern_top.png', 'bonified_fossil_lantern_bottom.png', '[combine:24x24:0,-2=bonified_fossil_lantern_side.png'},
	use_texture_alpha = 'clip',
	paramtype = 'light',
	sunlight_propagates = true,
	groups = {choppy = 3, oddly_breakable_by_hand = 2, not_in_creative_inventory = 1},
	light_source = 12,
	sounds = default.node_sound_stone_defaults(),
	drawtype = 'nodebox',
	node_box = {
		type = 'fixed',
		fixed = {
			{-8/24, -10/24, -8/24, 8/24, -8/24, 8/24},
			{-6/24, -8/24, -6/24, 6/24, 9/24, 6/24},
			{-8/24, 5/24, -8/24, 8/24, 7/24, 8/24},
			{-3/24, 9/24, -0.001, 3/24, 0.5, 0}
		}
	},
	drop = 'bonified:fossil_lantern'
})

core.register_craft {
	recipe = {
		{'', 'bonified:fossil', ''},
		{'default:bronze_ingot', 'bonified:bone_torch', 'default:bronze_ingot'},
		{'', 'bonified:fossil', ''}
	},
	output = 'bonified:fossil_lantern 3'
}