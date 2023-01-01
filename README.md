# Factorio-Integration-Lua-Snippets

A collection of Lua scripts for use with Factorio integration tools. These provide neat features that are complicated enough they can't just be casually typed, but not complicated/important enough to warrant inclusion in a mod.

View each folder for its own `Usage Details.txt` file that will explain the feature and its options. Ignore any files in the folder starting with an underscore `_`, these are development related files.

The feature folders will have one or more scripts in it. The `- Readable` affixed script files have their code spaced out to be readable and easily edited. Some larger scripts have a `- Minified` affixed script files have their code fully compressed and minimalised, except the configurable options at the start that are just put on less lines. This is to reduce the scripts character count as Factorio does have limits on how many characters of an RCON command will be processed per tick and these decrease as the player count increases.
Some features may also have multiple subversions of a script, these will have the subversion name after the feature name in brackets `()`.

They are provided as scripts and not as part of a mod as some users will want to make changes to them to fit their specific play through or other mods in use. They may even want to remove or add features to the scripts. As a script I am able to develop them quicker in a lighter fashion than a modded feature as I don't have to cater for every edge case another mod could generate within them, you can amend them yourself for this.

Each script file has a version number variable at the very end of the Lua code. This will correspond to the Releases in Github per feature and the _Changelog.txt file in each features folder. This enables you to use the Releases in GitHub to quickly tell if your script version is the latest.



## Coding Notes

- Any comments must be within comment blocks `--[[ TEST ]]` and not just as a line comment `-- TEST`. As when the code is squished on to a single line for execution the line comments end up commenting all code after that point, as there's no line breaks left to end them.
- Any Sumneko classes should go in a separate file. And can only be included via the `--[[@as Test_Class]]` as this is the only Sumneko annotation that can be within code blocks. The class should be named as the feature + "_" + usage, i.e. BiterPet_data.



## Making Minified Files

Some larger scripts will have a PowerShell script in their folder to make the minified version of their scripts. This allows the `Readable` version of the script to be developed and then compressed for use. The script will be called `_Minify.ps1` when present. See these files for any usage/limitation comments. Note that the script will utilise the comment blocks in the sample code to aid its code detection and minification process.



## Useful Titbits

To add a breakpoint in to a Lua script use:
__DebugAdapter.breakpoint()