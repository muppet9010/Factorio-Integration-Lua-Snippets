# This replaces variable names and Delayed Lua Data field names with minimal text strings prior to automated minification. It's a dynamically generated list based on the comment tags to seperate out the code areas with different handling in each.
# This minify will remove the debug code blocks from the script entirely. However, it will only handle `if end` blocks when the if part is just the data object variable `data._debug`. And it won;t handle if there are any `if` blocks within it, as it will just stop at the first `end` found.




# ------------------------------------------------------------------------------------------------
# Get the full text of the script as one text block.
# ------------------------------------------------------------------------------------------------

$fullText = Get-Content -Path ".\Biter Pet\Biter Pet - Readable.lua" -Raw




# ------------------------------------------------------------------------------------------------
# Initial cleans before we review variables.
# ------------------------------------------------------------------------------------------------

# Remove any debug blocks - Only handles debug if blocks that have no depth to them.
$fullText = $fullText -replace "if data._debug then(?:(\s|\S|/n|/r))*?end(`r`n)*", ''
$fullText = $fullText -replace '_debug = [^,]+,', ''




# ------------------------------------------------------------------------------------------------
# Minify our list of variables and class fields.
# ------------------------------------------------------------------------------------------------


# ------------------------------------------
# Generated list of variables to minify to a variable number.
# ------------------------------------------

$variableNamesToReplace = [System.Collections.Hashtable]::new()#[System.Collections.ArrayList]::new()

$splits = $fullText -split "--\[\[ CODE START \]\]`r`n", 2
$initialSettingText = $splits[0] # We just ignore this section when looking for variable names at present, but need to still split it out.
$splits = $splits[1] -split "--\[\[ Delayed Lua Function \]\]`r`n", 2
$initialCodeText = $splits[0]
$splits = $splits[1] -split "--\[\[ Delayed Lua Data \]\]`r`n", 2
$initialLuaFunctionText = $splits[0]
$splits = $splits[1] -split "--\[\[ Version Info \]\]`r`n", 2
$initialLuaDataText = $splits[0]

# Extract the variable names.
function ExtractVariableNames {
    param (
        [Microsoft.PowerShell.Commands.MatchInfo]$variableStrings
    )

    foreach ($variableMatch in $variableStrings.Matches) {
        for ($variableMatchGroupIndex = 1; $variableMatchGroupIndex -lt $variableMatch.Groups.Count; $variableMatchGroupIndex++) {
            $variableMatchString = $variableMatch.Groups[$variableMatchGroupIndex].Value.Trim()
            $variables = $variableMatchString | Select-String -Pattern "([^, ]+)" -AllMatches
            foreach ($variable in $variables.Matches) {
                $variableNamesToReplace[$variable.Value] = $true# > $null
            }
        }
    }
}

# ------------------------------------------
# Code Text
# ------------------------------------------

# Variables with and without values set, as a single or comma seperated string.
$variableStrings = $initialCodeText | Select-String -Pattern "local ([^=\n]+)(?: =|[^=]\n)?" -AllMatches
ExtractVariableNames -variableStrings $variableStrings
#$variableStrings = $initialCodeText | Select-String -Pattern "local (.+) =" # Variables with values set.
#$variableStrings = $initialCodeText | Select-String -Pattern "local (.+) \n" # Variables without values set.

# Variables set within a `for`, as a single or comma seperated string.
$variableStrings = $initialCodeText | Select-String -Pattern "for ([^,]+), ([^,]+) in" -AllMatches
ExtractVariableNames -variableStrings $variableStrings

# ------------------------------------------
# Delayed Lua Function Text
# ------------------------------------------

# Variables with and without values set, as a single or comma seperated string.
$variableStrings = $initialLuaFunctionText | Select-String -Pattern "local ([^=\n]+)(?: =|[^=]\n)?" -AllMatches
ExtractVariableNames -variableStrings $variableStrings

# Variables set within a `for`, as a single or comma seperated string.
$variableStrings = $initialLuaFunctionText | Select-String -Pattern "for ([^,]+), ([^,]+) in" -AllMatches
ExtractVariableNames -variableStrings $variableStrings

# ------------------------------------------
# Delayed Lua Data Text
# ------------------------------------------

# Variables with and without values set, as a single or comma seperated string.
$variableStrings = $initialLuaDataText | Select-String -Pattern "local ([^=\n]+)(?: =|[^=]\n)?" -AllMatches
ExtractVariableNames -variableStrings $variableStrings

# Variables set within a `for`, as a single or comma seperated string.
$variableStrings = $initialLuaDataText | Select-String -Pattern "for ([^,]+), ([^,]+) in" -AllMatches
ExtractVariableNames -variableStrings $variableStrings

