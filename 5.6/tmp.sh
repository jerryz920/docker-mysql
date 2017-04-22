
# the error is about 62ms for timestamp
# control the test

# base = 2002
# for i = 1 - 20;
# post 1.1.1.1 base - 2 + 3 * i, base - 1 + 3 * i, base + 3 * i with same git source
# for kill = 2000, 2001, 2002; do
#   boot mysql with 10.10.1.36 test port = kill, ip = 1.1.1.1, expose 1999->19999, short.sh
#   boot mysql-runner with /run-short.sh
#   timestamp
#   poison 2000
#
IAAS_IP="152.3.145.38:5000"
mkdir -p ../results/

base=${1:-1018}
for n in `seq 1 1`; do
  b1=$base
  b2=$((base-1))
  b3=$((base-2))
  msg=`curl http://compute5:7777/postInstanceSet -d "{ \"principal\": \"$IAAS_IP\",  \"otherValues\": [\"test1\", \"instance-image-hash\", \"image\", \"1.1.1.1:$b1\", \"noconfig\"] }"`
  echo $msg | tee key
  inst_id=`python id.py <key`
  curl http://compute5:7777/updateSubjectSet -d "{ \"principal\": \"1.1.1.1:$b1\",  \"otherValues\": [\"$inst_id\"] }"
  curl http://compute5:7777/postAttesterImage -d "{ \"principal\": \"$IAAS_IP\",  \"otherValues\": [\"instance-image-hash\"]}"
  curl http://compute5:7777/postImageProperty -d "{ \"principal\": \"$IAAS_IP\",  \"otherValues\": [\"instance-image-hash\", \"git://github.com/jerryz920/mysql\"]}"

  msg=`curl http://compute5:7777/postInstanceSet -d "{ \"principal\": \"1.1.1.1:$b1\",  \"otherValues\": [\"test2\", \"container-image-hash\", \"image\", \"1.1.1.1:$b2\", \"noconfig\"] }"`
  echo $msg | tee key
  inst_id=`python id.py <key`
  curl http://compute5:7777/updateSubjectSet -d "{ \"principal\": \"1.1.1.1:$b2\",  \"otherValues\": [\"$inst_id\"] }"
  curl http://compute5:7777/postAttesterImage -d "{ \"principal\": \"$IAAS_IP\",  \"otherValues\": [\"container-image-hash\"]}"
  curl http://compute5:7777/postImageProperty -d "{ \"principal\": \"$IAAS_IP\",  \"otherValues\": [\"container-image-hash\", \"git://github.com/jerryz920/mysql\"]}"

  msg=`curl http://compute5:7777/postInstanceSet -d "{ \"principal\": \"1.1.1.1:$b2\",  \"otherValues\": [\"test3\", \"process-image-hash\", \"image\", \"1.1.1.1:$b3\", \"noconfig\"] }"`
  echo $msg | tee key
  inst_id=`python id.py <key`
  curl http://compute5:7777/updateSubjectSet -d "{ \"principal\": \"1.1.1.1:$b3\",  \"otherValues\": [\"$inst_id\"] }"
  curl http://compute5:7777/postAttesterImage -d "{ \"principal\": \"$IAAS_IP\",  \"otherValues\": [\"process-image-hash\"]}"
  curl http://compute5:7777/postImageProperty -d "{ \"principal\": \"$IAAS_IP\",  \"otherValues\": [\"process-image-hash\", \"git://github.com/jerryz920/mysql\"]}"


  echo "starting poison"
  curl http://compute5:7777/postObjectAcl -d "{ \"principal\": \"alice\",  \"otherValues\": [\"alice:object1\", \"git://github.com/jerryz920/mysql\"] }"
  curl http://compute5:7777/appAccessesObject -d "{ \"principal\": \"152.3.145.138:4144\",  \"otherValues\": [\"1.1.1.1:$b1\", \"alice:object1\"]}"
  curl http://compute5:7777/appAccessesObject -d "{ \"principal\": \"152.3.145.138:4144\",  \"otherValues\": [\"1.1.1.1:$b2\", \"alice:object1\"]}"
  curl http://compute5:7777/appAccessesObject -d "{ \"principal\": \"152.3.145.138:4144\",  \"otherValues\": [\"1.1.1.1:$b3\", \"alice:object1\"]}"


  curl http://compute5:7777/postInstancePoison -d "{ \"principal\": \"1.1.1.1:$b2\",  \"otherValues\": [\"test3\", \"1.1.1.1:$b3\"] }"

  curl http://compute5:7777/appAccessesObject -d "{ \"principal\": \"152.3.145.138:4144\",  \"otherValues\": [\"1.1.1.1:$b1\", \"alice:object1\"]}"
  curl http://compute5:7777/appAccessesObject -d "{ \"principal\": \"152.3.145.138:4144\",  \"otherValues\": [\"1.1.1.1:$b2\", \"alice:object1\"]}"
  curl http://compute5:7777/appAccessesObject -d "{ \"principal\": \"152.3.145.138:4144\",  \"otherValues\": [\"1.1.1.1:$b3\", \"alice:object1\"]}"
  curl http://compute5:7777/postInstancePoison -d "{ \"principal\": \"1.1.1.1:$b1\",  \"otherValues\": [\"test2\", \"1.1.1.1:$b2\"] }"

  curl http://compute5:7777/appAccessesObject -d "{ \"principal\": \"152.3.145.138:4144\",  \"otherValues\": [\"1.1.1.1:$b1\", \"alice:object1\"]}"
  curl http://compute5:7777/appAccessesObject -d "{ \"principal\": \"152.3.145.138:4144\",  \"otherValues\": [\"1.1.1.1:$b2\", \"alice:object1\"]}"
  curl http://compute5:7777/appAccessesObject -d "{ \"principal\": \"152.3.145.138:4144\",  \"otherValues\": [\"1.1.1.1:$b3\", \"alice:object1\"]}"

  curl http://compute5:7777/postInstancePoison -d "{ \"principal\": \"$IAAS_IP\",  \"otherValues\": [\"test1\", \"1.1.1.1:$b1\"] }"

  curl http://compute5:7777/appAccessesObject -d "{ \"principal\": \"152.3.145.138:4144\",  \"otherValues\": [\"1.1.1.1:$b1\", \"alice:object1\"]}"
  curl http://compute5:7777/appAccessesObject -d "{ \"principal\": \"152.3.145.138:4144\",  \"otherValues\": [\"1.1.1.1:$b2\", \"alice:object1\"]}"
  curl http://compute5:7777/appAccessesObject -d "{ \"principal\": \"152.3.145.138:4144\",  \"otherValues\": [\"1.1.1.1:$b3\", \"alice:object1\"]}"
done


# base = 20002
# for i = 1 - 20;
# post 1.1.1.1 base - 2 + 3 * i, base - 1 + 3 * i, base + 3 * i with same git source
# for kill = 2000, 2001, 2002; do
#   boot mysql with 10.10.1.36 test port = kill, ip = 1.1.1.1, expose 1999->19999, long.sh
#   boot mysql-runner with /run-long.sh
#   timestamp
#   poison 2000
#

