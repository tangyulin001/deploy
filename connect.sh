#!/bin/bash



read -p "请输入节点的编号：" number
read -p "请输入节点的ip地址：" ipaddr

if [${number} -gt 0]
then
  read -p "请输入要加入的节点的ip地址：" join_ip
  gnome-terminal --tab --title="node${number}" -- bash -c "echo Running node${number}; hraftd -id node${number} -haddr ${ipaddr}:11000 -raddr ${ipaddr}:12000 -join ${join_ip}:11000 ~/node${number}; exec bash"
elif [${number} -eq 0]
then
  gnome-terminal --tab --title="node0" -- bash -c "echo Running node0; hraftd -id node0 -haddr ${ipaddr}:11000 -raddr ${ipaddr}:12000 ~/node0; exec bash"
else
  echo "请输入非负整数"
fi
  



