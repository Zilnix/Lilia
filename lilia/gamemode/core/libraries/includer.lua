﻿--- Top-level library containing all Lilia libraries. A large majority of the framework is split into respective libraries that
-- reside within `lia`.
-- @library lia
local RealmIdentifiers = {
    client = "client",
    server = "server",
    shared = "shared",
    config = "shared",
    module = "shared",
    schema = "shared",
    permissions = "shared",
    commands = "shared",
}

FilesToLoad = {
    {
        path = "lilia/gamemode/core/libraries/languages.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/util.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/notice.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/meta/character.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/character.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/hooks/shared.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/hooks/client.lua",
        realm = "client"
    },
    {
        path = "lilia/gamemode/core/hooks/server.lua",
        realm = "server"
    },
    {
        path = "lilia/gamemode/core/libraries/skin.lua",
        realm = "client"
    },
    {
        path = "lilia/gamemode/core/libraries/color.lua",
        realm = "client"
    },
    {
        path = "lilia/gamemode/core/libraries/logger.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/modularity.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/chatbox.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/commands.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/flags.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/inventory.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/meta/item.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/item.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/networking.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/attributes.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/factions.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/classes.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/currency.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/time.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/meta/inventory.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/meta/entity.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/meta/player.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/menu.lua",
        realm = "client"
    },
    {
        path = "lilia/gamemode/core/libraries/bars.lua",
        realm = "client"
    },
    {
        path = "lilia/gamemode/core/netcalls/client.lua",
        realm = "client"
    },
    {
        path = "lilia/gamemode/core/netcalls/server.lua",
        realm = "server"
    },
    {
        path = "lilia/gamemode/core/libraries/ease.lua",
        realm = "client"
    },
    {
        path = "lilia/gamemode/core/libraries/string.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/table.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/math.lua",
        realm = "shared"
    },
    {
        path = "lilia/gamemode/core/libraries/sizing.lua",
        realm = "client"
    },
}

--- Loads a Lua file into the server, client, or shared realm.
-- This function includes a Lua file into the server, client, or shared realm depending on the specified state.
-- This function has an legacy alias *lia.util.include* that can be used instead of lia.include.
-- @string fileName The name of the Lua file to be included.
-- @string state The state in which the Lua file should be included: "server", "client", or "shared".
-- @return If the Lua file is included on the server and the state is "server", it returns the included file; otherwise, no return value.
-- @realm shared
function lia.include(fileName, state)
    if not fileName then error("[Lilia] No file name specified for inclusion.") end
    local matchResult = string.match(fileName, "/([^/]+)%.lua$")
    local fileRealm = matchResult and RealmIdentifiers[matchResult] or "NULL"
    if (state == "server" or fileRealm == "server" or fileName:find("sv_")) and SERVER then
        return include(fileName)
    elseif state == "shared" or fileRealm == "shared" or fileName:find("sh_") then
        if SERVER then AddCSLuaFile(fileName) end
        return include(fileName)
    elseif state == "client" or fileRealm == "client" or fileName:find("cl_") then
        if SERVER then
            AddCSLuaFile(fileName)
        else
            return include(fileName)
        end
    end
end

lia.util.include = lia.include
--- Loads Lua files from a directory into the server, client, or shared realm.
-- This function recursively includes Lua files from a directory into the specified realm.
-- This function has a legacy alias *lia.util.includeDir* that can be used instead of lia.includeDir.
-- @string directory The directory containing the Lua files to be included.
-- @bool fromLua Specifies if the Lua files are located in the lua/ folder.
-- @bool recursive Specifies if subdirectories should be included recursively.
-- @string realm string The realm in which the Lua files should be included: "server", "client", or "shared".
-- @realm shared
function lia.includeDir(directory, fromLua, recursive, realm)
    local baseDir = "lilia"
    if SCHEMA and SCHEMA.folder and SCHEMA.loading then
        baseDir = SCHEMA.folder .. "/schema/"
    else
        baseDir = baseDir .. "/gamemode/"
    end

    if recursive then
        local function AddRecursive(folder, baseFolder)
            local files, folders = file.Find(folder .. "/*", "LUA")
            if not files then
                MsgN("Warning! This folder is empty!")
                return
            end

            for _, v in pairs(files) do
                local fullPath = folder .. "/" .. v
                lia.include(fullPath, realm)
            end

            for _, v in pairs(folders) do
                local subFolder = baseFolder .. "/" .. v
                AddRecursive(folder .. "/" .. v, subFolder)
            end
        end

        local initialFolder = (fromLua and "" or baseDir) .. directory
        AddRecursive(initialFolder, initialFolder)
    else
        for _, v in ipairs(file.Find((fromLua and "" or baseDir) .. directory .. "/*.lua", "LUA")) do
            local fullPath = directory .. "/" .. v
            lia.include(fullPath, realm)
        end
    end
