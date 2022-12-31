# This just replaces code variables listed prior to manual minification. Its a manual list and so needs to be updated for each new version.

$fullText = Get-Content -Path ".\Biter Pet\Biter Pet - Readable.lua" -Raw

$variableNamesToReplace = [System.Collections.ArrayList]::new()
$variableNamesToReplace.Add("playerObj") > $null
$variableNamesToReplace.Add("biterSurface") > $null
$variableNamesToReplace.Add("playerPosition") > $null
$variableNamesToReplace.Add("biterType") > $null
$variableNamesToReplace.Add("biterBonusHealthMax") > $null
$variableNamesToReplace.Add("biterHealingPerSecond") > $null
$variableNamesToReplace.Add("biterMaxHealth") > $null
$variableNamesToReplace.Add("biterPrototype") > $null
$variableNamesToReplace.Add("enemyEvo") > $null
$variableNamesToReplace.Add("evoReq") > $null
$variableNamesToReplace.Add("thisBonusHealth") > $null
$variableNamesToReplace.Add("thisBiterType") > $null
$variableNamesToReplace.Add("biterSpawnPosition") > $null
$variableNamesToReplace.Add("biter") > $null
$variableNamesToReplace.Add("biterNameRenderId") > $null
$variableNamesToReplace.Add("biterStateRenderId") > $null
$variableNamesToReplace.Add("biterHealthRenderId") > $null
$variableNamesToReplace.Add("stickerBox") > $null
$variableNamesToReplace.Add("stickerBoxLargestSize") > $null
$variableNamesToReplace.Add("biterAiSettings") > $null
$variableNamesToReplace.Add("followPlayerFunc") > $null
$variableNamesToReplace.Add("data") > $null
$variableNamesToReplace.Add("deathMessage") > $null
$variableNamesToReplace.Add("biterHealth") > $null
$variableNamesToReplace.Add("healthBelowMax") > $null
$variableNamesToReplace.Add("updateHealthBar") > $null
$variableNamesToReplace.Add("healthToRecover") > $null
$variableNamesToReplace.Add("x_scale_multiplier") > $null
$variableNamesToReplace.Add("targetEntity") > $null
$variableNamesToReplace.Add("biterPosition") > $null
$variableNamesToReplace.Add("targetEntityPosition") > $null
$variableNamesToReplace.Add("biterPlayerDistance") > $null
$variableNamesToReplace.Add("_playerObj") > $null
$variableNamesToReplace.Add("_biter") > $null
$variableNamesToReplace.Add("_biterSurface") > $null
$variableNamesToReplace.Add("_biterBonusHealthMax") > $null
$variableNamesToReplace.Add("_biterBonusHealthCurrent") > $null
$variableNamesToReplace.Add("_biterHealingPerSecond") > $null
$variableNamesToReplace.Add("_biterMaxHealth") > $null
$variableNamesToReplace.Add("_followPlayerFuncDump") > $null
$variableNamesToReplace.Add("_closenessRange") > $null
$variableNamesToReplace.Add("_exploringMaxRange") > $null
$variableNamesToReplace.Add("_combatMaxRange") > $null
$variableNamesToReplace.Add("_calledBack") > $null
$variableNamesToReplace.Add("_following") > $null
$variableNamesToReplace.Add("_fighting") > $null
$variableNamesToReplace.Add("_biterName") > $null
$variableNamesToReplace.Add("_hasOwner") > $null
$variableNamesToReplace.Add("_lastPosition") > $null
#$variableNamesToReplace.Add("_debug") > $null # Don't remove as we want to detect the code blocks and delete them.
$variableNamesToReplace.Add("_biterDetailsSize") > $null
$variableNamesToReplace.Add("_biterDetailsColor") > $null
$variableNamesToReplace.Add("_biterNameRenderId") > $null
$variableNamesToReplace.Add("_biterStateRenderId") > $null
$variableNamesToReplace.Add("_biterHealthRenderId") > $null
$variableNamesToReplace.Add("_biterDeathMessageDuration") > $null
$variableNamesToReplace.Add("_biterDeathMessagePrint") > $null
$variableNamesToReplace.Add("_biterStatusMessages_Wondering") > $null
$variableNamesToReplace.Add("_biterStatusMessages_Following") > $null
$variableNamesToReplace.Add("_biterStatusMessages_Fighting") > $null
$variableNamesToReplace.Add("_biterStatusMessages_CallBack") > $null
$variableNamesToReplace.Add("_biterStatusMessages_GuardingCorpse") > $null
$variableNamesToReplace.Add("_biterStatusMessages_Dead") > $null
# $variableNamesToReplace.Add("") > $null

for ($i = 0; $i -lt $variableNamesToReplace.Count; $i++) {
    $fullText = $fullText -replace (" " + $variableNamesToReplace[$i] + " "), (" v" + $i + " ")
    $fullText = $fullText -replace (" " + $variableNamesToReplace[$i] + ","), (" v" + $i + ",")
    $fullText = $fullText -replace (" " + $variableNamesToReplace[$i] + "\r\n"), (" v" + $i + "`r`n")
    $fullText = $fullText -replace (" " + $variableNamesToReplace[$i] + "\)"), (" v" + $i + ")")
    $fullText = $fullText -replace (" " + $variableNamesToReplace[$i] + "\."), (" v" + $i + ".")

    $fullText = $fullText -replace ("\(" + $variableNamesToReplace[$i] + " "), ("(v" + $i + " ")
    $fullText = $fullText -replace ("\(" + $variableNamesToReplace[$i] + ","), ("(v" + $i + ",")
    $fullText = $fullText -replace ("\(" + $variableNamesToReplace[$i] + "\)"), ("(v" + $i + ")")
    $fullText = $fullText -replace ("\(" + $variableNamesToReplace[$i] + "\."), ("(v" + $i + ".")

    $fullText = $fullText -replace ("\r\n" + $variableNamesToReplace[$i] + "\."), ("`r`nv" + $i + ".") # Have to use preivous line endings as the start of line detection `^` didn't trigger.

    $fullText = $fullText -replace ("\[" + $variableNamesToReplace[$i] + "\]"), ("[v" + $i + "]")

    $fullText = $fullText -replace ("\." + $variableNamesToReplace[$i] + " "), (".v" + $i + " ")
    $fullText = $fullText -replace ("\." + $variableNamesToReplace[$i] + ","), (".v" + $i + ",")
    $fullText = $fullText -replace ("\." + $variableNamesToReplace[$i] + "\r\n"), (".v" + $i + "`r`n")
    $fullText = $fullText -replace ("\." + $variableNamesToReplace[$i] + "\."), (".v" + $i + ".")
    $fullText = $fullText -replace ("\." + $variableNamesToReplace[$i] + "\["), (".v" + $i + "[")
    $fullText = $fullText -replace ("\." + $variableNamesToReplace[$i] + "\)"), (".v" + $i + ")")
}

$fullText | Out-File -FilePath ".\Biter Pet\Biter Pet - Test.lua"