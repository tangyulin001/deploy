#!/bin/bash

cd ../
mkdir work 
cd work
export GOPATH=$PWD
mkdir -p src/github.com/otoolep
cd src/github.com/otoolep/
git clone git@github.com:otoolep/hraftd.git
cd hraftd
git clone https://github.com/hashicorp/raft.git
echo 'replace github.com/hashicorp/raft => ./raft' >> go.mod
go mod tidy
go install
cd ../../../../bin
export PATH=$PATH:$PWD

# 检查MySQL是否已安装
if ! dpkg -l | grep -q mysql-server; then
    echo "MySQL未安装，将执行更新并安装MySQL..."
    # 更新apt-get源并安装MySQL
    sudo apt-get update
    sudo apt-get install mysql-server -y
    sudo ufw allow mysql
else
    echo "MySQL已经安装，无需执行安装操作。"
fi

# 修改mysql密码
read -sp "Enter new MySQL root password: " new_password
sudo mysql -u root -p -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$new_password'; FLUSH PRIVILEGES;"

# 输出结果
if [ $? -eq 0 ]; then
    echo "MySQL root password updated successfully."
else
    echo "Failed to update MySQL root password."
fi

# 修改 MySQL root 用户的主机

sudo mysql -u root -p"${new_password}" -e "UPDATE mysql.user SET Host='%' WHERE User='root' AND Host='localhost'; FLUSH PRIVILEGES;"

# 检查命令执行结果并输出消息

if [ $? -eq 0 ]; then

    echo "MySQL root user host updated successfully."

else

    echo "Failed to update MySQL root user host."

fi


