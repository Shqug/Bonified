local S = core.get_translator 'bonified'

-- Play bonemeal successful growth effect
local function make_effect (pos)
	for i = 1, math.random(10,20) do
		core.add_particle {
			pos = pos + vector.new((math.random() - 0.5) * 0.75, math.random()-1, (math.random() - 0.5) * 0.75),
			velocity = vector.new(0, 4, 0),
			acceleration = vector.new(0, -4, 0),
			expirationtime = math.random()*0.2,
			glow = 5,
			size = 3,
			vertical = true,
			texture = 'bonified_fertilize_particle_a.png'
		}
	end
	
	for i = 1, math.random(4,10) do
		core.add_particle {
			pos = pos + vector.new(math.random() - 0.5, (math.random()-0.5) * 0.5, math.random() - 0.5),
			velocity = vector.new((math.random() - 0.5) * 3, (math.random() - 0.5) * 1.5, (math.random() - 0.5) * 3),
			acceleration = vector.new((math.random() - 0.5) * 4, (math.random() - 0.5) * 2, (math.random() - 0.5) * 4),
			expirationtime = 0.3 + (math.random() * 0.2),
			glow = 5,
			size = 1.6,
			texture = 'bonified_fertilize_particle_b.png',
			animation = {
				type = 'vertical_frames',
				aspect_w = 8,
				aspect_h = 8,
				length = 0.5
			}
		}
	end
end

local creative = core.settings: get_bool 'creative_mode'

local function try_grow_sapling (itemstack, player, pointed, strength)
	if not (creative or core.check_player_privs(player, 'creative')) then itemstack: take_item() end
	
	core.sound_play({name = 'bonified_bone_meal_apply'}, {to_player = player: get_player_name(), pitch = 1+(math.random()*0.25)})
	
	if math.random() <= strength * 0.5 then
		local nodename = core.get_node(pointed.under).name
		
		if (not core.get_modpath 'moretrees') and nodename == 'moretrees:rubber_tree_sapling' then
			core.after(0.2, function (pos)
				core.remove_node(pos)
				core.spawn_tree(pos, technic.rubber_tree_model)
			end, pointed.under)
		elseif nodename: find '^ebiomes:' or nodename: find '^moretrees:' then
			core.after(0.2, function (pos) core.registered_nodes[nodename].on_timer(pos) end, pointed.under)
		else
			core.after(0.2, function (pos) default.grow_sapling(pos) end, pointed.under)
		end
		
		make_effect(pointed.under)
		core.sound_play({name = 'bonified_bone_meal_grow'}, {to_player = player: get_player_name(), gain = 0.6, pitch = 0.5+(math.random()*0.25)})
	end
	
	return itemstack
end

local function try_grow_large_cactus (itemstack, player, pointed, strength)
	if not (creative or core.check_player_privs(player, 'creative')) then itemstack: take_item() end
	
	core.sound_play({name = 'bonified_bone_meal_apply'}, {to_player = player: get_player_name(), pitch = 1+(math.random()*0.25)})
	
	if math.random() <= strength * 0.5 then
		core.after(0.2, function (pos) default.grow_large_cactus(pos) end, pointed.under)
		
		make_effect(pointed.under)
		core.sound_play({name = 'bonified_bone_meal_grow'}, {to_player = player: get_player_name(), gain = 0.6, pitch = 0.5+(math.random()*0.25)})
	end
	
	return itemstack
end

local function try_grow_crop (itemstack, player, pointed, strength, guarantee)
	if not (creative or core.check_player_privs(player, 'creative')) then itemstack: take_item() end
	
	core.sound_play({name = 'bonified_bone_meal_apply'}, {to_player = player: get_player_name(), pitch = 1+(math.random()*0.25)})
	
	for i = 1, guarantee do
		farming.grow_plant(pointed.under)
		
		make_effect(pointed.under)
		core.sound_play({name = 'bonified_bone_meal_grow'}, {to_player = player: get_player_name(), gain = 0.6, pitch = 0.5+(math.random()*0.25)})
	end
	
	local rolls = guarantee
	while math.random() <= strength and rolls < 6 do
		farming.grow_plant(pointed.under)
		
		make_effect(pointed.under)
		
		rolls = rolls + 1
	end
	
	return itemstack
end

