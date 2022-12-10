# Factorio-Integration-Lua-Snippets

A collection of Lua scripts for use with Factorio integration tools. These provide neat features that are complicated enough they can't just be casually typed, but not complicated/important enough to warrant inclusion in a mod.

View each folder for its own `Usage Details.txt` file that will explain the feature and its options. Ignore any files in the folder starting with an underscore `_`, these are development related files.

They are provided as scripts and not as part of a mod as some users will want to make changes to them to fit their specific play through or other mods in use. They may even want to remove or add features to the scripts. As a script I am able to develop them quicker in a lighter fashion than a modded feature as I don't have to cater for every edge case another mod could generate within them, you can amend them yourself for this.

Each script file has a version number variable at the very end of the Lua code. This will correspond to the Releases in Github per feature and the _Changelog.txt file in each features folder. This enables you to use the Releases in GitHub to quickly tell if your script version is the latest.



## Coding Notes

- All code should have their lines ending with `;`. This is to ensure they work correctly with integrations that strip out the line ending characters and thus join text that was previous separated by a new line directly together.
- Any comments must be within comment blocks `--[[ TEST ]]` and not just as a line comment `-- TEST`. As when the code is squished on to a single line for execution the line comments end up commenting all code after that point, as there's no line breaks left to end them.
- Any Sumneko classes should go in a separate file. And can only be included via the `--[[@as Test_Class]]` as this is the only Sumneko annotation that can be within code blocks. The class should be named as the feature + "_" + usage, i.e. BiterPet_data.



## Useful Titbits

To add a breakpoint in to a Lua script use:
__DebugAdapter.breakpoint()