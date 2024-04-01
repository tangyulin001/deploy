#!/bin/bash

#the content of one test
for i in {1..5}
do
sed "s/LIMIT 100/LIMIT $((${i}*100000))/g" ./daemon/main.go > ./daemon/new2.go
docker build --no-cache --network=host -t "es_${i}" .
echo "" >> ../../output/es_out.txt
echo "第${n}次测试..." >> ../../output/es_out.txt
echo "LIMIT $((${i}*100000)):" >> ../../output/es_out.txt
docker run --rm --net=host --name "es_${i}" "es_${i}" >> ../../output/es_out.txt
echo "LIMIT $((${i}*100000))情况下patient_data表内数据数量："
docker exec -i mysql-ct mysql -uroot -p"root1234" foo -e "select count(*) from patient_data;"
docker rmi "es_${i}" 
echo "清空patient_data表数据..."
docker exec -i mysql-ct mysql -uroot -p"root1234" foo -e "TRUNCATE TABLE patient_data;"
docker exec -i mysql-ct mysql -uroot -p"root1234" foo -e "select count(*) from patient_data;"
done

