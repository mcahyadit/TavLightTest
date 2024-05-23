local animationDelay = 250
local combat = {}
--[[
	CONST_ME_ICETORNADO had me perplexed as to how area works
	then I found out in the forums that the appearance depends on the OT Client, so I gave up on one on one replication
	I just want to focus on creating a looping spell here similar enough in idea
	I believe I can do better with a proper design document or other effect
]]
local area = {
    {
		{0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
		{0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0},
		{0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0},
		{0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
		{1, 0, 0, 0, 0, 2, 0, 0, 0, 0, 1},
		{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
		{0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0},
		{0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0},
		{0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0},
		{0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0}
    },
    {
		{0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
		{0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0},
		{0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0},
		{0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0},
		{1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1},
		{1, 1, 1, 0, 0, 2, 0, 0, 0, 0, 1},
		{1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1},
		{0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0},
		{0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0},
		{0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0},
		{0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0}
    },
    {
		{0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
		{0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0},
		{0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0},
		{0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0},
		{1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1},
		{1, 0, 0, 1, 1, 2, 0, 0, 0, 0, 1},
		{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
		{0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0},
		{0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0},
		{0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0},
		{0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0}
    },
    {
		{0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
		{0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0},
		{0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0},
		{0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0},
		{1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1},
		{1, 0, 0, 0, 0, 2, 1, 1, 1, 1, 1},
		{1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1},
		{0, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0},
		{0, 0, 1, 0, 1, 1, 1, 1, 1, 0, 0},
		{0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0},
		{0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0}
    }
}

for i = 1, #area do
    combat[i] = Combat()
    combat[i]:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
    combat[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
    combat[i]:setArea(createCombatArea(area[i]))
end

function executeCombat5(p, i)
    if not p.player then
        return false
    end
    if not p.player:isPlayer() then
        return false
    end
    p.combat[i]:execute(p.player, p.var)
end

function onCastSpell(player, var)

    local p = {player = player, var = var, combat = combat}

    local level = player:getLevel()
    local maglevel = player:getMagicLevel()
    local min = (level / 5) + (maglevel * 1.4) + 8
    local max = (level / 5) + (maglevel * 2.2) + 14

    for i = 1, #area do
		combat[i]:setFormula(COMBAT_FORMULA_LEVELMAGIC, 0, -min, 0, -max)
    end

    for i = 1, 10 do
		addEvent(executeCombat5, animationDelay * (i - 1), p, (i - 1) % 4 + 1)
    end

    return true
end