# The Data object's keys (but not values). This captures a lot of empty matches due to the odd way regex matches are returned, but our code already ignores them effectively as it ignores the first inner data object, and these empty matches only have 1 inner data object.
$variableStrings = $initialLuaDataText | Select-String -Pattern "(?: (?<fieldName>\S+) =)*" -AllMatches

ExtractVariableNames -variableStrings $variableStrings

# ------------------------------------------
# Do each combination of preceeding and trailing characters for our variable names.
# ------------------------------------------

$i = 0
foreach ($variableName in $variableNamesToReplace.Keys) {
    $fullText = $fullText -replace (" " + $variableName + " "), (" v" + $i + " ")
    $fullText = $fullText -replace (" " + $variableName + ","), (" v" + $i + ",")
    $fullText = $fullText -replace (" " + $variableName + "\r\n"), (" v" + $i + "`r`n")
    $fullText = $fullText -replace (" " + $variableName + "\)"), (" v" + $i + ")")
    $fullText = $fullText -replace (" " + $variableName + "\."), (" v" + $i + ".")

    $fullText = $fullText -replace ("\(" + $variableName + " "), ("(v" + $i + " ")
    $fullText = $fullText -replace ("\(" + $variableName + ","), ("(v" + $i + ",")
    $fullText = $fullText -replace ("\(" + $variableName + "\)"), ("(v" + $i + ")")
    $fullText = $fullText -replace ("\(" + $variableName + "\."), ("(v" + $i + ".")

    $fullText = $fullText -replace ("\r\n" + $variableName + "\."), ("`r`nv" + $i + ".") # Have to use preivous line endings as the start of line detection `^` didn't trigger.

    $fullText = $fullText -replace ("\[" + $variableName + "\]"), ("[v" + $i + "]")

    $fullText = $fullText -replace ("#" + $variableName + " "), ("#v" + $i + " ")
    $fullText = $fullText -replace ("#" + $variableName + ","), ("#v" + $i + ",")
    $fullText = $fullText -replace ("#" + $variableName + "\r\n"), ("#v" + $i + "`r`n")
    $fullText = $fullText -replace ("#" + $variableName + "\)"), ("#v" + $i + ")")
    $fullText = $fullText -replace ("#" + $variableName + "\."), ("#v" + $i + ".")

    $fullText = $fullText -replace ("\." + $variableName + " "), (".v" + $i + " ")
    $fullText = $fullText -replace ("\." + $variableName + ","), (".v" + $i + ",")
    $fullText = $fullText -replace ("\." + $variableName + "\r\n"), (".v" + $i + "`r`n")
    $fullText = $fullText -replace ("\." + $variableName + "\."), (".v" + $i + ".")
    $fullText = $fullText -replace ("\." + $variableName + "\["), (".v" + $i + "[")
    $fullText = $fullText -replace ("\." + $variableName + "\)"), (".v" + $i + ")")

    $i++
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
$codeAllText = $splits[1]


# ------------------------------------------
# Do the file wide cleaning.
# ------------------------------------------

$generalTextsToPass = @{
    settingText = $settingText
    codeAllText = $codeAllText
}
foreach ($entry in $generalTextsToPass.GetEnumerator()) {
    $value = $entry.Value

    # Remove any Sumneko TypeDefs and any comments. This can leave empty spaces at the end of a line when the comment was on the end of a line, but wasn't the whole line. As in these cases we can't remove the line break, as then we'd join the code on the line with the next line.
    $value = $value -replace "--\[\[.*?\]\]", ''

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

# Remove the line breaks.
$codeAllText = $codeAllText -replace "`r`n", ';' # Somehow this leaves a trailing `\r\n` I can't remove.

# Remove the space around operators.
$codeAllText = $codeAllText -replace '\s*([=~<>,+-\/*^{}])\s*', '${1}'

# Push the version on to its own line.
$codeAllText = $codeAllText -replace '(local version=.*;)$', ("`r`n" + '${1}')




# ------------------------------------------------------------------------------------------------
# Merge and write out the file.
# ------------------------------------------------------------------------------------------------

$outputText = $commandCallText + ' ' + $settingText + "`r`n" + $codeAllText

# ------------------------------------------
# Quick touch up cleaning across whole file.
# ------------------------------------------

$outputText = $outputText -replace ' ;', ';'
$outputText = $outputText -replace ';;', ';'

# ------------------------------------------
# Write out the file.
# ------------------------------------------

$outputText | Out-File -FilePath '.\Biter Pet\Biter Pet - Minified.lua'