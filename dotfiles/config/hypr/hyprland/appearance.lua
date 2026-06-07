hl.general({
    gaps_in = 5,
    gaps_out = 10,
    border_size = 2,

    ["col.active_border"] = themes.active_border,
    ["col.inactive_border"] = themes.inactive_border,

    resize_on_border = true,

    layout = "dwindle",
})

hl.decoration({
    rounding = 10,

    blur = {
        enabled = true,
        size = 3,
        passes = 1,
    },
})