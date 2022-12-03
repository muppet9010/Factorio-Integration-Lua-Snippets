/sc local playerName = "muppet9010"; local biterName = "%%USERNAME%%"; local biterNameColor = {1.0,1.0,1.0,1.0}; local biterNameSize = 2.0; local biterType = "behemoth-biter"; local closenessRange = 5; local exploringMaxRange = 15; local combatMaxRange = 50;
local biterStatusMessages_Wondering = {"exploring", "wondering"}; local biterStatusMessages_Following = {"coming", "running"}; local biterStatusMessages_CallBack = {"returning", "finished mauling them ?"}; local biterStatusMessages_GuardingCorpse = {"defending your corpse for your return", "too dumb to notice you've died"}; local biterStatusMessages_Dead = {"they were a loyal dumb beast to the end", "they won't be sorely missed"};
local player = game.get_player(playerName); if player == nil then; return; end;
local surface, playerPosition = player.surface, player.position;
local biterSpawnPosition = surface.find_non_colliding_position(biterType, playerPosition, 10, 0.1); if biterSpawnPosition == nil then; return; end;
local biter = surface.create_entity({name=biterType, position=biterSpawnPosition, force=player.force}); if biter == nil then; return; end;
biterName = biterName and (biterName .. " - ") or ""; local biterNameRenderId; if biterNameSize > 0 then; biterNameRenderId = rendering.draw_text({text=biterName .. biterStatusMessages_Wondering[math.random(#biterStatusMessages_Wondering)], surface=surface, target=biter, color=biterNameColor, alignment="center", vertical_alignment="top", scale=biterNameSize}); end;
--[[rendering.draw_text({text=biterName, surface=surface, target=biter, color=biterNameColor, alignment="center", vertical_alignment="bottom", scale=biterNameSize});]]
biter.ai_settings.allow_destroy_when_commands_fail = false; biter.ai_settings.allow_try_return_to_spawner = false; biter.ai_settings.do_separation = true;
local followPlayerFunc = function(data);
    data = data --[[@as BiterPet_Data]]
    if not data._biter.valid then; if data._biterName ~= "" then; data._player.print("RIP " .. data._biterName .. data._biterStatusMessages_Dead[math.random(#data._biterStatusMessages_Dead)] .. (data._debug and (" - " .. game.tick) or "")); end; return; end;
    if not data._player.valid then; return; end;
    if data._player.character == nil then;
        if data._hasOwner then; if data._biterNameRenderId then; rendering.set_text(data._biterNameRenderId, data._biterName .. data._biterStatusMessages_GuardingCorpse[math.random(#data._biterStatusMessages_GuardingCorpse)]); end; if data._debug then; data._player.print("guarding player corpse - TEST - " .. game.tick); end; data._hasOwner = false; end;
        remote.call("muppet_streamer", "add_delayed_lua", 60, data._followPlayerFuncDump, data); return;
    end;
    local targetEntity = data._player.vehicle or data._player.character; if targetEntity == nil then; return; end;
    local biterPosition, targetEntityPosition = data._biter.position, targetEntity.position; local biterPlayerDistance = (((biterPosition.x - targetEntityPosition.x) ^ 2) + ((biterPosition.y - targetEntityPosition.y) ^ 2)) ^ 0.5;
    if not data._hasOwner then;
        if biterPlayerDistance < data._exploringMaxRange then;
            if data._biterNameRenderId then; rendering.set_text(data._biterNameRenderId, data._biterName .. data._biterStatusMessages_Wondering[math.random(#data._biterStatusMessages_Wondering)]); end; if data._debug then; data._player.print("biter reclaimed by player - TEST - " .. game.tick); end; data._hasOwner = true; data._calledBack = false; data._following = false;
        end;
        remote.call("muppet_streamer", "add_delayed_lua", 60, data._followPlayerFuncDump, data); return;
    end;
    if biterPlayerDistance > data._exploringMaxRange + 1 then;
        local distractionCommand = data._biter.distraction_command;
        if distractionCommand ~= nil then;
            if biterPlayerDistance > data._combatMaxRange and not data._calledBack then;
                data._biter.set_command({type=defines.command.go_to_location, destination_entity=targetEntity, radius=data._closenessRange, distraction=defines.distraction.none});
                if data._biterNameRenderId then; rendering.set_text(data._biterNameRenderId, data._biterName .. data._biterStatusMessages_CallBack[math.random(#data._biterStatusMessages_CallBack)]); end; if data._debug then; data._player.print("biter called back to player - TEST - " .. game.tick); end data._calledBack = true;
            end;
        elseif not data._calledBack then;
            data._biter.set_command({type=defines.command.go_to_location, destination_entity=targetEntity, radius=data._closenessRange});
            if not data._following then; if data._biterNameRenderId then; rendering.set_text(data._biterNameRenderId, data._biterName .. data._biterStatusMessages_Following[math.random(#data._biterStatusMessages_Following)]); end; data._following = true; end; if data._debug then; data._player.print("follow me - TEST" .. " - " .. game.tick); end;
        end;
    else;
        if data._calledBack then;
            if data._biterNameRenderId then; rendering.set_text(data._biterNameRenderId, data._biterName .. data._biterStatusMessages_Wondering[math.random(#data._biterStatusMessages_Wondering)]); end; if data._debug then; data._player.print("biter returned to player - TEST - " .. game.tick); end; data._calledBack = false; data._following = false;
        elseif data._following then;
            if data._biterNameRenderId then; rendering.set_text(data._biterNameRenderId, data._biterName .. data._biterStatusMessages_Wondering[math.random(#data._biterStatusMessages_Wondering)]); end; if data._debug then; data._player.print("biter caught up to player - TEST - " .. game.tick); end; data._calledBack = false; data._following = false;
        end;
    end;
    remote.call("muppet_streamer", "add_delayed_lua", 60, data._followPlayerFuncDump, data);
end;
local data = {_player=player, _biter=biter, _followPlayerFuncDump=string.dump(followPlayerFunc), _closenessRange=closenessRange, _exploringMaxRange=math.max(exploringMaxRange, 10+closenessRange), _combatMaxRange=combatMaxRange, _calledBack=false, _following=false, _biterName=biterName, _hasOwner=true, _debug=true, _biterNameRenderId=biterNameRenderId, _biterStatusMessages_Wondering=biterStatusMessages_Wondering, _biterStatusMessages_Following=biterStatusMessages_Following, _biterStatusMessages_CallBack=biterStatusMessages_CallBack, _biterStatusMessages_GuardingCorpse=biterStatusMessages_GuardingCorpse, _biterStatusMessages_Dead=biterStatusMessages_Dead };
remote.call("muppet_streamer", "add_delayed_lua", 0, data._followPlayerFuncDump, data);