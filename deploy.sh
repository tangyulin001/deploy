#!/bin/bash

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
cd ../../
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

# 提示用户输入新密码和旧密码
read -sp "Enter new MySQL root password: " new_password
read -sp "Enter old MySQL root password: " old_password

# 修改 MySQL 密码
sudo mysql -u root -p${old_password} -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$new_password'; FLUSH PRIVILEGES;"

# 输出结果
if [ $? -eq 0 ]; then
    echo "MySQL root password updated successfully."
    sudo systemctl restart mysql
else
    echo "Failed to update MySQL root password."
fi

# 修改 MySQL root 用户的主机
sudo mysql -u root -p"${new_password}" -e "UPDATE mysql.user SET Host='%' WHERE User='root'; FLUSH PRIVILEGES;"

# 检查命令执行结果并输出消息
if [ $? -eq 0 ]; then
    echo "MySQL root user host updated successfully."
else
    echo "Failed to update MySQL root user host."
fi

# 下载数据集
wget -O openmrs-2-2-1.sql.gz "https://openmrs.atlassian.net/wiki/download/attachments/26273323/openmrs-2-2-1.sql.gz?api=v2"

# 解压缩文件
gunzip openmrs-2-2-1.sql.gz

# 导入数据到 MySQL 数据库
mysql -u root -p"$mysql_password" -e "CREATE DATABASE IF NOT EXISTS openmrs;"
mysql -u root -p"$mysql_password" openmrs < openmrs-2-2-1.sql

# 创建视图
mysql -u root -p"$mysql_password" <<EOF
USE openmrs;
CREATE VIEW Vedrfolnir AS
SELECT
    o.obs_id,
    e.patient_id,
    cn.name AS concept_name,
    cd.description
FROM
    obs o
JOIN
    encounter e ON o.encounter_id = e.encounter_id
JOIN
    concept_description cd ON o.concept_id = cd.concept_id
JOIN
    concept_name cn ON o.concept_id = cn.concept_id;
EOF

# 检查命令执行结果并输出消息
if [ $? -eq 0 ]; then
    echo "View 'Vedrfolnir' created successfully."
else
    echo "Failed to create view 'Vedrfolnir'."
fi

#创建存放密文的表
mysql -u root -p"$mysql_password" -e "CREATE TABLE patient_data (patient_id INT,ciphertext BLOB,hash CHAR(64));"

# 检查命令执行结果并输出消息
if [ $? -eq 0 ]; then
    echo "TABLE patient_data created successfully."
else
    echo "Failed to create TABLE patient_data."
fi














