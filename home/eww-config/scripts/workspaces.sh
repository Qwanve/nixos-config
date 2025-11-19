#!/usr/bin/env bash
set -eou pipefail

niri msg -j workspaces | jq --unbuffered --compact-output '[sort_by(.idx) | .[].is_focused]'
niri msg -j event-stream | while read -r line; do
  niri msg -j workspaces | jq --unbuffered --compact-output '[sort_by(.idx) | .[].is_focused]'
done;
# swaymsg -rt get_workspaces | jq --unbuffered -c '[.[] | {name: .name, focused: .focused, windows: .representation}]'
# swaymsg -t subscribe "[ 'workspace' ]" -mr | while read -r line; do
#   swaymsg -rt get_workspaces | jq --unbuffered -c '[.[] | {name: .name, focused: .focused, windows: .representation}]'
# done;
