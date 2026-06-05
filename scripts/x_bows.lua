local S = core.get_translator 'bonified'

local feather = 'group:wool'

if core.get_modpath 'animalia' then
	feather = 'group:feather'
end

local function try_break (self, pointed_thing)
	if math.random(1, 4) == 3 then
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

local tnt = not not core.get_modpath 'tnt'

local function do_effect (pos, critical)
	core.add_particle {
		pos = pos + vector.new(0, 0.3, 0),
		expirationtime = 0.4,
		glow = 14,
		size = 10,
		texture = critical and 'bonified_boom_particle_a_critical.png' or 'bonified_boom_particle_a.png',
		animation = {
			type = 'vertical_frames',
			aspect_w = 24,
			aspect_h = 24,
			length = 0.4
		}
	}
	
	for i = 1,32 do
		core.add_particle {
			pos = pos + vector.new((math.random() - 0.5) * 1.1, (math.random() - 0.5) * 1.1, (math.random() - 0.5) * 1.1),
			velocity = vector.new((math.random() - 0.5) * 8, math.random() * 8, (math.random() - 0.5) * 8),
			acceleration = vector.new(0, -20, 0),
			expirationtime = math.max(0.05, math.random()*0.5),
			glow = 14,
			size = 2,
			texture = critical and 'bonified_boom_particle_b_critical.png' or 'bonified_boom_particle_b.png'
		}
	end
	
	for i = 1, math.random(10,20) do
		core.add_particle {
			pos = pos + vector.new((math.random() - 0.5) * 2.5, math.random() * 2, (math.random() - 0.5) * 2.5),
			velocity = vector.new((math.random() - 0.5) * 2.5, math.random() * 5, (math.random() - 0.5) * 2.5),
			acceleration = vector.new(0, -4, 0),
			expirationtime = math.random()*2,
			size = 5,
			vertical = true,
			texture = 'bonified_boom_particle_c.png'
		}
	end
end

local function discharge (self, pointed_thing)
	local pos = self.object: get_pos()
	self.object: remove()
	
	if tnt then
		core.sound_play({name = 'tnt_explode'}, {pos = pos, gain = 0.6, pitch = math.max(1.8, math.random()*2.5)})
	end
	
	for obj in core.objects_inside_radius(pos, 5) do
		local dist = vector.distance(pos, obj: get_pos())
		local dir = vector.direction(pos, obj: get_pos())
		obj: punch(self._user, 1, {damage_groups = {fleshy = (self._is_critical_hit and 15 or 10) / math.max(1, dist/2)}, full_punch_interval = 1}, dir)
		if obj: is_player() then
			obj: add_velocity((self._is_critical_hit and 3 or 2.5) * dir * (5-dist))
		end
	end
	
	if tnt then
		local tntpos = core.find_node_near(pos, 3, 'tnt:tnt', true)
		if tntpos and not core.is_protected(tntpos, self._user_name) then core.registered_nodes['tnt:tnt'].on_blast(tntpos) end
	end
	
	do_effect(pos, self._is_critical_hit)
	
	core.add_item(pos, self._is_critical_hit and 'bonified:arrow_fossil' or (math.random(1, 5) == 1 and 'bonified:bone' or 'bonified:arrow_fossil'))
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
			}
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
	
	if core.settings: get_bool('bonified.enable_charged_arrow', true) then
		XBows: register_arrow('arrow_fossil_charged', {
			description = S('Charged Ancient Arrow') .. '\n' .. core.colorize('#ff9539', S'Creates a small explosion on impact') .. '\n' .. core.colorize('#ff9539', S'Does not damage nodes'),
			inventory_image = 'bonified_arrow_fossil_charged.png',
			custom = {
				mod_name = 'bonified',
				tool_capabilities = {
					full_punch_interval = 0.7,
					max_drop_level = 1,
					damage_groups = {fleshy = 5},
				},
				on_hit_entity = discharge,
				on_hit_player = discharge,
				on_hit_node = discharge
			}
		})
		
		core.register_craft {
			recipe = {
				{'default:mese_crystal_fragment', 'bonified:arrow_fossil', 'default:mese_crystal_fragment'}
			},
			output = 'bonified:arrow_fossil_charged'
		}
	end
end

XBows: update_bow_allowed_ammunition('bow_wood', {
	'bonified:arrow_bone',
	'bonified:arrow_fossil',
	'bonified:arrow_fossil_charged'
})