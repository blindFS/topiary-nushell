export const config = {
  default: {
    align: center
    updates: when_shown
    padding_left: 2
    padding_right: 2
    icon.font: "Sarasa Term SC Nerd:Bold:17.0"
    label.font: "Sarasa Term SC Nerd:Bold:12.0"
    icon.color: $colors.white
    label.color: $colors.fg
    icon.padding_left: 8
    icon.padding_right: 2
    label.padding_left: 2
    label.padding_right: 8
    background.corner_radius: 10
    background.color: $colors.bg
    background.border_width: 1
    background.border_color: $colors.bg
  }

  workspace_default_args: {
    icon.font.size: 12
    label.font.size: 17
    label.shadow.drawing: on
    label.shadow.color: $colors.bg
    label.shadow.distance: 3
    label.highlight_color: $colors.green
    background.drawing: off
    background.color: $colors.transparent
    background.border_width: 2
    background.border_color: $colors.fg
    background.shadow.drawing: on
    background.shadow.color: $colors.bg
    background.shadow.distance: 3
  }

  plugin_configs: [
    {
      name: ws_listener
      pos: left
      events: [aerospace_workspace_change space_windows_change]
      args: {
        updates: on
        drawing: off
        script: '{}/aerospace.nu'
      }
    }
    {
      name: front_app
      pos: left
      events: [front_app_switched aerospace_mode_change]
      args: {
        label.color: $colors.black
        icon.color: $colors.black
        icon.font.size: 20
        background.color: $colors.blue
        background.corner_radius: 3
        background.shadow.drawing: on
        background.shadow.color: $colors.bg
        background.shadow.distance: 3
        script: '{}/front_app.nu'
      }
    }
    {
      name: media
      pos: center
      events: [media_change]
      args: {
        icon: '󰐎'
        icon.color: $colors.fg
        label.color: $colors.fg
        background.color: $colors.bg
        background.border_color: $colors.fg
        script: '{}/media.nu'
      }
    }
    {
      name: media_cover
      pos: center
      events: [media_change]
      args: {
        icon.drawing: off
        label.drawing: off
        background.image.drawing: on
        background.image: media.artwork
        background.image.scale: 0.7
        background.color: $colors.transparent
        background.border_width: 0
      }
    }
    {
      name: clock
      args: {
        update_freq: 30
        icon: ''
        script: '{}/clock.nu'
        background.corner_radius: 3
        padding_right: 1
        padding_left: 1
        label.font.size: 10
      }
    }
    {
      name: volume
      events: [volume_change]
      args: {
        script: '{}/volume.nu'
        background.corner_radius: 3
        padding_right: 1
        padding_left: 1
      }
    }
    {
      name: battery
      events: [system_woke power_source_change]
      args: {
        update_freq: 120
        script: '{}/battery.nu'
        click_script: 'open x-apple.systempreferences:com.apple.preference.battery'
        background.corner_radius: 3
        padding_right: 1
      }
    }
    {
      name: separator_right
      args: {
        icon: ''
        padding_left: 0
        label.drawing: off
        background.drawing: off
        click_script: '{}/toggle_stats.nu'
      }
    }
    {
      name: disk
      args: {
        icon: ''
        update_freq: 120
        script: '{}/disk.nu'
        click_script: 'open -a "Disk Utility"'
        icon.color: $colors.green
        background.border_color: $colors.green
      }
    }
    {
      name: cpu
      args: {
        icon: ''
        update_freq: 10
        script: '{}/cpu.nu'
        click_script: 'open -a "Activity Monitor"'
        icon.color: $colors.yellow
        background.border_color: $colors.yellow
      }
    }
    {
      name: memory
      args: {
        icon: '﬙'
        update_freq: 10
        script: '{}/mem.nu'
        click_script: 'open -a "Activity Monitor"'
        icon.color: $colors.cyan
        background.border_color: $colors.cyan
      }
    }
    {
      name: temp_cpu
      args: {
        icon: ''
        label.font.size: 7
        label.y_offset: -4
        icon.font.size: 16
        update_freq: 5
        padding_left: -58
        script: '{}/temp.nu'
        click_script: '{}/popups/temp.nu'
        popup.align: left
        popup.background.border_width: 2
        popup.background.corner_radius: 3
        popup.background.border_color: $colors.yellow
        popup.background.drawing: on
      }
      popups: [
        {
          name: temp_fan1
          args: {
            label: "unk"
            icon: '󱑲'
          }
        }
        {
          name: temp_fan2
          args: {
            label: "unk"
            icon: '󱑳'
          }
        }
        {
          name: temp_power
          args: {
            label: "unk"
            icon: '󰠠'
          }
        }
      ]
    }
    {
      name: temp_gpu
      args: {
        label.font.size: 7
        padding_left: 0
        padding_right: 0
        icon.font.size: 16
        icon.drawing: off
        label.y_offset: 4
        background.drawing: off
      }
    }
    {
      name: network_down
      args: {
        icon: '󰖩'
        label.font.size: 7
        label.y_offset: -4
        update_freq: 3
        padding_left: -73
        padding_right: 23
        script: '{}/network.nu'
        icon.color: $colors.purple
        label.highlight_color: $colors.purple
        background.border_color: $colors.purple
      }
    }
    {
      name: network_up
      args: {
        label.font.size: 7
        padding_left: 0
        padding_right: 0
        icon.drawing: off
        label.y_offset: 4
        background.drawing: off
        label.highlight_color: $colors.purple
      }
    }
  ]
}

const table = [[a b]; [1 2] [2 [4 4]]]
const table_no_row = [[a b]; ]

mut foo: record<"a", b, "c": int, d: list<any>> = {}
