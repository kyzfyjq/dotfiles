hl.on("hyprland.start", function () 
    hl.exec_cmd("fcitx5 -d")
    hl.exec_cmd("systemctl --user start waypaper-daemon.service")
end)
