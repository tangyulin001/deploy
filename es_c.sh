#!/bin/bash

#the content of one test
for i in {1..5}
do
sed "s/LIMIT 100/LIMIT $((${i}*100000))/g" ./daemon/main.go > ./daemon/new2.go
docker build --network=host -t "es-${i}" .
#sleep 30s
echo "" >> ../../output/es-out.txt
echo "第${n}次测试..." >> ../../output/es-out.txt
echo "LIMIT $((${i}*100000)):" >> ../../output/es-out.txt
sleep 1
docker run --rm --net=host --name "es-${i}" "es-${i}" >> ../../output/es-out.txt
docker exec -i mysql-ct mysql -uroot -p"root1234" foo -e "select count(*) from patient_data;"
sleep 10
docker rmi "es-${i}" 
echo "清空patient_data表数据..."
docker exec -i mysql-ct mysql -uroot -p"root1234" foo -e "TRUNCATE TABLE patient_data;"
sleep 30
docker exec -i mysql-ct mysql -uroot -p"root1234" foo -e "select count(*) from patient_data;"
done

