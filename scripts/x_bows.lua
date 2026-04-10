local S = core.get_translator 'bonified'

local feather = 'group:wool'

if core.get_modpath 'animalia' then
	feather = 'group:feather'
end

local function try_break (self, pointed_thing)
	if math.random(1, 5) == 3 then
		core.sound_play({name = 'default_tool_breaks'}, {pos = self.object: get_pos(), gain = 2})
		self.object: remove()
	end
end

if core.settings: get_bool('bonified.enable_bone_tools', true) then
	XBows: register_arrow('arrow_bone', {
		description = S 'Bone Arrow',
		inventory_image = 'bonified_arrow_bone.png',
		custom = {
			mod_name = 'bonified',
			tool_capabilities = {
				full_punch_interval = 0.8,
				max_drop_level = 1,
				damage_groups = {fleshy = 5}
			},
			on_hit_entity = try_break,
			on_hit_player = try_break,
			on_hit_node = try_break
		}
	})
	
	core.register_craft {
		recipe = {
			{'default:flint'},
			{'bonified:bone'},
			{feather}
		},
		output = 'bonified:arrow_bone 6'
	}
end

if core.settings: get_bool('bonified.enable_fossil_tools', true) then
	XBows: register_arrow('arrow_fossil', {
		description = S 'Ancient Arrow',
		inventory_image = 'bonified_arrow_fossil.png',
		custom = {
			mod_name = 'bonified',
			tool_capabilities = {
				full_punch_interval = 0.7,
				max_drop_level = 1,
				damage_groups = {fleshy = 7}
			},
		}
	})
	
	core.register_craft {
		recipe = {
			{'bonified:fossil'},
			{'bonified:bone'},
			{feather}
		},
		output = 'bonified:arrow_fossil 12'
	}
end

XBows: update_bow_allowed_ammunition('bow_wood', {
	'bonified:arrow_bone',
	'bonified:arrow_fossil'
})