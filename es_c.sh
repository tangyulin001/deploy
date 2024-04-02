#!/bin/bash

. ../utils

#the content of every test
for i in {1..2}
do
sed "s/LIMIT 100/LIMIT $((${i}*100))/g" ./daemon/test_encrypt.go > ./daemon/new2.go

infoln "in condition of LIMIT $((${i}*100000)),docker es_${i} is building..."
docker build --no-cache --network=host -t "es_${i}" .

if [ $? -eq 0 ]; then
successln "docker es_${i} built successfully."
fi

echo "" >> ../output/es_out.txt
echo "第${n}次测试..." >> ../output/es_out.txt
echo "LIMIT $((${i}*100000)):" >> ../output/es_out.txt

#write results to ../output/es_out.txtes_out.txt
docker run --rm --net=host --name "es_${i}" "es_${i}" >> ../output/es_out.txt

infoln "in condition of LIMIT $((${i}*100000)),the number of patient_data is："
mysql -uroot -p"root1234" foo -e "select count(*) from patient_data;"

infoln "delete docker es_${i}..."
docker rmi "es_${i}" 

infoln "delete the data of patient_data..."
mysql -uroot -p"root1234" foo -e "TRUNCATE TABLE patient_data;"

infoln "the number of table patient_data now is :"
mysql -uroot -p"root1234" foo -e "select count(*) from patient_data;"
done

