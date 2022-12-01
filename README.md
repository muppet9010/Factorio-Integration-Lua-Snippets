# Factorio-Integration-Lua-Snippets

A collection of Lua scripts for use with Factorio integration tools. These provide neat features that are complicated enough they can't just be casually typed, but not complicated/important enough to warrant inclusion in a mod.



## Coding Notes

- All code should have their lines ending with `;`. This is to ensure they work correctly with integrations that strip out the line ending characters and thus join text that was previous separated by a new line directly together.
- Any comments must be within comment blocks `--[[ TEST ]]` and not just as a line comment `-- TEST`. As when the code is squished on to a single line for execution the line comments end up commenting all code after that point, as there's no line breaks left to end them.
- Any Sumneko classes should go in a separate file. And can only be included via the `--[[@as Test_Class]]` as this is the only Sumneko annotation that can be within code blocks. The class should be named as the feature + "_" + usage, i.e. BiterPet_data.



## Useful Titbits

To add a breakpoint in to a Lua script use:
__DebugAdapter.breakpoint()