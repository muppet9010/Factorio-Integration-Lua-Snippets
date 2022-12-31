/sc
local playerName = "muppet9010"
local biterName = "%%USERNAME%%"
local biterDetailsColor = { 1.0, 1.0, 1.0, 1.0 }
local biterDetailsSize = 1.5
local biterDeathMessageDuration = 1800
local biterDeathMessagePrint = "master"
local closenessRange = 5
local exploringMaxRange = 15
local combatMaxRange = 50
local biterTypeSelection = { [0] = "medium-biter", [0.2] = "big-biter", [0.5] = "behemoth-biter" }
local biterBonusHealthSelection = { [0] = 75, [0.2] = 375, [0.5] = 3000, [0.9] = 12000 }
local biterStatusMessages_Wondering = { "Waiting for you to do something interesting", "Supervising you" }
local biterStatusMessages_Following = { "Walkies", "Are we there yet ?" }
local biterStatusMessages_Fighting = { "Off catching you a present", "Playing with new friends " }
local biterStatusMessages_CallBack = { "Aww bed time already ?", "Bringing you back a bloodied present" }
local biterStatusMessages_GuardingCorpse = { "Defending your corpse for your return", "Too dumb to notice you've died" }
local biterStatusMessages_Dead = { "They were a loyal dumb beast to the end", "Has gone to a better place to forever chase small squishy creatures" }
--[[ CODE START ]]
local playerObj = game.get_player(playerName)
if playerObj == nil then
    return
end
local biterSurface, playerPosition = playerObj.surface, playerObj.position
local biterType, biterBonusHealthMax, biterHealingPerSecond, biterMaxHealth, biterPrototype
local enemyEvo = game.forces["enemy"].evolution_factor
for evoReq, thisBiterType in pairs(biterTypeSelection) do
    if evoReq <= enemyEvo then
        biterType = thisBiterType
    end
end
for evoReq, thisBonusHealth in pairs(biterBonusHealthSelection) do
    if evoReq <= enemyEvo then
        biterBonusHealthMax = thisBonusHealth
    end
end
if biterBonusHealthMax > 0 then
    biterPrototype = game.entity_prototypes[biterType]
    biterHealingPerSecond = biterPrototype.healing_per_tick * 60
    biterMaxHealth = biterPrototype.max_health
end
local biterSpawnPosition = biterSurface.find_non_colliding_position(biterType, playerPosition, 10, 0.1)
if biterSpawnPosition == nil then
    return
end
local biter = biterSurface.create_entity({ name = biterType, position = biterSpawnPosition, force = playerObj.force })
if biter == nil then
    return
