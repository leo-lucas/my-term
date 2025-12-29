#!/bin/bash

# CPU: Usage from /proc/stat for instant Linux metrics
cpu_usage=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf "%.1f", usage}')

# RAM: Memory usage in MiB
ram_data=($(free -m | awk '/Mem:/ {printf "%d %d", $3, $2}'))
ram_used=${ram_data[0]}
ram_total=${ram_data[1]}
ram_pct=$(( ram_used * 100 / ram_total ))

# GPU and VRAM: Check for nvidia-smi
if command -v nvidia-smi &> /dev/null; then
    gpu_data=($(nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total --format=csv,noheader,nounits | tr ',' ' '))
    gpu_util="${gpu_data[0]}%"
    vram_used="${gpu_data[1]}MiB"
    vram_total="${gpu_data[2]}MiB"
else
    gpu_util="N/A"
    vram_used="N/A"
fi

# Formatted output
echo -e "CPU: ${cpu_usage}% | RAM: ${ram_pct}% (${ram_used}/${ram_total} MiB) | GPU: ${gpu_util} | VRAM: ${vram_used}"