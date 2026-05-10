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
		core.after(0.2, function (pos) default.grow_sapling(pos) end, pointed.under)
		
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
			
			if (core.get_item_group(name, 'plant') ~= 0 or core.get_item_group(name, 'seed') ~= 0)
			and core.registered_nodes[name].next_plant then
				return try_grow_crop(itemstack, player, pointed, strength, guarantee)
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