local function try_grow_cactus (itemstack, player, pointed, strength)
	if not (creative or core.check_player_privs(player, 'creative')) then itemstack: take_item() end
	
	core.sound_play({name = 'bonified_bone_meal_apply'}, {to_player = player: get_player_name(), pitch = 1+(math.random()*0.25)})
	
	if math.random() <= strength * 0.5 then
		core.after(0.2, function (pos, node) default.grow_cactus(pos, node) end, pointed.under, core.get_node(pointed.under))
		
		make_effect(pointed.under + vector.new(0, 1, 0))
		core.sound_play({name = 'bonified_bone_meal_grow'}, {to_player = player: get_player_name(), gain = 0.6, pitch = 0.5+(math.random()*0.25)})
	end
	
	return itemstack
end

local function try_grow_papyrus (itemstack, player, pointed, strength)
	if not (creative or core.check_player_privs(player, 'creative')) then itemstack: take_item() end
	
	core.sound_play({name = 'bonified_bone_meal_apply'}, {to_player = player: get_player_name(), pitch = 1+(math.random()*0.25)})
	
	local rolls = 0
	while math.random() <= strength * 0.75 and rolls < 6 do
		core.after(0.2, function (pos, node) default.grow_papyrus(pos, node) end, pointed.under, core.get_node(pointed.under))
		
		make_effect(pointed.under + vector.new(0, 1, 0))
		core.sound_play({name = 'bonified_bone_meal_grow'}, {to_player = player: get_player_name(), gain = 0.6, pitch = 0.5+(math.random()*0.25)})
		
		rolls = rolls + 1
	end
	
	return itemstack
end