end
biterName = biterName or ""
local biterNameRenderId, biterStateRenderId, biterHealthRenderId
if biterDetailsSize > 0 then
    local stickerBox = biterPrototype.sticker_box --[[@as BoundingBox]]
    local stickerBoxLargestSize = math.max(stickerBox.right_bottom.x - stickerBox.left_top.x, stickerBox.right_bottom.y - stickerBox.left_top.y) * 1.5
    if biterBonusHealthMax > 0 then
        biterHealthRenderId = rendering.draw_sprite({ sprite = 'virtual-signal/signal-white', tint = { 0.0, 200.0, 0.0 }, x_scale = 0.6 * 8, y_scale = 0.6, render_layer = 'light-effect', target = biter, target_offset = { 0.0, (-0.5 - 0.5 - (biterDetailsSize / 2) - stickerBoxLargestSize) --[[@as float]] }, surface = biterSurface, vertical_alignment = "bottom" })
    end
    biterNameRenderId = rendering.draw_text({ text = biterName, surface = biterSurface, target = biter, target_offset = { 0.0, (-0.5 - stickerBoxLargestSize) --[[@as float]] }, color = biterDetailsColor, alignment = "center", vertical_alignment = "bottom", scale = biterDetailsSize })
    biterStateRenderId = rendering.draw_text({ text = biterStatusMessages_Wondering[math.random(#biterStatusMessages_Wondering)], surface = biterSurface, target = biter, color = biterDetailsColor, alignment = "center", vertical_alignment = "top", scale = biterDetailsSize })
end
local biterAiSettings = biter.ai_settings
biterAiSettings.allow_destroy_when_commands_fail = false
biterAiSettings.allow_try_return_to_spawner = false
biterAiSettings.do_separation = true
local followPlayerFunc = --[[@type fun(data: BiterPet_Data)]] function(data)
    if not data._biterSurface.valid then
        return
    end
    if not data._biter.valid then
        if data._biterDetailsSize > 0 then
            rendering.draw_text({ text = "RIP " .. data._biterName, surface = data._biterSurface, target = data._lastPosition, color = data._biterDetailsColor, alignment = "center", vertical_alignment = "bottom", scale = data._biterDetailsSize, time_to_live = data._biterDeathMessageDuration })
            rendering.draw_text({ text = data._biterStatusMessages_Dead[math.random(#data._biterStatusMessages_Dead)], surface = data._biterSurface, target = data._lastPosition, color = data._biterDetailsColor, alignment = "center", vertical_alignment = "top", scale = data._biterDetailsSize, time_to_live = data._biterDeathMessageDuration })
        end
        local deathMessage = "RIP " .. data._biterName .. " : [gps=" .. math.floor(data._lastPosition.x) .. "," .. math.floor(data._lastPosition.y) .. "," .. data._biterSurface.name .. "]"
        if data._biterDeathMessagePrint == "master" then
            data._playerObj.print(deathMessage)
        elseif data._biterDeathMessagePrint == "everyone" then
            game.print(deathMessage)
        end
        if data._debug then
            data._playerObj.print("biter died - TEST - " .. game.tick)
        end
        return
    end
    data._lastPosition = data._biter.position
    if data._biterBonusHealthMax > 0 then
        local biterHealth = data._biter.health
        local healthBelowMax = data._biterMaxHealth - biterHealth
        local updateHealthBar = false
        if healthBelowMax > 0 then
            updateHealthBar = true
            local healthToRecover = math.min(healthBelowMax, data._biterBonusHealthCurrent)
            if healthToRecover > 0 then
                data._biter.health = biterHealth + healthToRecover
                data._biterBonusHealthCurrent = data._biterBonusHealthCurrent - healthToRecover
                biterHealth = biterHealth + healthToRecover
            end
        elseif data._biterBonusHealthCurrent < data._biterBonusHealthMax then
            data._biterBonusHealthCurrent = math.min(data._biterBonusHealthCurrent + data._biterHealingPerSecond, data._biterBonusHealthMax)
            updateHealthBar = true
        end
        if updateHealthBar and data._biterHealthRenderId then
            local x_scale_multiplier = (biterHealth + data._biterBonusHealthCurrent) / (data._biterMaxHealth + data._biterBonusHealthMax)
            rendering.set_x_scale(data._biterHealthRenderId, 0.6 * 8 * x_scale_multiplier)
            rendering.set_color(data._biterHealthRenderId, { math.floor(255 - 255 * x_scale_multiplier) --[[@as float]] , math.floor(200 * x_scale_multiplier) --[[@as float]] , 0.0 })
        end
    end
    if not data._playerObj.valid then
        return
    end
    local targetEntity = data._playerObj.vehicle or data._playerObj.character
    if targetEntity == nil then
        if data._hasOwner then
            if data._biterStateRenderId then
                rendering.set_text(data._biterStateRenderId, data._biterStatusMessages_GuardingCorpse[math.random(#data._biterStatusMessages_GuardingCorpse)])
            end
            if data._debug then
                data._playerObj.print("guarding player corpse - TEST - " .. game.tick)
            end
            data._hasOwner = false
        end
        remote.call("muppet_streamer", "add_delayed_lua", 60, data._followPlayerFuncDump, data)
        return
    end
    local biterPosition, targetEntityPosition = data._biter.position, targetEntity.position
    local biterPlayerDistance = (((biterPosition.x - targetEntityPosition.x) ^ 2) + ((biterPosition.y - targetEntityPosition.y) ^ 2)) ^ 0.5
    if not data._hasOwner then
        if biterPlayerDistance < data._exploringMaxRange then
            if data._biterStateRenderId then
                rendering.set_text(data._biterStateRenderId, data._biterStatusMessages_Wondering[math.random(#data._biterStatusMessages_Wondering)])
            end
            if data._debug then
                data._playerObj.print("biter reclaimed by player - TEST - " .. game.tick)
            end
            data._hasOwner = true
            data._calledBack = false
            data._following = false
        end
        remote.call("muppet_streamer", "add_delayed_lua", 60, data._followPlayerFuncDump, data)
        return
    end
    if biterPlayerDistance > data._exploringMaxRange + 1 then
        if data._biter.distraction_command ~= nil then
            if biterPlayerDistance > data._combatMaxRange then
                if not data._calledBack then
                    if data._biterStateRenderId then
                        rendering.set_text(data._biterStateRenderId, data._biterStatusMessages_CallBack[math.random(#data._biterStatusMessages_CallBack)])
                    end
                    data._biter.set_command({ type = defines.command.go_to_location, destination_entity = targetEntity, radius = data._closenessRange, distraction = defines.distraction.none })
                    data._calledBack = true
                    data._fighting = false
                    if data._debug then
                        data._playerObj.print("biter called back to player - TEST - " .. game.tick)
                    end
                end
            else
                if not data._fighting then
                    if data._biterStateRenderId then
                        rendering.set_text(data._biterStateRenderId, data._biterStatusMessages_Fighting[math.random(#data._biterStatusMessages_Fighting)])
                    end
                    if data._debug then
                        data._playerObj.print("biter started fighting far away - TEST - " .. game.tick)
                    end
                    data._fighting = true
                end
            end
        elseif not data._calledBack then
            data._biter.set_command({ type = defines.command.go_to_location, destination_entity = targetEntity, radius = data._closenessRange })
            if data._debug then
                data._playerObj.print("follow me - TEST" .. " - " .. game.tick)
            end
            if not data._following then
                if data._biterStateRenderId then
                    rendering.set_text(data._biterStateRenderId, data._biterStatusMessages_Following[math.random(#data._biterStatusMessages_Following)])
                end
                data._following = true
                data._fighting = false
            end
        end
    else
        if data._biter.distraction_command ~= nil then
            if not data._fighting then
                if data._biterStateRenderId then
                    rendering.set_text(data._biterStateRenderId, data._biterStatusMessages_Fighting[math.random(#data._biterStatusMessages_Fighting)])
                end
                if data._debug then
                    data._playerObj.print("biter started fighting near by - TEST - " .. game.tick)
                end
                data._fighting = true
            end
        else
            if data._calledBack or data._following or data._fighting then
                if data._biterStateRenderId then
                    rendering.set_text(data._biterStateRenderId, data._biterStatusMessages_Wondering[math.random(#data._biterStatusMessages_Wondering)])
                end
                if data._debug then
                    data._playerObj.print("biter either: stopped fighting near player, caught up or returned to player - TEST - " .. game.tick)
                end
                data._calledBack = false
                data._following = false
                data._fighting = false
            end
        end
    end
    remote.call("muppet_streamer", "add_delayed_lua", 60, data._followPlayerFuncDump, data)
end

local data = { _playerObj = playerObj, _biter = biter, _biterSurface = biterSurface, _biterBonusHealthMax = biterBonusHealthMax, _biterBonusHealthCurrent = biterBonusHealthMax, _biterHealingPerSecond = biterHealingPerSecond, _biterMaxHealth = biterMaxHealth, _followPlayerFuncDump = string.dump(followPlayerFunc), _closenessRange = closenessRange, _exploringMaxRange = math.max(exploringMaxRange, 10 + closenessRange), _combatMaxRange = combatMaxRange, _calledBack = false, _following = false, _fighting = false, _biterName = biterName, _hasOwner = true, _lastPosition = biter.position, _debug = false, _biterDetailsSize = biterDetailsSize, _biterDetailsColor = biterDetailsColor, _biterNameRenderId = biterNameRenderId, _biterStateRenderId = biterStateRenderId, _biterHealthRenderId = biterHealthRenderId, _biterDeathMessageDuration = biterDeathMessageDuration, _biterDeathMessagePrint = biterDeathMessagePrint, _biterStatusMessages_Wondering = biterStatusMessages_Wondering, _biterStatusMessages_Following = biterStatusMessages_Following, _biterStatusMessages_Fighting = biterStatusMessages_Fighting, _biterStatusMessages_CallBack = biterStatusMessages_CallBack, _biterStatusMessages_GuardingCorpse = biterStatusMessages_GuardingCorpse, _biterStatusMessages_Dead = biterStatusMessages_Dead }
remote.call("muppet_streamer", "add_delayed_lua", 0, data._followPlayerFuncDump, data)

local version = "1.0.1"
