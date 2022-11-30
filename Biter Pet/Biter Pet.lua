/sc local player = game.get_player("muppet9010"); local biterType = "behemoth-biter"; local followRange=5; local leashMinRange=10; local leashMaxRange=50;
if player == nil then; return; end;
local surface, playerPosition, viewerName = player.surface, player.position, "%%USERNAME%%";
local biterSpawnPosition = surface.find_non_colliding_position(biterType, playerPosition, 10, 0.1); if biterSpawnPosition == nil then; return; end;
local biter = surface.create_entity({name=biterType, position=biterSpawnPosition, force=player.force}); if biter == nil then; return; end; rendering.draw_text({text=viewerName, surface=surface, target=biter, color={1,1,1,1}});
local followPlayerFunc = function(data);
    if not data.biter.valid then; data.player.print("RIP " .. data.viewerName .. ", they were a loyal dumb beast to the end"); return; end;
    if not data.player.valid then; return; end;
    if data.player.character == nil then;
        if data.hasOwner then; data.player.print("good " .. data.viewerName .. ", you protect my corpse until I return")--[[ .. " - " .. game.tick);]]; data.hasOwner = false; end;
        remote.call("muppet_streamer", "add_delayed_lua", 60, data.followPlayerFuncDump, data); return;
    end;
    local targetEntity = data.player.vehicle or data.player.character; if targetEntity == nil then; return; end;
    local biterPosition, targetEntityPosition = data.biter.position, targetEntity.position; local biterPlayerDistance = (((biterPosition.x - targetEntityPosition.x) ^ 2) + ((biterPosition.y - targetEntityPosition.y) ^ 2)) ^ 0.5;
    if not data.hasOwner then;
        if biterPlayerDistance < data.leashMinRange then;
            data.player.print("I have returned for you " .. data.viewerName)--[[ .. " - " .. game.tick);]]; data.hasOwner = true; data.calledBack = false;
        else;
            remote.call("muppet_streamer", "add_delayed_lua", 60, data.followPlayerFuncDump, data); return;
        end;
    end;
    if biterPlayerDistance > data.leashMinRange then;
        local distractionCommand = data.biter.distraction_command;
        if distractionCommand ~= nil then;
            if biterPlayerDistance > data.leashMaxRange and not data.calledBack then;
                data.biter.set_command({type=defines.command.go_to_location, destination_entity=targetEntity, radius=data.followRange, distraction=defines.distraction.none});
                data.player.print("here " .. data.viewerName .. ", leave them be")--[[ .. " - " .. game.tick);]] data.calledBack = true;
            end;
        elseif not data.calledBack then;
            data.biter.set_command({type=defines.command.go_to_location, destination_entity=targetEntity, radius=data.followRange});
            --[[data.player.print("follow me - TEST" .. " - " .. game.tick);]]
        end;
    elseif biterPlayerDistance < data.leashMinRange and data.calledBack then;
        data.player.print(data.viewerName .. " who's a good biter then ... yes you are")--[[ .. " - " .. game.tick);]] data.calledBack = false;
    end;
    remote.call("muppet_streamer", "add_delayed_lua", 60, data.followPlayerFuncDump, data); return;
end;
local data = {player=player, biter=biter, followPlayerFuncDump=string.dump(followPlayerFunc), followRange=followRange, leashMinRange=leashMinRange, leashMaxRange=leashMaxRange, calledBack=false, viewerName=viewerName, hasOwner=true };
remote.call("muppet_streamer", "add_delayed_lua", 0, string.dump(followPlayerFunc), data);
--[[ Takes in %%USERNAME%% from JD integration tool. ]]