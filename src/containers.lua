function FR.setupContainers()

    leftOfMapContainer = Geyser.Container:new({
        name = "leftOfMapContainer",
        x = 0,
        y = 0,
        width = "70%",
        height = "100%"
    })
    -- leftOfMapContainer:flash()

    top_container = Geyser.HBox:new({
        name = "top_container",
        x = "-900px",
        y = "4px",
        width = "900px"
    }, leftOfMapContainer)
    -- top_container:flash()

    multis_container = Geyser.VBox:new({
        name = "multis_container",
        width = "300px",
        h_policy = Geyser.Fixed
    }, top_container)
    multis_container:flash()

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
end
