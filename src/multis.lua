function FR.setupMultis()
    if FR.multis and FR.multis.eventHandler then
        killAnonymousEventHandler(FR.multis.eventHandler)
    end

    FR.multis = {vitals = {}, hpbars = {}, gpbars = {}, xpbars = {}}

    FR.multis.eventHandler = registerAnonymousEventHandler("globalVitals",
                                                           "FR.onGlobalVitals")
end

function FR.refreshAllMultiVitals()
    for k, v in pairs(FR.multis.vitals) do FR.refreshMultiVitals(v) end
end

function FR.refreshMultiVitals(vitals)
    FR.multis.container = FR.multis.container or
                              Geyser.VBox:new(
                                  {name = "multi_container" .. vitals.profile},
                                  multis_container)
    Geyser.Label:new({
        name = "multi_name_label" .. vitals.profile,
        fgColor = "white",
        color = "black",
        height = "25px",
        v_policy = Geyser.Fixed,
        message = vitals.profile
    }, FR.multis.container)

    FR.multis.hpbars[vitals.profile] = FR.multis.hpbars[vitals.profile] or
                                           Geyser.Gauge:new({
            name = "hpbar_multi" .. vitals.profile,
            height = "25px",
            v_policy = Geyser.Fixed
        }, FR.multis.container)

    FR.multis.hpbars[vitals.profile]:setValue(vitals.hp, vitals.maxHp,
                                              [[<p style='font-size:12pt;margin-left:10px'><b>]] ..
                                                  FR.showVitalsText(vitals.hp,
                                                                    vitals.maxHp) ..
                                                  [[</b></p>]])
    FR.multis.hpbars[vitals.profile].front:setStyleSheet([[
       background-color: green;
       border: none;
       margin: 2px;
   ]])
    FR.multis.hpbars[vitals.profile].back:setStyleSheet([[
       background-color: gray;
       border: none;
       margin: 2px;
   ]])

    FR.multis.gpbars[vitals.profile] = FR.multis.gpbars[vitals.profile] or
                                           Geyser.Gauge:new({
            name = "gpbar_multi" .. vitals.profile,
            height = "25px",
            v_policy = Geyser.Fixed
        }, FR.multis.container)

    FR.multis.gpbars[vitals.profile]:setValue(vitals.gp, vitals.maxGp,
                                              [[<p style='font-size:12pt;margin-left:10px'><b>]] ..
                                                  FR.showVitalsText(vitals.gp,
                                                                    vitals.maxGp) ..
                                                  [[</b></p>]])

    FR.multis.gpbars[vitals.profile].front:setStyleSheet([[
        background-color: red;
        border: none;
        margin: 2px;
    ]])
    FR.multis.gpbars[vitals.profile].back:setStyleSheet([[
        background-color: gray;
        border: none;
        margin: 2px;
    ]])

    FR.multis.xpbars[vitals.profile] = FR.multis.xpbars[vitals.profile] or
                                           Geyser.Gauge:new({
            name = "xpbar_multi" .. vitals.profile,
            height = "10px",
            v_policy = Geyser.Fixed
        }, FR.multis.container)

    FR.multis.xpbars[vitals.profile]:setValue(vitals.xp, vitals.maxXp)

    FR.multis.xpbars[vitals.profile].front:setStyleSheet([[
        background-color: blue;
        border: none;
        margin: 2px;
        margin-left: 0;
    ]])
    FR.multis.xpbars[vitals.profile].back:setStyleSheet([[
        background-color: gray;
        border: none;
        margin: 2px;
        margin-left: 0;
    ]])
end

function FR.showVitalsText(value, maxValue)
    if value == maxValue then return value end
    return value .. " / " .. maxValue
end

function FR.onGlobalVitals(event, othersHp, othersMaxHp, othersGp, othersMaxGp,
                           othersXp, othersMaxXp, profile)
    FR.multis.vitals[profile] = {
        profile = profile,
        hp = othersHp,
        maxHp = othersMaxHp,
        gp = othersGp,
        maxGp = othersMaxGp,
        xp = othersXp,
        maxXp = othersMaxXp
    }

    FR.refreshMultiVitals(FR.multis.vitals[profile])
end
