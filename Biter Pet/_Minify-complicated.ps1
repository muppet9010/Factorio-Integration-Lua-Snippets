# This tries to do the entire minification in Powershell. A concept WIP and realised the variable handling will be a lot of work.

$fullTextLines = Get-Content -Path ".\Biter Pet\Biter Pet - Readable.lua"
$lineLastChecked = 0

# Do the file wide cleaning.
for ($i = 0; $i -lt $fullTextLines.Count; $i++) {
    $textLine = $fullTextLines[$i]

    # Remove any indentation.
    $textLine = $textLine -replace '\s{2,}', ''

    $fullTextLines[$i] = $textLine
}

# Get the command line (first).
$commandCallText = $fullTextLines[0]

# Handle the setting lines.
$settingsStringBuilder = [System.Text.StringBuilder]::new()
$settingVariableNames = [System.Collections.Hashtable]::new()
while ($true) {
    $lineLastChecked++
    $textLine = $fullTextLines[$lineLastChecked]
    if ($textLine -eq "--[[ CODE START ]]") {
        break
    }

    # Capture the setting varibale names.
    $startOfVariablePos = $textLine.indexOf("local ") + 6
    $variableOnLine = $textLine.Substring($startOfVariablePos, $textLine.indexOf("=")-$startOfVariablePos)
    $variableOnLine = $variableOnLine.Trim() # There may be a trailing space, based on if there was one that went in between the variable name and the "=" sign.
    $settingVariableNames.Add($variableOnLine, $true)

    # TODO: insert the line breaks after the different specific setting types.

    # Record our cleaned text.
    $settingsStringBuilder.Append($textLine + "; ")
}
$settingText = $settingsStringBuilder.ToString()

# Handle the code lines.

# First find all the variables and fields of
$codeStringBuilder = [System.Text.StringBuilder]::new()
$codeMinifiedVariableNames = [System.Collections.Hashtable]::new()
while ($lineLastChecked -le $fullTextLines.Count) {
    $lineLastChecked++
    $textLine = $fullTextLines[$lineLastChecked]

    $currentCharIndex = 0
    $startOfVariablePos = $textLine.indexOf("local ", $currentCharIndex)
    while ($startOfVariablePos -ge 0) {
        # TODO this is a WIP area - but just realised how much work it is.
        $startOfVariablePos += 6 # The length of "local ".
        $variable = $textLine.Substring($startOfVariablePos, $textLine.indexOf("=|\r\n", $startOfVariablePos)-$startOfVariablePos)
        $variable = $variable.Trim() # There may be a trailing space, based on if there was one that went in between the variable name and the "=" sign.
    }

    # Record our cleaned text.
    $codeStringBuilder.Append($textLine + ";")
}
$codeText = $codeStringBuilder.ToString()

# Merge the various text strigns back togeather and save them to the file.
$outputText = $commandCallText + " " + $settingText + "/n" + $codeText
$outputText.ToString() | Out-File -FilePath ".\Biter Pet\Biter Pet - Test.lua"