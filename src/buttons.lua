button_width = 120
button_height = 30

function setupButtons()
    top_container = Geyser.HBox:new({
        name = "top_container",
        x = "-600px",
        y = "4px",
        width = "600px"
    }, leftOfMapContainer)
    -- top_container:flash()

    dps_container = Geyser.VBox:new({
        name = "dps_container",
        width = "300px",
        h_policy = Geyser.Fixed
    }, top_container)

    xp_container = Geyser.VBox:new({name = "xp_container"}, top_container)

    buff_container = Geyser.VBox:new({name = "buff_container"}, top_container)

    offense_container = Geyser.VBox:new({name = "offense_container"},
                                        top_container)

    ab_container = Geyser.VBox:new({
        name = "ab_container",
        x = "-215px",
        y = "-300px",
        width = "200px",
        height = "100%"
    }, leftOfMapContainer)

    auto_xp_label = Geyser.Label:new({
        name = "auto_xp_label",
        message = [[<p style="font-size:14pt">Auto-XP</p>]],
        height = "30px",
        v_policy = Geyser.Fixed
    }, xp_container)
    auto_xp_label:setClickCallback("auto_xp_click")

    select_xp_label = Geyser.Label:new({
        name = "select_xp_label",
        message = [[<p style="font-size:14pt">XP-Area</p>]],
        height = "30px",
        v_policy = Geyser.Fixed
    }, xp_container)
    select_xp_label:setClickCallback("select_xp_click")

    auto_cast_label = Geyser.Label:new({
        name = "auto_cast_label",
        message = [[<p style="font-size:14pt">Auto-Offense</p>]],
        height = "30px",
        v_policy = Geyser.Fixed
    }, top_container)
    auto_cast_label:setClickCallback("auto_cast_click")

    refreshButtons()
end

function addBuffButton(name, title)
    local label = Geyser.Label:new({
        name = name,
        message = [[<p style="font-size:14pt">]] .. title .. [[</p>]],
        height = "30px",
        v_policy = Geyser.Fixed
    }, buff_container)
    label:setClickCallback("clickBuff", title)
    return label
end

function addAbilityButton(name, count, label)
    local label = Geyser.Label:new({
        name = name,
        message = "<p style='font-size:14pt'>" .. label .. "</p>",
        x = 0,
        y = 30 * count,
        width = 120,
        height = "30px",
        v_policy = Geyser.Fixed
    }, ab_container)
    label:setClickCallback("activateAbility", name)

    local neutral_style = [[
		background-color: DarkRed;
		padding: 2px;
		margin: 2px 0 0 4px;
		border-radius: 4px;
	]]
    label:setStyleSheet(neutral_style)

    return label
end

neutral_style = [[
    font-size: 14pt;
		background-color: grey;
		padding: 2px;
		margin: 2px 0 0 2px;
		border-radius: 4px;
	]]

active_style = [[
		background-color: green;
		padding: 2px;
		margin: 2px 0 0 2px;
		border-radius: 4px;
	]]

paused_style = [[
		background-color: GoldenRod;
		padding: 2px;
		margin: 2px 0 0 2px;
		border-radius: 4px;
	]]

inactive_trying_style = [[
		background-color: grey;
		padding: 0px;
		margin: 2px 0 0 2px;
    border: 2px solid green;
		border-radius: 4px;
	]]

active_not_trying_style = [[
		background-color: green;
		padding: 0px;
		margin: 2px 0 0 2px;
    border: 2px solid grey;
		border-radius: 4px;
	]]

function refreshButtons()

    local select_xp_style = neutral_style
    if xp_area then select_xp_style = active_style end
    select_xp_label:setStyleSheet(select_xp_style)

    local xp_style = neutral_style
    if xp_helper then
        xp_style = active_style
    elseif xp_health_pause then
        xp_style = paused_style
    end
    auto_xp_label:setStyleSheet(xp_style)

    updateStyle(auto_cast_label, auto_cast)

    refreshBuffButtons()
end

function updateStyleWithTrying(label, active, trying)
    if not label then return end

    local style = neutral_style
    if active and not trying then
        style = active_not_trying_style
    elseif not active and trying then
        style = inactive_trying_style
    elseif active then
        style = active_style
    end

    label:setStyleSheet(style)
end

function updateStyle(label, cond)
    if not label then return end
    local style = neutral_style
    if cond then style = active_style end
    label:setStyleSheet(style)
end

function auto_xp_click() toggleXp() end

function select_xp_click()
    listXpAreas()
    clearCmdLine()
    appendCmdLine("select_xp_area ")
end

function auto_cast_click()
    auto_cast = not auto_cast
    refreshButtons()

    --	if auto_cast then
    --	autoCastOff()
    -- else
    --		autoCastOn()
    --	end
    -- refreshButtons()
end

