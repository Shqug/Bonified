local S = core.get_translator 'bonified'

local return_ratio = math.min(math.max(0.01, core.settings: get 'bonified.bone_tool_recycling_ratio' or 0.85), 1)

local recyclable = {
	['bonified:tool_pick_bone'] = 24,
	['bonified:tool_shovel_bone'] = 16,
	['bonified:tool_axe_bone'] = 24,
	['bonified:tool_sword_bone'] = 32,
	['bonified:tool_hoe_bone'] = 16,
	['bonified:armor_helmet_bone'] = 60,
	['bonified:armor_chestplate_bone'] = 80,
	['bonified:armor_leggings_bone'] = 76,
	['bonified:armor_boots_bone'] = 40,
	['bonified:armor_shield_bone'] = 52,
	['bonified:armor_gloves_bone'] = 40
}

core.register_on_craft(function (itemstack, player, old_craft_grid, craft_inv)
	if itemstack: get_meta(): get_string 'is_placeholder' == 'true' then
		for index, slot in pairs(old_craft_grid) do
			if recyclable[ItemStack(slot): get_name()] then
				local ideal_amount = recyclable[ItemStack(slot): get_name()]
				local wear_percent = math.max(0, 1 - (ItemStack(slot): get_wear() / 65536))
				
				return 'bonified:bone_meal ' .. math.ceil(ideal_amount * wear_percent * return_ratio)
			end
		end
	end
end)

local placeholder_stack = ItemStack 'bonified:bone_meal'
placeholder_stack: get_meta(): set_string('is_placeholder', 'true')
placeholder_stack: get_meta(): set_string('count_meta', core.colorize('#ffa200', '1+'))
placeholder_stack = placeholder_stack: to_string()

for item, _ in pairs(recyclable) do
	core.register_craft {
		type = 'shapeless',
		output = placeholder_stack,
		recipe = {item}
	}
end