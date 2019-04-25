#!/bin/bash
file="list.host"
> task2.out
> task3.out
> task4.out
while IFS= read -r lineInput
do
    lineList=($lineInput)
    line="${lineList[0]}"
    printf 'Host: %s\n' "$line"
    out="$(traceroute -m 100 -n -w 1 $line)"
    num="$(echo "$out" | wc -l)"
    hop=$((num-1))
    printf 'Hop count: %d\n' "$hop"
    echo "$out" >> task2.out
    echo "$line" >> task3.out
    v1="$(ping -c 3 $line)"
    echo "$v1" >> task3.out
    value="$(echo "$v1" | tail -n +8 | awk -F'[/]' '{print $5 " " $7}')"
    array=($value)
    avg1="${array[0]}"
    mdev1="${array[1]}"
    echo 1. avg $avg1 mdev $mdev1
    v1="$(ping -c 3 $line)"
    echo "$v1" >> task3.out
    value="$(echo "$v1" | tail -n +8 | awk -F'[/]' '{print $5 " " $7}')"
    array=($value)
    avg2="${array[0]}"
    mdev2="${array[1]}"
    echo 2. avg $avg2 mdev $mdev2
    v1="$(ping -c 3 $line)"
    echo "$v1" >> task3.out
    value="$(echo "$v1" | tail -n +8 | awk -F'[/]' '{print $5 " " $7}')"
    array=($value)
    avg3="${array[0]}"
    mdev3="${array[1]}"
    echo 3. avg $avg3 mdev $mdev3
    totavg=$(awk "BEGIN {print ($avg1+$avg2+$avg3)/3; exit}")
    echo Total AVG $totavg
    jitter=$(awk "BEGIN {print sqrt((($mdev1)**2 + ($mdev2)**2 + ($mdev3)**2) / 3 ); exit}")
    echo Jitter $jitter
    iperfOut="$("${lineList[1]}" -c $line "${lineList[2]}" "${lineList[3]}")"
    echo "$iperfOut" >> task4.out
    iperfOut="$("${lineList[1]}" -c $line "${lineList[2]}" "${lineList[3]}")"
    echo "$iperfOut" >> task4.out
    iperfOut="$("${lineList[1]}" -c $line "${lineList[2]}" "${lineList[3]}")"
    echo "$iperfOut" >> task4.out
    echo Done
done <"$file"
