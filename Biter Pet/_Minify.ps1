# This replaces hard coded code variables with minimal text strings prior to automated minification. Its a manual list and so needs to be updated for each new version.
# This minify will remove the debug code blocks from the script entirely. However, it will only handle `if end` blocks when the if part is just the data object variable `data._debug`. And it won;t handle if there are any `if` blocks within it, as it will just stop at the first `end` found.




# ------------------------------------------------------------------------------------------------
# Get the full text of the script as one text block.
# ------------------------------------------------------------------------------------------------

$fullText = Get-Content -Path ".\Biter Pet\Biter Pet - Readable.lua" -Raw




# ------------------------------------------------------------------------------------------------
# Minify our list of variables and class fields. This is a static list so we can avoid conflicting with any built in Factorio key names, i.e. `game`.
# ------------------------------------------------------------------------------------------------

# ------------------------------------------
# Manually made list of variables to minify to a variable number.
# ------------------------------------------

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

# ------------------------------------------
# Do each combination of preceeding and trailing characters for our variable names.
# ------------------------------------------

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

    $fullText = $fullText -replace ("#" + $variableNamesToReplace[$i] + " "), ("#v" + $i + " ")
    $fullText = $fullText -replace ("#" + $variableNamesToReplace[$i] + ","), ("#v" + $i + ",")
    $fullText = $fullText -replace ("#" + $variableNamesToReplace[$i] + "\r\n"), ("#v" + $i + "`r`n")
    $fullText = $fullText -replace ("#" + $variableNamesToReplace[$i] + "\)"), ("#v" + $i + ")")
    $fullText = $fullText -replace ("#" + $variableNamesToReplace[$i] + "\."), ("#v" + $i + ".")

    $fullText = $fullText -replace ("\." + $variableNamesToReplace[$i] + " "), (".v" + $i + " ")
    $fullText = $fullText -replace ("\." + $variableNamesToReplace[$i] + ","), (".v" + $i + ",")
    $fullText = $fullText -replace ("\." + $variableNamesToReplace[$i] + "\r\n"), (".v" + $i + "`r`n")
    $fullText = $fullText -replace ("\." + $variableNamesToReplace[$i] + "\."), (".v" + $i + ".")
    $fullText = $fullText -replace ("\." + $variableNamesToReplace[$i] + "\["), (".v" + $i + "[")
    $fullText = $fullText -replace ("\." + $variableNamesToReplace[$i] + "\)"), (".v" + $i + ")")
}




# ------------------------------------------------------------------------------------------------
# Automate the minification of the content.
# ------------------------------------------------------------------------------------------------


# ------------------------------------------
# Get the different sections of the code before we strip out the commends.
# ------------------------------------------

$splits = $fullText -split "`r`n", 2
$commandCallText = $splits[0]
$currentRemaingText = $splits[1]

$splits = $currentRemaingText -split "--\[\[ CODE START \]\]`r`n", 2
$settingText = $splits[0]
$codeText = $splits[1]


# ------------------------------------------
# Do the file wide cleaning.
# ------------------------------------------

$generalTextsToPass = @{settingText = $settingText
    codeText = $codeText}
foreach ($entry in $generalTextsToPass.GetEnumerator()) {
    $value = $entry.Value

    # Remove any Sumneko TypeDefs and any comments.
    $value = $value -replace "--\[\[.*?\]\](`r`n)*", ''

    # Removes any extra spacer lines (empty line gaps).
    $value = $value -replace "`r`n`r`n", "`r`n"

    # Remove any indentation of 2 or more spaces.
    $value = $value -replace '( ){2,}', ''

    Set-Variable -Name $entry.Key -Value $value
}


# ------------------------------------------
# Settings cleaning.
# ------------------------------------------

# Remove the line breaks, but put a space for readability in.
$settingText = $settingText -replace "`r`n", '; '

# Add the line spacing for the setting groups.
$settingText = $settingText -replace '(local biterTypeSelection =)', ("`r`n" + '${1}')
$settingText = $settingText -replace '(local biterStatusMessages_Wondering)', ("`r`n" + '${1}')

# Cleanse any trailing spaces.
$settingText = $settingText -replace "(; `r`n)", ";`r`n"
$settingText = $settingText -replace "(; $)", ";"


# ------------------------------------------
# Code cleaning.
# ------------------------------------------

# Remove any debug blocks - Only handles debug if blocks that have no depth to them.
$codeText = $codeText -replace "if v\d+._debug then(?:(\s|\S|/n|/r))*?end(`r`n)*", ''
$codeText = $codeText -replace '_debug = [^,]+,', ''

# Remove the line breaks.
$codeText = $codeText -replace "`r`n", ';' # Somehow this leaves a trailing `\r\n` I can't remove.

# Remove the space around operators.
$codeText = $codeText -replace '\s*([=~<>,+-\/*^{}])\s*', '${1}'

# Push the version on to its own line.
$codeText = $codeText -replace '(local version=.*;)$', ("`r`n" + '${1}')



# ------------------------------------------------------------------------------------------------
# Write out the file.
# ------------------------------------------------------------------------------------------------

$outputText = $commandCallText + ' ' + $settingText + "`r`n" + $codeText
$outputText | Out-File -FilePath '.\Biter Pet\Biter Pet - Minified.lua'