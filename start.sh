#!/bin/bash

gnome-terminal --tab --title="node0" -- bash -c "echo Running node0; hraftd -id node0 -haddr 10.211.55.16:11000 -raddr 10.211.55.16:12000 ~/node/node0; exec bash"

sleep 3

for ((i=1;i<=6;i++))
do
  gnome-terminal --tab --title="node${i}" -- bash -c "echo Running node${i}; hraftd -id node${i} -haddr 10.211.55.16:$((11000+${i})) -raddr 10.211.55.16:$((12000+${i})) -join 10.211.55.16:11000 ~/node/node${i}; exec bash"
done

