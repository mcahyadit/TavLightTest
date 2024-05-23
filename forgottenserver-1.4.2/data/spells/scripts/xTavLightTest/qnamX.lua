local animationDelay = 50
local range = 5
local keepRunning = true

local area = {
    {
		{1},
		{2}
    },
    {
		{2, 1}
    },
    {
		{2},
		{1}
    },
    {
		{1, 2}
    }
}

local combat = {}
for i = 1, 4 do
	combat[i] = Combat()
	combat[i]:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
	combat[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICEATTACK)
	combat[i]:setArea(createCombatArea(area[i]))
end

--Since OpenTibia only have 4 direction, directions can simply be done with arrays
-- I would normally involve trigonometry
local xTmp = {0, 1, 0, -1}
local yTmp = {-1, 0, 1, 0}

function executeCombat6(p)
	if keepRunning then
		local posCurr = p.player:getPosition()
		local xCurr = posCurr.x
		local yCurr = posCurr.y
		local zCurr = posCurr.z

		--spriteTest
		--[[
		local spriteCurr = p.player:getSpriteType()
		spriteCurr:setSpriteColor(0,0,180)
		local itemId = createItem(spriteCurr:getId(), xCurr, yCurr, zCurr, 1, 1, 0)
		scheduleEvent(function()
			removeItem(itemId)
		end, animationDelay * 1.5)
		]]
		--Can't seem to get access to the caster's sprite

		local dirCurr = p.player:getDirection() + 1

		local xNew = xCurr + 1 * xTmp[dirCurr]
		local yNew = yCurr + 1 * yTmp[dirCurr]
		local zNew = zCurr
		local posNew = {x = xNew, y = yNew, z = zNew}

		--I would like to add a check if there is an obstacle in posNew, don't know how
		--keepRunning = false

		p.player:teleportTo(posNew)
		p.combat[dirCurr]:execute(p.player, p.variant)
	end
end

function onCastSpell(player, variant)
    local p = {player = player, variant = variant, combat = combat}

    local level = player:getLevel()
    local maglevel = player:getMagicLevel()
    local min = (level / 5) + (maglevel * 1.4) + 8
    local max = (level / 5) + (maglevel * 2.2) + 14

	--Run loop similar to Question5 for gradual movement
    for i = 1, range do
        addEvent(executeCombat6, animationDelay * (i - 1) + 1, p)
    end

    return true
end