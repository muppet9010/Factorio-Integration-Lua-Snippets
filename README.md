# Factorio-Integration-Lua-Snippets

A collection of Lua scripts for use with Factorio integration tools. These provide neat features that are complicated enough they can't just be casually typed, but not complicated/important enough to warrant inclusion in a mod.

View each folder for its own `Usage Details.txt` file that will explain the feature and its options. Ignore any files in the folder starting with an underscore `_`, these are development related files.

The feature folders will have one or more scripts in it. The `- Readable` affixed script files have their code spaced out to be readable and easily edited. The `- Minified` affixed script files have their code fully compressed (except the configurable options at the start), this is to reduce the scripts character count. As Factorio does have limits on how many characters of an RCON command will be processed per tick and these decrease as the player count increases.
Some features may also have multiple subversions of a script, these will have the subversion name after the feature name in brackets `()`.

They are provided as scripts and not as part of a mod as some users will want to make changes to them to fit their specific play through or other mods in use. They may even want to remove or add features to the scripts. As a script I am able to develop them quicker in a lighter fashion than a modded feature as I don't have to cater for every edge case another mod could generate within them, you can amend them yourself for this.

Each script file has a version number variable at the very end of the Lua code. This will correspond to the Releases in Github per feature and the _Changelog.txt file in each features folder. This enables you to use the Releases in GitHub to quickly tell if your script version is the latest.



## Coding Notes

- Any comments must be within comment blocks `--[[ TEST ]]` and not just as a line comment `-- TEST`. As when the code is squished on to a single line for execution the line comments end up commenting all code after that point, as there's no line breaks left to end them.
- Any Sumneko classes should go in a separate file. And can only be included via the `--[[@as Test_Class]]` as this is the only Sumneko annotation that can be within code blocks. The class should be named as the feature + "_" + usage, i.e. BiterPet_data.



## Making Minified Files

1. Make a note of any current settings separation at the start of the file. The settings will always be a separate line to the main code, but may also have multiple line groupings within them (just for readability).
2. From the Readable script copy its contents to the minified file.
3. Debug code blocks:
    3a. Check that no debug blocks have nested `if end` as our regex will only do the outer ones. Do a search without a replace for `if data._debug then(?:(\s|\S|\n|\r))*?end` and check the indentations look the same for start and end.
    3b. Replace `if data._debug then(?:(\s|\S|\n|\r))*?end\n` to ``. Remove any simple debug code blocks and their trailing new line.
4. Whole file light condensing:
    4a. Replace `\n\n` to `\n`. Match Regular Expressions for this and all replaces. Removes any space lines. Run as many times as needed until no matches remaining.
    4b. Replace `\s{2,}` to ``. Remove any indentation of 2 or more spaces.
    5b. Replace `--\[\[.*?\]\]` to ``. Remove any Sumneko TypeDefs.
5. In the settings area (start of file):
    5a. Replace `^(?!(\/sc))(.*)\n` to `$2; `. Replace single line breaks to be an end of Lua phrase `;` and a space for readability.
    5b: Replace `\/sc\n` to `/sc ` Move the first line after the `/sc` to be on the same line as it.
    5c. Apply any line spacing on the settings back if they had any.
    5d. Add a `;` to the end of the last line of the settings.
6. In the main code area (rest of file):
    6a. Replace `\n` to `;`. Replace single line breaks to be an end of Lua phrase `;`.
    6b. Replace `\s*([=~<>,+-\/*^{}])\s*` to `$1`. Remove any leading or trailing spaces where we don't need them.
7. Push the `version` variable on to its own line so its clear and add a trailing `;` to the end of the line.


## Useful Titbits

To add a breakpoint in to a Lua script use:
__DebugAdapter.breakpoint()