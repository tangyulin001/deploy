#!/bin/bash



read -p "请输入节点的编号：" number
read -p "请输入节点的ip地址：" ipaddr

gnome-terminal --tab --title="node${number}" -- bash -c "echo Running node${number}; hraftd -id node${number} -haddr ${ipaddr}:11000 -raddr ${ipaddr}:12000 -join 10.211.55.16:11000 ~/node${number}; exec bash"



