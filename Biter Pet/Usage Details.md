# Features

Creates a behemoth biter that follows the player around and protects them.

This script has some features over a simple biter creation command:

- It will keep on following the player as they get in and out of vehicles.
- The biter can be given a personal name in colored text as a nice touch for chat integrations when streaming.
- The biter will have its state/activity included in a label on it.
- If the player dies the biter will stay at their body until they return to the biter to collect it again.
- The biter will follow the player within some set ranges when just moving around.
- When the biter enters combat it can stray much further from the player, but if it gets too far then it will break off combat and return to its master. This means if the player runs away from a biter base your pet will eventually follow assuming it is still alive.
- The biter type is selected based on the enemy force evolution.
- It can also have bonus health based on enemy evolution. If so it will have a shared total health bar to show it's real and bonus health. Bonus health regenerates just like normal health when the biter is fully healed on real health.

Requires the Muppet Streamer mod: https://mods.factorio.com/mod/muppet_streamer



# Configuration

All options are at the start of the script.

### Mandatory options to configure

The options that must be changed:

| Setting Name | Description |
| --- | --- |
| playerName | Should be set to your own in-game name (case sensitive), so replace `"muppet9010"`. |
| biterName | Should be set to the personal name of the biter to be displayed. The default value is `"%%USERNAME%%"` which is from the JS integration tool that JD-Plays uses and that tool replaces it for a name from his Twitch chat. Either replace this with a desired personal name of the biter from your own integration tool, set it to a static string value or just set it to a blank string `""`. A blank string will not raise any messages when the biter is killed.|

### Optional options to configure

The general options that can be changed from default are:

| Setting Name | Description |
| --- | --- |
| biterDetailsColor | Is the color of the labels of the biter. It's a Lua table of the Red, Green, Blue and Alpha values in order. Values should all be between 0-1 or 0-255, but don't mix them. |
| biterDetailsSize | Is the size of the text for the biter name (if present) and the biter's state. A size of 0 will mean no label on the biters when they are alive or dead. Also if there is bonus health on the pet then the health bar is hidden when this is set to 0. |
| biterDeathMessageDuration | Is how many ticks (1/60 second) that the biters death message label is shown on the biter for. A value of 0 means no death message is shown. The default value of 1800 is 30 seconds. |
| biterDeathMessagePrint | If the death of a pet is announced in chat and if so who to. Options are: `"not"`, `"master"`, `"everyone"`. |
| closenessRange | Is how close to you the biter will move to when it actively returns or follows you. So when it's called this is how close it comes before it considers itself returned. |
| exploringMaxRange | Is how far away from its master a biter can be before it considers itself too far and returns to be within the `closenessRange` distance from you. It's also the distance a biter can be reclaimed by its master after the master dies and respawns. This value can't be less than the `closenessRange` value plus 10 (how far biters will wonder around). |
| combatMaxRange | Is how far away the biter will happily be from its master when it's in combat. If it gets further than this it will break off combat and return to its master. |

### Optional biter pet type based on enemy evolution

The `biterTypeSelection` option is a table of the type of biter your pet will be based on the evolution of the `enemy` force.

The default setting is to have a biter 1 type higher than the enemy can have.

- The list has the evolution required to unlock the biter type as the key, with the biter type name as the value.
- The evolution key must be wrapped in square brackets when provided as this is now Lua works.
- The last entry in the `biterTypeSelection` list that has an evo requirement less than current enemy force evo will be selected. So having the entries in order of minimum to maximum evo needed is important.
- Any `unit` prototype name can be used; in vanilla Factorio these are the biter and spitter types, plus compilatron.

If you only want one biter type to always be selected then you can just set that type for enemy evolution of 0 and above:
```Lua
local biterTypeSelection = {[0]="behemoth-biter"};
```

### Optional biter pet bonus health based on enemy evolution

The `biterBonusHealthSelection` option is a table of bonus health your pet will get based on the evolution of the `enemy` force.

The default setting is to have bonus health equal to the biter (doubling their health), with 4 times the health when the enemy starts getting their own behemoth biters.

- The list has the evolution required to unlock the biter type as the key, with the bonus health amount as the value.
- The evolution key must be wrapped in square brackets when provided as this is now Lua works.
- The last entry in the `biterBonusHealthSelection` list that has an evo requirement less than current enemy force evo will be selected. So having the entries in order of minimum to maximum evo needed is important.
- Any value of 0 or greater is supported.
- If bonus health is set for the pet and `biterDetailsSize` is not disabled (value of 0) then a combined real and bonus health bar will be shown above the biter. The health bar code is borrowed from Comfy Biter Battles scenario.

If you don't want any health bonus then you can just set a 0 bonus health value for enemy evolution of 0 and above:
```Lua
local biterBonusHealthSelection = {[0]=0};
```

### Optional status message text to configure

The status messages that are shown on the biter (assuming `biterDetailsSize` setting is above 0) are configurable with the below setting names. A random message from the appropriate state message array is selected for showing when the biter enters each state. You can have as many entries as you like in a state's message array, but but have at least 1 in each. The status messages some with some generic "pet" type messages.

| Setting Name | Description |
| --- | --- |
| biterStatusMessages_Wondering | Is when the biter is just wondering around you. |
| biterStatusMessages_Following | Is when the biter is moving to keep up with you and was previous wondering around you. |
| biterStatusMessages_Fighting | Is when the biter is fighting enemies. |
| biterStatusMessages_CallBack | Is when the biter has been called back from fighting enemies from far away to you. |
| biterStatusMessages_GuardingCorpse | Is when the biter is guarding your corpse and awaiting your return to reclaim it. |
| biterStatusMessages_Dead | Is when the biter has died. This message is shown over/near its corpse for the `biterDeathMessageDuration` setting duration of ticks. Note that this may not always be directly on the biter's corpse. |



# Limitations

- The reactions to the biters state only run at a set interval and so can be a fraction of a second behind in timing or location. This is due to this being a script and not a full blown mod.
- The biter uses standard Biter AI to control it. This means it doesn't always attack the nearest things and can get stuck on silly things at times.
- Biters can't open gates by default within Factorio. This can be changed by a setting in the Muppet Streamer mod, but unfortunately this script can't affect it at run time.
- Biters will tend to attack things and then happily chase on to further away targets. Until they reach the `combatMaxRange` and are called all the way back to you. Think out of control dog chasing wildlife in field.
- The biters can't have their map color changed upon creating or via this script. They will appear whatever color the unit's prototype color is set, so could be changed by a mod in the data stage.
- The bonus health is applied to the Pet Biters every processing cycle. This means that if the biter goes from full health to dead during a single processing cycle the bonus health will be lost.
- The labels and health bar are offset from the biter's by approximately the right distance so you can still see their graphics. This is based on the configurable font size and a stand-in approximate value for the graphics size, as there is no way to check this directly. This does mean that the text may not be quite offset right in all cases or for some modded biters that don't keep a proportional sticker box (used for fire and slow stickers) to visual graphics.