﻿--[[--
Faction setup hooks.

Factions have their own hooks that are called for various reasons, with the most common being to set up a character
once it's created and assigned to a certain faction. For example, giving a police faction character a weapon upon creation.
These hooks are used in faction tables that are created in `schema/factions/sfactionname.lua` and cannot be used like
regular gamemode hooks.
]]
-- @hooks Faction
--- Called when the default name for a character needs to be retrieved (i.e., upon initial creation).
-- @realm shared
-- @param client The client for whom the default name is being retrieved
-- @treturn string The default name for the newly created character
-- @usage function FACTION:getDefaultName(client)
--     return "CT-" .. math.random(111111, 999999) -- Sets the name as CT-XXXXXX, where the XXXXXX are randomly generated digits.
-- end
function getDefaultName(client)
end

--- Called when the default description for a character needs to be retrieved.
-- This function allows factions to define custom default descriptions for characters.
-- @realm shared
-- @param client The client for whom the default description is being retrieved
-- @param faction The faction ID for which the default description is being retrieved
-- @treturn string The default description for the newly created character
-- @usage function FACTION:getDefaultDesc(client, faction)
--     return "A police officer" -- Example default description.
-- end
function getDefaultDesc(client, faction)
end

--- Called when a character has been initially created and assigned to this faction.
-- @realm server
-- @param client The client that owns the character
-- @param character The character that has been created
-- @usage function FACTION:onCharCreated(client, character)
--     local inventory = character:getInv()
--     inventory:add("fancy_suit") -- Adds a Fancy Suit item to the character's inventory.
-- end
function onCharCreated(client, character)
end

--- Called when a character in this faction has spawned in the world.
-- @realm server
-- @param client The player that has just spawned
-- @usage function FACTION:onSpawn(client)
--     client:ChatPrint("You have spawned!") -- Notifies the client that they have spawned.
-- end
function onSpawn(client)
end

--- Called when a player's character has been transferred to this faction.
-- @realm server
-- @param character The character that was transferred
-- @usage function FACTION:onTransferred(character)
--     local randomModelIndex = math.random(1, #self.models)
--     character:setModel(self.models[randomModelIndex]) -- Sets a random model from the faction's model list as the character's model.
-- end
function onTransferred(character)
end