local function try_spread_generic (itemstack, player, pointed, strength, spread_to, place_offset, node_above, param2_min, param2_max)
	local name = core.get_node(pointed.under).name
	
	local stage_max = 1
	
	if name: sub(-2, -1): match '_%d' then
		stage_max = tonumber(name: sub (-1, -1))
	end
	
	if not (creative or core.check_player_privs(player, 'creative')) then itemstack: take_item() end
	
	core.sound_play({name = 'bonified_bone_meal_apply'}, {to_player = player: get_player_name(), pitch = 1+(math.random()*0.25)})
	
	local rolls = 0
	while math.random() <= strength * 0.75  and rolls < 6 do
		
		local poses
		
		if node_above then
			local potential_poses = core.find_nodes_in_area(pointed.under - vector.new(2, 2, 2), pointed.under + vector.new(2, 0, 2), {spread_to})
			poses = {}
			
			for _, v in ipairs(potential_poses) do
				local nodename = core.get_node(v + vector.new(0, 1, 0)).name
				if nodename == node_above then
					table.insert(poses, v)
				end
			end
		else
			poses = core.find_nodes_in_area_under_air(pointed.under - vector.new(2, 2, 2), pointed.under + vector.new(2, 0, 2), {spread_to})
		end
		
		if #poses == 0 then
			return itemstack
		end
		
		local new_pos = poses[math.random(1, #poses)] + vector.new(0, place_offset, 0)
		
		if core.is_protected(new_pos, player: get_player_name()) then return itemstack end
		
		if stage_max > 1 then
			core.set_node(new_pos, {name = name: sub(1, -3) .. '_' .. math.random(1, stage_max), param2 = param2_min and math.random(param2_min, param2_max)})
		else
			core.set_node(new_pos, {name = name, param2 = param2_min and math.random(param2_min, param2_max)})
		end
		
		make_effect(new_pos)
		core.sound_play({name = 'bonified_bone_meal_grow'}, {to_player = player: get_player_name(), gain = 0.6, pitch = 0.5+(math.random()*0.25)})
		
		rolls = rolls + 1
	end
	
	return itemstack
end

local permafrost_groups = core.registered_nodes['default:permafrost'].groups
permafrost_groups.permafrost_spreadable = 1
core.override_item('default:permafrost', {groups = permafrost_groups})

local permafrost_stones_groups = core.registered_nodes['default:permafrost_with_stones'].groups
permafrost_stones_groups.permafrost_spreadable = 1
core.override_item('default:permafrost_with_stones', {groups = permafrost_stones_groups})

local generic_spreadables = {
	{'mushroom', 'group:soil', 1},
	{'flowers:waterlily', 'default:water_source', 1, 'air', 0, 3},
	{'flowers:waterlily_waving', 'default:water_source', 1, 'air', 0, 3},
	{'flower', 'group:soil', 1},
	{'default:fern_1', 'group:soil', 1},
	{'default:fern_2', 'group:soil', 1},
	{'default:fern_3', 'group:soil', 1},
	{'default:grass_1', 'group:soil', 1},
	{'default:grass_2', 'group:soil', 1},
	{'default:grass_3', 'group:soil', 1},
	{'default:grass_4', 'group:soil', 1},
	{'default:grass_5', 'group:soil', 1},
	{'default:dry_grass_1', 'group:soil', 1},
	{'default:dry_grass_2', 'group:soil', 1},
	{'default:dry_grass_3', 'group:soil', 1},
	{'default:dry_grass_4', 'group:soil', 1},
	{'default:dry_grass_5', 'group:soil', 1},
	{'default:junglegrass', 'group:soil', 1},
	{'default:marram_grass_1', 'group:sand', 1},
	{'default:marram_grass_2', 'group:sand', 1},
	{'default:marram_grass_3', 'group:sand', 1},
	{'default:dry_shrub', 'group:sand', 1, 'air', 4, 4},
	{'default:sand_with_kelp', 'default:sand', 0, 'default:water_source', 48, 96},
	{'default:dirt_with_grass', 'default:dirt', 0},
	{'default:dirt_with_dry_grass', 'default:dirt', 0},
	{'default:dry_dirt_with_dry_grass', 'default:dry_dirt', 0},
	{'default:permafrost_with_moss', 'group:permafrost_spreadable', 0},
}

-- Strength is the chance (0-1) to instantly advance a growth stage
-- For crops, after the initial guaranteed growth, this is rerolled until failure or 5-guaranteed times, whichever is lower
-- For saplings this value is halved
function bonified.apply_fertilizer (guarantee, strength)
	return function (itemstack, player, pointed)
		if core.is_protected(pointed.under, player: get_player_name()) then
			core.record_protection_violation(pointed.under, player: get_player_name())
			return itemstack
		end
		
		if pointed.type == 'node' then
			local name = core.get_node(pointed.under).name
		
			if core.get_item_group(name, 'sapling') ~= 0 then
				return try_grow_sapling(itemstack, player, pointed, strength)
			end
			
			if name == 'default:large_cactus_seedling' then
				return try_grow_large_cactus(itemstack, player, pointed, strength)
			end
			
			if (core.get_item_group(name, 'plant') ~= 0 or core.get_item_group(name, 'seed') ~= 0)
			and core.registered_nodes[name].next_plant then
				return try_grow_crop(itemstack, player, pointed, strength, guarantee)
			end
			
			if name == 'default:cactus' then
				if core.get_node(pointed.under - vector.new(0, 1, 0)).name ~= 'default:cactus' then
					return try_grow_cactus(itemstack, player, pointed, strength)
				end
			end
			
			if name == 'default:papyrus' then
				if core.get_node(pointed.under - vector.new(0, 1, 0)).name ~= 'default:papyrus' then
					return try_grow_papyrus(itemstack, player, pointed, strength)
				end
			end
			
			for _, spreadable in ipairs(generic_spreadables) do
				if name == spreadable[1] or core.get_item_group(name, spreadable[1]) ~= 0 then
					return try_spread_generic(itemstack, player, pointed, strength, spreadable[2], spreadable[3], spreadable[4], spreadable[5], spreadable[6])
				end
			end
		end
	end
end

core.register_craftitem('bonified:bone_meal', {
	description = S 'Bone Meal',
	inventory_image = 'bonified_bone_meal.png',
	on_use = bonified.apply_fertilizer(1, core.settings: get 'bonified.bone_meal_strength' or 0.25)
})

core.register_craft {
	type = 'shapeless',
	output = 'bonified:bone_meal 4',
	recipe = {'bonified:bone'}
}

core.register_craft {
	type = 'shapeless',
	output = 'bonified:bone_meal 6',
	recipe = {'bonified:skull'}
}

core.register_craft {
	type = 'shapeless',
	output = 'bonified:bone_meal 9',
	recipe = {'default:coral_skeleton'}
}

core.register_craft {
	type = 'shapeless',
	output = 'default:coral_skeleton',
	recipe = {
		'bonified:bone_meal', 'bonified:bone_meal', 'bonified:bone_meal',
		'bonified:bone_meal', 'bonified:bone_meal', 'bonified:bone_meal',
		'bonified:bone_meal', 'bonified:bone_meal', 'bonified:bone_meal'
	}
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
	on_use = bonified.apply_fertilizer(1, core.settings: get 'bonified.fertilizer_strength' or 0.65)
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
