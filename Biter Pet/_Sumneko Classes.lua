---@class BiterPet_Data
---@field _playerObj LuaPlayer
---@field _biter LuaEntity
---@field _biterSurface LuaSurface
---@field _biterBonusHealthMax float # 0 indicates that this feature isn't being used at all.
---@field _biterBonusHealthCurrent float
---@field _biterHealingPerSecond? float # nil for when the biter doesn't heal each second or when bonus health feature not being used.
---@field _biterMaxHealth? float # nil when bonus health feature not being used.
---@field _followPlayerFuncString string
---@field _closenessRange uint
---@field _exploringMaxRange uint
---@field _combatMaxRange uint
---@field _calledBack boolean
---@field _fighting boolean
---@field _following boolean
---@field _biterName string # Is either a name or empty string.
---@field _hasOwner boolean
---@field _lastPosition MapPosition
---@field _debug boolean
---@field _biterDetailsSize double # 0.0 is for no labels.
---@field _biterDetailsColor Color
---@field _biterNameRenderId? uint64 # The render ID of the biters name.
---@field _biterStateRenderId? uint64 # The render ID of the biters state text.
---@field _biterHealthRenderId? uint64 # The render ID of the biters state text.
---@field _biterDeathMessageDuration uint # How many ticks the biter's death message is shown for.
---@field _biterDeathMessagePrint "not"|"master"|"everyone"
---@field _biterStatusMessages_Wondering string[]
---@field _biterStatusMessages_CallBack string[]
---@field _biterStatusMessages_GuardingCorpse string[]
---@field _biterStatusMessages_Dead string[]
---@field _biterStatusMessages_Following string[]
---@field _biterStatusMessages_Fighting string[]
