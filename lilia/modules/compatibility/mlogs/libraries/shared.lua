﻿function MLogsCompatibility:OnServerLog(_, _, logString)
    mLogs.log("ScriptLog", "lia", {
        log = logString
    })
end