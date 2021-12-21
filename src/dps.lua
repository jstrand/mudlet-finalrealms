function FR.setupDps()
    if FR.dps_stats and FR.dps_stats.handler then
        killAnonymousEventHandler(FR.dps_stats.handler)
    end

    FR.dps_stats = {
        values = {},
        mean = 0,
        maxDamage = 0,
        maxMean = 0,
        lastDamage = 0,
        samples = 15
    }

    FR.dps_stats.handler = registerAnonymousEventHandler("gmcp.Action.Round",
                                                         "FR.onDpsStats", false)

    FR.dps_stats.label = Geyser.Label:new({
        name = "dps_label",
        fgColor = "white",
        width = "100%",
        height = "140px",
        v_policy = Geyser.Fixed
        -- message = [[<center>heey</center>]]
    }, dps_container)

    FR.dps_stats.label:setStyleSheet([[
        background-color: rgba(50,50,50,50%);
        font-size: 20px;
        padding: 10px;
        margin: 5px
    ]])

    FR.dps_stats.label:setFontSize(11)
    FR.dps_stats.label:flash()
    FR.dps_stats.label:setClickCallback("FR.setupDps")

    FR.refreshDpsLabel()
end

function FR.refreshDpsLabel()
    local function createRow(label, value)
        return "<tr><td>" .. label .. "</td><td style=\"text-align:right\">" ..
                   value or "?" .. "</td></tr>"
    end

    local mean = "?"
    if #FR.dps_stats.values == FR.dps_stats.samples then
        mean = FR.dps_stats.mean
    end
    local meanRow = createRow("Damage per round <br/>(last 15 rounds)",
                              "<div style='color:black'>.........</div>" .. mean)
    local lastRoundRow = createRow("Last round", FR.dps_stats.lastDamage)
    local maxDamageRow = createRow("Max damage (one round)",
                                   FR.dps_stats.maxDamage)
    local maxMeanRow = createRow("Max mean (15 rounds)", FR.dps_stats.maxMean)

    FR.dps_stats.label:echo("<table style='width:100%'>" .. meanRow ..
                                lastRoundRow .. maxDamageRow .. maxMeanRow ..
                                "</table>")
end

function FR.onDpsStats() FR.onDamageDealt(gmcp.Action.Round.Damage_dealt) end

function FR.onDamageDealt(damageDealt)
    local lastDamage = damageDealt
    if lastDamage == 0 then return end
    if #FR.dps_stats.values >= FR.dps_stats.samples then
        table.remove(FR.dps_stats.values, 1)
    end
    table.insert(FR.dps_stats.values, lastDamage)

    local total = 0
    for i, v in ipairs(FR.dps_stats.values) do total = total + v end
    local mean = math.floor(total / #FR.dps_stats.values)

    FR.dps_stats.mean = mean
    FR.dps_stats.lastDamage = lastDamage

    if FR.dps_stats.lastDamage > FR.dps_stats.maxDamage then
        FR.dps_stats.maxDamage = lastDamage
    end

    if #FR.dps_stats.values >= FR.dps_stats.samples and FR.dps_stats.mean >
        (FR.dps_stats.maxMean or 0) then
        FR.dps_stats.maxMean = FR.dps_stats.mean
    end

    FR.refreshDpsLabel()
end
