#!/usr/bin/env bash

function get_volume() {
  read _ vol mute <<< $(wpctl get-volume @DEFAULT_AUDIO_SINK@);
  if [ -z $mute ]; then
    mute="false";
  else
    mute="true";
  fi;
  echo "{\"volume\": $vol, \"mute\": \"$mute\"}"
}

get_volume
pw-mon -ao | rg --line-buffered "changed:" | while read _; do
  get_volume;
done;

# wpctl get-volume @DEFAULT_SINK@ | rg --line-buffered --only-matching "\d\.\d{2}"
# pw-mon -ao | rg --line-buffered "changed:" | xargs -L1 wpctl get-volume @DEFAULT_SINK@ | rg --line-buffered --only-matching "\d\.\d{2}"

# pactl get-sink-volume @DEFAULT_SINK@ | rg "(\d{1,3})%" -r '$1' -o --line-buffered 
# pactl subscribe | rg "sink" --line-buffered | xargs -L1 pactl get-sink-volume @DEFAULT_SINK@ | rg "(\d{1,3})%" -r '$1' -o --line-buffered 
