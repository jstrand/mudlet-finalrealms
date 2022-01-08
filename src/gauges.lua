function setupGauges()
    setBorderBottom(30)
    bottom_container = Geyser.HBox:new({
        name = "bottom_container",
        x = 2,
        y = -30,
        width = "65%",
        height = 30
    })

    hpbar = Geyser.Gauge:new({
        name = "hpbar",
        x = 5,
        y = 0,
        width = "32%",
        height = "100%"
    }, bottom_container)

    hpbar.front:setStyleSheet([[
  	 background-color: green;
      border-top: 1px black solid;
      border-left: 1px black solid;
      border-bottom: 1px black solid;
      border-radius: 4;
      padding: 3px;
      margin: 3px;
  ]])
    hpbar.back:setStyleSheet([[
      background-color: gray;
      border-width: 1px;
      border-color: black;
      border-style: solid;
      border-radius: 4;
      padding: 3px;
      margin: 3px;
  ]])

    gpbar = Geyser.Gauge:new({
        name = "gpbar",
        x = "32%",
        y = 0,
        width = "32%",
        height = "100%"
    }, bottom_container)

    gpbar.front:setStyleSheet([[
  	 background-color: red;
      border-top: 1px black solid;
      border-left: 1px black solid;
      border-bottom: 1px black solid;
      border-radius: 4;
      padding: 3px;
      margin: 3px;
  ]])
    gpbar.back:setStyleSheet([[
      background-color: gray;
      border-width: 1px;
      border-color: black;
      border-style: solid;
      border-radius: 4;
      padding: 3px;
      margin: 3px;
  ]])

    xpbar = Geyser.Gauge:new({
        name = "xpbar",
        x = "66%",
        y = 0,
        width = "32%",
        height = "100%",
        fgColor = "white"
    }, bottom_container)

    xpbar.front:setStyleSheet([[
      background-color: blue;
      border-top: 1px black solid;
      border-left: 1px black solid;
      border-bottom: 1px black solid;
      border-radius: 4;
      padding: 3px;
      margin: 3px;
  ]])

    xpbar.back:setStyleSheet([[
      background-color: gray;
      border-width: 1px;
      border-color: black;
      border-style: solid;
      border-radius: 4;
      padding: 3px;
      margin: 3px;
  ]])

    lockoutGauge = Geyser.Gauge:new({
        name = "lockoutGauge",
        x = "5",
        y = "5",
        width = "200",
        height = "20",
        fgColor = "white"
    })

    lockoutGauge.front:setStyleSheet([[
      background-color: rgba(255, 255, 255, 128);
      border-top: 1px black solid;
      border-left: 1px black solid;
      border-bottom: 1px black solid;
      border-radius: 4;
      padding: 10px;
      margin: 3px;
      opacity: 0.5;
  ]])

    lockoutGauge.back:setStyleSheet([[
      background-color: rgba(128,128,128, 128);
      border-width: 1px;
      border-color: black;
      border-style: solid;
      border-radius: 4;
      padding: 10px;
      margin: 3px;
      opacity: 0.5;
  ]])
    lockoutGauge:hide()

    updateGauges()
end

function updateGauges()
    hp = hp or 1
    gp = gp or 1
    xp = xp or 1
    max_hp = max_hp or 1
    max_gp = max_gp or 1
    max_xp = max_xp or 1

    hpbar:setValue(cap(hp, max_hp), max_hp,
                   "<p style='font-size:12pt;margin-left:10px'><b>" ..
                       (hp or "?") .. " HP</b></p>")
    gpbar:setValue(cap(gp, max_gp), max_gp,
                   "<p style='font-size:12pt;margin-left:10px'><b>" ..
                       (gp or "?") .. " GP</b></p>")
    local xp_bar_max = max_xp
    -- if xp_helper or xp_health_pause then xp_bar_max = xp_goal end

    xpbar:setValue(cap(xp, xp_bar_max), xp_bar_max,
                   "<p style='font-size:12pt;margin-left:10px'><b>" ..
                       (math.floor(xp / 1000) or "?") .. "k XP " .. showXpRate() ..
                       "</b></p>")
end

function showXpRate()
    local rate = ""
    if xp_stats and xp_stats.xp_per_hour() > 10000 then
        local time_left = xp_stats.time_to(max_xp)
        if time_left then
            time_left = " " .. time_left .. " left"
        else
            time_left = ""
        end
        rate = xp_stats.presentation() .. time_left
    end
    return rate
end

function cap(x, max)
    if not max then return 0 end
    if not x then return 0 end
    if x > max then return max end
    return x
end
