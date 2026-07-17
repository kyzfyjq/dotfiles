hl.config({
    general = {
        gaps_in  = 3,
        gaps_out = 3,

        border_size = 2,

        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",

        col = {
            active_border = {
                colors = {
                    "rgba(d2b534ff)",
                    "rgba(416bb0ff)",
                },
                angle = 135,
            },

            inactive_border = "#0C1716ff",
        },

        snap = {
            enabled = true,
            window_gap = 10,
            monitor_gap = 10,
            border_overlap = true,
            respect_gaps = true,
        },
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        active_opacity   = 1,
        inactive_opacity = 0.75,
        fullscreen_opacity = 1.0,

        dim_special = 0.5,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled   = true,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },

    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0.3,
        accel_profile = "flat",

        touchpad = {
            natural_scroll = false,
        },
    },

    group = {
        col = {
            border_active = {
                colors = {
                    "rgba(416bb0ff)",
                    "rgba(d2b534ff)",
                },
                angle = 135,
            },

            border_inactive = "#0C1716ff",
        },

        groupbar = {
            font_size = 16,
            height = 16,

            col = {
                active = "rgba(ffff00aa)",
                inactive = "rgba(777700aa)",

                locked_active = "rgba(ff5500aa)",
                locked_inactive = "rgba(775500aa)",
            },
        },
    },

    -- Other
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,

        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,
    },

    cursor = {
        hide_on_key_press = true,
        inactive_timeout = 3,
    },

    binds = {
        drag_threshold = 100,
    },
})