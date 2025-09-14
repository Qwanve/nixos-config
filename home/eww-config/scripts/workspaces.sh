#!/usr/bin/env bash
set -eou pipefail

swaymsg -rt get_workspaces | jq --unbuffered -c '[.[] | {name: .name, focused: .focused, windows: .representation}]'
swaymsg -t subscribe "[ 'workspace' ]" -mr | while read -r line; do
  swaymsg -rt get_workspaces | jq --unbuffered -c '[.[] | {name: .name, focused: .focused, windows: .representation}]'
done;
