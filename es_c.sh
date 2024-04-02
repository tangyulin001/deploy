#!/bin/bash

. ../utils

#the content of every test
for i in {1..5}
do
sed "s/patient_data LIMIT 100/patient_data/g;s/Vedrfolnir LIMIT 100/Vedrfolnir LIMIT $((${i}*100000))/g" ./daemon/test_encrypt.go > ./daemon/new2.go

infoln "in condition of LIMIT $((${i}*100000)),docker es_${i} is building..."
docker build --no-cache --network=host -t "es_${i}" .

if [ $? -eq 0 ]; then
successln "docker es_${i} built successfully."
fi

echo "" >> ../output/es.out
echo "第${n}次测试..." >> ../output/es.out
echo "LIMIT $((${i}*100000)):" >> ../output/es.out

#write results to ../output/es.outes.out
docker run --rm --net=host --name "es_${i}" "es_${i}" >> ../output/es.out

infoln "in condition of LIMIT $((${i}*100000)),the number of patient_data is："
mysql -uroot -p"root1234" foo -e "select count(*) from patient_data;"

infoln "delete docker es_${i}..."
docker rmi "es_${i}" 

infoln "delete the data of patient_data..."
mysql -uroot -p"root1234" foo -e "TRUNCATE TABLE patient_data;"

infoln "the number of table patient_data now is :"
mysql -uroot -p"root1234" foo -e "select count(*) from patient_data;"
done

