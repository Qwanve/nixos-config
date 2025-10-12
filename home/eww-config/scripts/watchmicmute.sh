#!/usr/bin/env bash

pactl get-source-mute @DEFAULT_SOURCE@ | rg -o "yes|no"
pactl subscribe | rg "source" --line-buffered | xargs -L1 pactl get-source-mute @DEFAULT_SOURCE@ | rg -o "yes|no" --line-buffered
