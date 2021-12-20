display("Loading effects")

FR.effectbars = FR.effectbars or {}

function setupEffectsGauges()
    FR.effects_container = Geyser.VBox:new({
        name = "effects_container",
        x = "-200px",
        y = "200px",
        width = "200px"
    }, leftOfMapContainer)
    FR.effects_container:flash()

    FR.effectbars = {}
    for i = 1, 10 do
        local effectbar = Geyser.Gauge:new({
            name = "effectbar" .. i,
            -- x = 0, y = 0,
            v_policy = Geyser.Fixed,
            width = "95%",
            height = "30",
            fgColor = "white"
        }, FR.effects_container)
        effectbar:hide()

        effectbar.front:setStyleSheet([[
        background-color: Gray;
        border-radius: 4;
        padding: 3px;
        margin-bottom: 3px;
    ]])

        effectbar.back:setStyleSheet([[
        background-color: none;
        border: 2px solid Gray;
        border-radius: 4;
        margin-bottom: 3px;
    ]])

        FR.effectbars[i] = effectbar
    end

    registerNamedTimer("fr", "refreshEffectsTimer", 0.5, refreshEffectGauges,
                       true)
end

function refreshEffectGauges() end

function hasEffect(name)
    if name == "Singing" then return singing end
    if name == "Rainbow" then return rainbow end

    if not effects then return false end

    return effects[name] and effects[name].duration > 0
end

function updateEffects(namesAndDurations)
    effects = effects or {}

    for name, effect in pairs(effects) do effect.present = false end

    local i = 1
    for name, duration in pairs(namesAndDurations) do
        if not effects[name] then
            local effect = {}
            effects[name] = effect
            effect.max = duration
        end
        local effect = effects[name]
        if effect.max < duration then effect.max = duration end
        effect.duration = duration
        effect.present = true

        if i <= 10 then
            if duration > 0 then
                FR.effectbars[i]:setValue(duration, effect.max,
                                          "<p style='font-size:12pt;margin-left:10px'><b>" ..
                                              name .. "</b> " ..
                                              showDuration(duration) .. "</p>")
                FR.effectbars[i]:show()
            else
                FR.effectbars[i]:hide()
            end
        end

        i = i + 1
    end

    -- reset any no longer in list
    for name, effect in pairs(effects) do
        if not effect.present then
            effect.max = 0
            effect.duration = 0
        end
    end

    while i <= 10 do
        FR.effectbars[i]:hide()
        i = i + 1
    end
end

function showDuration(ticks)
    local seconds = 2 * ticks
    if seconds > 60 then
        local minutes = math.floor(seconds / 60)
        if seconds % 60 > 0 then
            return minutes .. "m " .. math.floor(seconds % 60) .. "s"
        end
        return minutes .. "m"
    else
        return seconds .. "s"
    end
    return ""
end
