#!bin/bash

for dir in /hostfs/volume1/*; do
  [ -d "$dir" ] || continue
  folder_path="$dir"
  folder_name=$(basename "$dir")
  used=$(du -bs "$dir" 2>/dev/null | cut -f1)
  echo "folder_usage,folder=$folder_path,folder_name=$folder_name used_bytes=$used"
done