﻿
function lia.attribs.setup(client)
    local character = client:getChar()
    if character then
        for k, v in pairs(lia.attribs.list) do
            if v.onSetup then v:onSetup(client, character:getAttrib(k, 0)) end
        end
    end
end

