#!/usr/bin/env bash

pactl get-sink-volume @DEFAULT_SINK@ | rg "(\d{1,3})%" -r '$1' -o --line-buffered 
pactl subscribe | rg "sink" --line-buffered | xargs -L1 pactl get-sink-volume @DEFAULT_SINK@ | rg "(\d{1,3})%" -r '$1' -o --line-buffered 
