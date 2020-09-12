#!/usr/bin/env bash
for i in $(ps -e -o user= | sort | uniq); do
	  printf '%-20s%10s\n' $i $(sudo ~/bin/ps_mem.py --total -p $(pgrep -d, -u $i))
done
