---@class BiterPet_Data
---@field _player LuaPlayer
---@field _biter LuaEntity
---@field _followPlayerFuncDump string
---@field _closenessRange uint
---@field _exploringMaxRange uint
---@field _combatMaxRange uint
---@field _calledBack boolean
---@field _following boolean
---@field _biterName string # Is either a name and hyphen with trailing space or empty string. Both are suitable for the biter state text to be added on to.
---@field _hasOwner boolean
---@field _debug boolean
---@field _biterNameRenderId? uint64 # The render ID of the biters name and state text.
---@field _biterStatusMessages_Wondering string[]
---@field _biterStatusMessages_CallBack string[]
---@field _biterStatusMessages_GuardingCorpse string[]
---@field _biterStatusMessages_Dead string[]
---@field _biterStatusMessages_Following string[]
