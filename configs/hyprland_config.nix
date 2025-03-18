{
}:
{
  config = ''
    monitor=,1920x1080@60,0x0,1
    $terminal = alacritty 
    $fileManager = pcmanfm
    $menu = bemenu-run
    env = XCURSOR_THEME,Adwaita
    env = HYPRCURSOR_THEME,Adwaita
    exec-once = waybar &
    exec-once = swww-daemon &
    misc {
      force_default_wallpaper = 0
      disable_splash_rendering = true
      disable_hyprland_logo = true
    }

    general {
        gaps_in = 5
        gaps_out = 10
        border_size = 3

        col.active_border = $lavender
        col.inactive_border = $base

        resize_on_border = true 
        allow_tearing = false
        layout = dwindle 
    }

    dwindle {
        preserve_split = true
	pseudotile = true 
    }

    decoration {
        rounding = 10
        shadow {
            enabled = false 
        }
        blur {
            enabled = false 
        }
    }

    animations {
        enabled = yes, please :)

        bezier = easeOutQuint,0.23,1,0.32,1
        bezier = easeInOutCubic,0.65,0.05,0.36,1
        bezier = linear,0,0,1,1
        bezier = almostLinear,0.5,0.5,0.75,1.0
        bezier = quick,0.15,0,0.1,1

        animation = global, 1, 10, default
        animation = border, 1, 5.39, easeOutQuint
        animation = windows, 1, 4.79, easeOutQuint
        animation = windowsIn, 1, 4.1, easeOutQuint, popin 87%
        animation = windowsOut, 1, 1.49, linear, popin 87%
        animation = fadeIn, 1, 1.73, almostLinear
        animation = fadeOut, 1, 1.46, almostLinear
        animation = fade, 1, 3.03, quick
        animation = layers, 1, 3.81, easeOutQuint
        animation = layersIn, 1, 4, easeOutQuint, fade
        animation = layersOut, 1, 1.5, linear, fade
        animation = fadeLayersIn, 1, 1.79, almostLinear
        animation = fadeLayersOut, 1, 1.39, almostLinear
        animation = workspaces, 1, 1.5, almostLinear, slidevert
        animation = workspacesIn, 1, 1.5, almostLinear, slidevert 
        animation = workspacesOut, 1, 1.5, almostLinear, slidevert
    }

    cursor {
      no_warps = true
    }

    input {
        kb_layout = us,ua
        kb_options = grp:win_space_toggle, caps:escape
        repeat_rate = 50
        repeat_delay = 300
        follow_mouse = 2

        sensitivity = 0 # -1.0 - 1.0, 0 means no modification.

        touchpad {
          tap-to-click = true
          disable_while_typing = true
        }
    }

    $mainMod = ALT

    bind = $mainMod, E, exit,
    bind = $mainMod, Return, exec, $terminal
    bind = $mainMod, q, killactive,
    bind = $mainMod, d, exec, $menu

    bind = $mainMod, h, movefocus, l
    bind = $mainMod, l, movefocus, r
    bind = $mainMod, k, movefocus, u
    bind = $mainMod, j, movefocus, d

    bind = $mainMod SHIFT, h, movewindow, l
    bind = $mainMod SHIFT, l, movewindow, r
    bind = $mainMod SHIFT, k, movewindow, u
    bind = $mainMod SHIFT, j, movewindow, d
    bind = $mainMod SHIFT, Return, swapsplit
    bind = $mainMod, t, togglesplit

    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 4, workspace, 4
    bind = $mainMod, 5, workspace, 5
    bind = $mainMod, 6, workspace, 6
    bind = $mainMod, 7, workspace, 7
    bind = $mainMod, 8, workspace, 8
    bind = $mainMod, 9, workspace, 9
    bind = $mainMod, 0, workspace, 10

    bind = $mainMod SHIFT, 1, movetoworkspacesilent, 1
    bind = $mainMod SHIFT, 2, movetoworkspacesilent, 2
    bind = $mainMod SHIFT, 3, movetoworkspacesilent, 3
    bind = $mainMod SHIFT, 4, movetoworkspacesilent, 4
    bind = $mainMod SHIFT, 5, movetoworkspacesilent, 5
    bind = $mainMod SHIFT, 6, movetoworkspacesilent, 6
    bind = $mainMod SHIFT, 7, movetoworkspacesilent, 7
    bind = $mainMod SHIFT, 8, movetoworkspacesilent, 8
    bind = $mainMod SHIFT, 9, movetoworkspacesilent, 9
    bind = $mainMod SHIFT, 0, movetoworkspacesilent, 10

    bind = $mainMod SHIFT, SPACE, togglefloating,
    bind = $mainMod, f, fullscreen

    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod, mouse:273, resizewindow

    # screenshots
    bind =, Print, exec, grim -g "$(slurp)" - | wl-copy && wl-paste > ~/screenshot$(date +%F_%T).png 

    # Laptop multimedia keys for volume and LCD brightness
    binde = ,XF86AudioRaiseVolume, exec, amixer set Master 5%+
    binde = ,XF86AudioLowerVolume, exec, amixer set Master 5%-
    binde = ,XF86AudioMute, exec, amixer set Master toggle
    binde = ,XF86MonBrightnessUp, exec, brightnessctl s 5%+
    binde = ,XF86MonBrightnessDown, exec, brightnessctl s 5%-

    # Requires playerctl
    bind = , XF86AudioNext, exec, playerctl next
    bind = , XF86AudioPlay, exec, playerctl play-pause
    bind = , XF86AudioPrev, exec, playerctl previous

    binde = SUPER, F5, exec, brightnessctl s 5%-
    binde = SUPER, F6, exec, brightnessctl s 5%+
    binde = SUPER, F7, exec, amixer set Master toggle
    binde = SUPER, F8, exec, amixer set Master 5%-
    binde = SUPER, F9, exec, amixer set Master 5%+
    bind = SUPER, F10, exec, playerctl previous
    bind = SUPER, F11, exec, playerctl play-pause
    bind = SUPER, F12, exec, playerctl next

    # Ignore maximize requests from apps. You'll probably like this.
    windowrulev2 = suppressevent maximize, class:.*

    # Fix some dragging issues with XWayland
    windowrulev2 = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0
  '';
}
