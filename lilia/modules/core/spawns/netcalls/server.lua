﻿util.AddNetworkString("death_client")
util.AddNetworkString("RespawnButtonPress")
util.AddNetworkString("RespawnButtonDeath")
net.Receive("RespawnButtonPress", function(_, client) if not client:Alive() then client:Spawn() end end)