end

lia.includeDir("lilia/gamemode/core/libraries/thirdparty", true, true)
lia.util.includeDir = lia.includeDir
--- Dynamically loads Lua files for entities, weapons, tools, and effects into the appropriate realm of a Garry's Mod Lua project.
-- This function iterates through a specified directory and its subdirectories, including Lua files for entities, weapons, tools, and effects into the server, client, or shared realm as needed.
-- The function automatically registers the entities, weapons, tools, and effects in the correct context (server, client, or shared).
-- A legacy alias `lia.util.loadEntities` is available, which can be used instead of `lia.includeEntities`.
-- @string path The directory containing the Lua files to be included.
-- @realm shared
function lia.includeEntities(path)
    local LoadedTools
    local files, folders
    local function IncludeFiles(path2)
        if file.Exists(path2 .. "init.lua", "LUA") then lia.include(path2 .. "init.lua", "server") end
        if file.Exists(path2 .. "shared.lua", "LUA") then lia.include(path2 .. "shared.lua", "shared") end
        if file.Exists(path2 .. "cl_init.lua", "LUA") then lia.include(path2 .. "cl_init.lua", "client") end
    end

    local function HandleEntityInclusion(folder, variable, register, default, clientOnly, create, complete)
        files, folders = file.Find(path .. "/" .. folder .. "/*", "LUA")
        default = default or {}
        for _, v in ipairs(folders) do
            local path2 = path .. "/" .. folder .. "/" .. v .. "/"
            v = stripRealmPrefix(v)
            _G[variable] = table.Copy(default)
            if not isfunction(create) then
                _G[variable].ClassName = v
            else
                create(v)
            end

            IncludeFiles(path2, clientOnly)
            if clientOnly then
                if CLIENT then register(_G[variable], v) end
            else
                register(_G[variable], v)
            end

            if isfunction(complete) then complete(_G[variable]) end
            _G[variable] = nil
        end

        for _, v in ipairs(files) do
            local niceName = stripRealmPrefix(string.StripExtension(v))
            _G[variable] = table.Copy(default)
            if not isfunction(create) then
                _G[variable].ClassName = niceName
            else
                create(niceName)
            end

            lia.include(path .. "/" .. folder .. "/" .. v, clientOnly and "client" or "shared")
            if clientOnly then
                if CLIENT then register(_G[variable], niceName) end
            else
                register(_G[variable], niceName)
            end

            if isfunction(complete) then complete(_G[variable]) end
            _G[variable] = nil
        end
    end

    local function RegisterTool(tool, className)
        local gmodTool = weapons.GetStored("gmod_tool")
        className = stripRealmPrefix(className)
        if gmodTool then
            gmodTool.Tool[className] = tool
        else
            ErrorNoHalt(string.format("Attempted to register tool '%s' with invalid gmod_tool weapon", className))
        end

        LoadedTools = true
    end

    HandleEntityInclusion("entities", "ENT", scripted_ents.Register, {
        Type = "anim",
        Base = "base_gmodentity",
        Spawnable = true
    })

    HandleEntityInclusion("weapons", "SWEP", weapons.Register, {
        Primary = {},
        Secondary = {},
        Base = "weapon_base"
    })

    HandleEntityInclusion("tools", "TOOL", RegisterTool, {}, false, function(className)
        className = stripRealmPrefix(className)
        TOOL = setmetatable({}, TOOL)
        TOOL.Mode = className
        TOOL:CreateConVars()
    end)

    HandleEntityInclusion("effects", "EFFECT", effects and effects.Register, nil, true)
    if CLIENT and LoadedTools then RunConsoleCommand("spawnmenu_reload") end
end

lia.util.loadEntities = lia.includeEntities
lia.includeEntities("lilia/gamemode/entities")
for _, file in ipairs(FilesToLoad) do
    lia.include(file.path, file.realm)
end
