#!/bin/bash


gnome-terminal --tab --title="nodenumber" -- bash -c "echo Running nodenumber; hraftd -id nodenumber -haddr ipaddr:11000 -raddr ipaddr:12000 -join node0_ip:11000 ~/node/nodenumber; exec bash"


