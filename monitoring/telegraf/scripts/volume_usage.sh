#!/bin/bash
df_out=$(df -B1 /hostfs/volume1 | awk 'NR==2')
total=$(echo $df_out | awk '{print $2}')
used=$(echo $df_out | awk '{print $3}')
free=$(echo $df_out | awk '{print $4}')
used_percent=$(echo $df_out | awk '{print $5}' | tr -d '%')

echo "volume_usage,path=/hostfs/volume1 used=${used}i,free=${free}i,total=${total}i,used_percent=${used_percent}"