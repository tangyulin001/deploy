#!/bin/bash

gnome-terminal --tab --title="node0" -- bash -c "echo Running node0; hraftd -id node0 -haddr 10.211.55.16:11000 -raddr 10.211.55.16:12000 ~/node0; exec bash"
