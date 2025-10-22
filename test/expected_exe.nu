#!/usr/bin/env nu

use constants.nu [
  colors
  get_icon_by_app_name
  "foo bar"
]

const animate_frames = 30

def modify_args_per_workspace [
  sid: string,
  focused_sid: string,
]: nothing -> list<string> {
  let icons = (
    aerospace list-windows --workspace $sid --json
    | from json | get app-name
    | each { $in | get_icon_by_app_name }
    | uniq | sort
    | str join ' '
  )
  let extra = (
    if $sid == $focused_sid {
      {highlight: on, border_color: $colors.green}
    } else {
      {highlight: off, border_color: $colors.fg}
    }
  )

  ['--set', $"space.($sid)"]
  | append (
    if (($icons | is-empty) and ($sid != $focused_sid)) {
      [
        background.drawing=off,
        label=,
        padding_left=-2,
        padding_right=-2,
      ]
    } else {
      [
        background.drawing=on,
        label=($icons),
        label.highlight=($extra.highlight),
        padding_left=2,
        padding_right=2,
      ]
    }
  )
  | append $"background.border_color=($extra.border_color)"
}

def workspace_modification_args [
  name: string,
  last_sid: string,
]: nothing -> list<string> {
  # use listener's label to store last focused space id
  let focused_sid = (aerospace list-workspaces --focused)
  let ids_to_modify = (
    if ($last_sid | is-empty) { (aerospace list-workspaces --all | lines) }
    else {
      [$focused_sid, $last_sid]
    }
  )
  $ids_to_modify
  | uniq
  | each { modify_args_per_workspace $in $focused_sid }
  | flatten
  | append ["--set", $name, $"label=($focused_sid)"]
}

# remained for other possible signals
match $env.SENDER {
  _ => {
    # invisible item to store last focused sid
    let last_sid = (sketchybar --query $env.NAME | from json | get label.value)
    sketchybar --animate tanh $animate_frames ...(workspace_modification_args $env.NAME $last_sid)
  }
}
