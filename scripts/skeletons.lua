
core.registered_entities['mobs_skeletons:skeleton'].drops = function ()
	return {
		{name = 'bonified:bone', chance = 2, min = 1, max = 1},
		{name = 'bonified:bone', chance = 3, min = 1, max = 3},
		{name = 'bonified:tool_sword_bone 1 ' .. math.random(0, 43690), chance = 5, min = 1, max = 1}
	}
end

if core.get_modpath 'x_bows' then
	core.registered_entities['mobs_skeletons:skeleton_archer'].drops = function ()
		return {
			{name = 'bonified:bone', chance = 2, min = 1, max = 1},
			{name = 'bonified:bone', chance = 3, min = 1, max = 2},
			{name = 'x_bows:bow_wood 1 ' .. math.random(0, 43690), chance = 8, min = 1, max = 1},
			{name = 'bonified:arrow_bone', chance = 4, min = 1, max = 5}
		}
	end
	
	core.registered_entities['mobs_skeletons:skeleton_archer_dark'].drops = function ()
		return {
			{name = 'bonified:bone', chance = 2, min = 1, max = 2},
			{name = 'bonified:bone', chance = 3, min = 1, max = 3},
			{name = 'x_bows:bow_wood 1 ' .. math.random(0, 43690), chance = 5, min = 1, max = 1},
			{name = 'bonified:arrow_bone', chance = 2, min = 1, max = 5},
			{name = 'bonified:arrow_fossil', chance = 3, min = 1, max = 3},
		}
	end
	
else
	table.insert(core.registered_entities['mobs_skeletons:skeleton_archer'].drops, {name = 'bonified:bone', chance = 2, min = 1, max = 1})
	table.insert(core.registered_entities['mobs_skeletons:skeleton_archer'].drops, {name = 'bonified:bone', chance = 3, min = 1, max = 2})

	table.insert(core.registered_entities['mobs_skeletons:skeleton_archer_dark'].drops, {name = 'bonified:bone', chance = 2, min = 1, max = 2})
	table.insert(core.registered_entities['mobs_skeletons:skeleton_archer_dark'].drops, {name = 'bonified:bone', chance = 3, min = 1, max = 3})
end