#!/usr/bin/env bash

pactl get-sink-mute @DEFAULT_SINK@ | rg -o "yes|no"
pactl subscribe | rg "sink" --line-buffered | xargs -L1 pactl get-sink-mute @DEFAULT_SINK@ | rg -o "yes|no" --line-buffered
