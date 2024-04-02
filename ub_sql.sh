#!/bin/bash

. ./utils
# 检查MySQL是否已安装
if ! dpkg -l | grep -q mysql-server; then
    infoln "can't find MySQL，install MySQL..."
    sudo apt-get update
    sudo apt-get install mysql-server -y
    sudo ufw allow mysql
else
    echo "MySQL already exists."
fi

# 提示用户输入旧密码
read -sp "Enter old MySQL root password: " old_password

# 修改 MySQL 密码为root1234
sudo mysql -u root -p${old_password} -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root1234'; FLUSH PRIVILEGES;"
if [ $? -eq 0 ]; then
    successln "MySQL root password updated to root1234 successfully."
    sudo systemctl restart mysql
else
    fatalln "Failed to update MySQL root password."
fi

# 修改 MySQL root 用户的主机
sudo mysql -u root -p"root1234" -e "UPDATE mysql.user SET Host='%' WHERE User='root'; FLUSH PRIVILEGES;"
if [ $? -eq 0 ]; then
    echo "MySQL root user host updated successfully."
else
    echo "Failed to update MySQL root user host."
fi

# 下载数据集并导入到数据库
wget -O openmrs-2-2-1.sql.gz "https://openmrs.atlassian.net/wiki/download/attachments/26273323/openmrs-2-2-1.sql.gz?api=v2"
gunzip openmrs-2-2-1.sql.gz
mysql -u root -p"root1234" -e "CREATE DATABASE IF NOT EXISTS foo;"
mysql -u root -p"root1234" foo < openmrs-2-2-1.sql

# 创建Vedrfolnir视图
mysql -u root -p"root1234" <<EOF
USE foo;
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
    successln "View 'Vedrfolnir' created successfully."
else
    fatalln "Failed to create view 'Vedrfolnir'."
fi

#创建存放密文的patient_data表
mysql -u root -p"root1234" -e "USE foo;CREATE TABLE patient_data (patient_id INT,ciphertext BLOB,hash CHAR(64));"
if [ $? -eq 0 ]; then
    successln "TABLE patient_data created successfully."
else
    fatalln "Failed to create TABLE patient_data."
fi




