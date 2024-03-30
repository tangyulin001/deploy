#!/bin/bash

wget -O openmrs-2-2-1.sql.gz "https://openmrs.atlassian.net/wiki/download/attachments/26273323/openmrs-2-2-1.sql.gz?api=v2"
gunzip openmrs-2-2-1.sql.gz
docker run -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root1234 --name mysql-ct mysql:latest
docker cp openmrs-2-2-1.sql mysql-ct:.
docker exec -it mysql-ct sh -c 'mysql -uroot -p"root1234" -e "CREATE DATABASE IF NOT EXISTS foo;";mysql -u root -p"root1234" foo < openmrs-2-2-1.sql;mysql -u root -p"root1234" <<EOF
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
mysql -u root -p"root1234" -e "USE foo;CREATE TABLE patient_data (patient_id INT,ciphertext BLOB,hash CHAR(64));"'

wait
git clone https://github.com/HenryRuis/Merkle2Test.git
sleep 3
cd Merkle2Test
touch Dockerfile
chmod a+x Dockerfile
echo 'FROM golang:latest
WORKDIR /go/src/app
ENV GOPROXY=https://goproxy.cn
COPY . .
RUN go run ./daemon/new.go > out.txt
CMD ["cat","out.txt"]' > Dockerfile
for i in {1..5}
do
sed "s/LIMIT 10000/LIMIT $((${i}*10000))/" ./daemon/main.go > ./daemon/new.go
docker build --network=host -t "mt-${i}" .
wait
docker run --rm --net=host --name "mt-${i}" "mt-${i}" > "output${i}.txt"
wait 
#docker kill "mt-${i}"
#docker rm -f "mt-${i}"
docker rmi "mt-${i}" 
done
