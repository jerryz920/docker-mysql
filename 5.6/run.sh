
# the error is about 62ms for timestamp
# control the test

# base = 2002
# for i = 1 - 20;
# post 10.10.1.37 base - 2 + 3 * i, base - 1 + 3 * i, base + 3 * i with same git source
# for kill = 2000, 2001, 2002; do
#   boot mysql with 10.10.1.36 test port = kill, ip = 10.10.1.37, expose 1999->19999, short.sh
#   boot mysql-runner with /run-short.sh
#   timestamp
#   poison 2000
#
IAAS_IP="152.3.145.38:5000"
mkdir -p ../results/

base=2152
for n in `seq 1 20`; do
  b1=$base
  b2=$((base-1))
  b3=$((base-2))
  msg=`curl http://compute5:7777/postInstanceSet -d "{ \"principal\": \"$IAAS_IP\",  \"otherValues\": [\"test1\", \"instance-image-hash\", \"image\", \"10.10.1.37:$b1\", \"noconfig\"] }"`
  echo $msg | tee key
  inst_id=`python id.py <key`
  curl http://compute5:7777/updateSubjectSet -d "{ \"principal\": \"10.10.1.37:$b1\",  \"otherValues\": [\"$inst_id\"] }"
  curl http://compute5:7777/postAttesterImage -d "{ \"principal\": \"$IAAS_IP\",  \"otherValues\": [\"instance-image-hash\"]}"
  curl http://compute5:7777/postImageProperty -d "{ \"principal\": \"$IAAS_IP\",  \"otherValues\": [\"instance-image-hash\", \"https://github.com/jerryz920/mysql\"]}"

  msg=`curl http://compute5:7777/postInstanceSet -d "{ \"principal\": \"10.10.1.37:$b1\",  \"otherValues\": [\"test2\", \"container-image-hash\", \"image\", \"10.10.1.37:$b2\", \"noconfig\"] }"`
  echo $msg | tee key
  inst_id=`python id.py <key`
  curl http://compute5:7777/updateSubjectSet -d "{ \"principal\": \"10.10.1.37:$b2\",  \"otherValues\": [\"$inst_id\"] }"
  curl http://compute5:7777/postAttesterImage -d "{ \"principal\": \"$IAAS_IP\",  \"otherValues\": [\"container-image-hash\"]}"
  curl http://compute5:7777/postImageProperty -d "{ \"principal\": \"$IAAS_IP\",  \"otherValues\": [\"container-image-hash\", \"https://github.com/jerryz920/mysql\"]}"

  msg=`curl http://compute5:7777/postInstanceSet -d "{ \"principal\": \"10.10.1.37:$b2\",  \"otherValues\": [\"test3\", \"process-image-hash\", \"image\", \"10.10.1.37:$b3\", \"noconfig\"] }"`
  echo $msg | tee key
  inst_id=`python id.py <key`
  curl http://compute5:7777/updateSubjectSet -d "{ \"principal\": \"10.10.1.37:$b3\",  \"otherValues\": [\"$inst_id\"] }"
  curl http://compute5:7777/postAttesterImage -d "{ \"principal\": \"$IAAS_IP\",  \"otherValues\": [\"process-image-hash\"]}"
  curl http://compute5:7777/postImageProperty -d "{ \"principal\": \"$IAAS_IP\",  \"otherValues\": [\"process-image-hash\", \"https://github.com/jerryz920/mysql\"]}"

  k=$b3
    eval $(docker-machine env v1)
  	docker run -dt --rm --name mysql -p 1999:19999 -p 3307:3307 -p 3306:3306 -e ABAC_TEST_PORT=$k -e ABAC_TEST_IP=10.10.1.37  mysql test-short.sh 
    eval $(docker-machine env v2)
        docker run -it --rm mysql-runner run-short.sh >> results/out-short-$k &

	echo -e 'start ' >> results/out-short-start-$k
	./stamp >> results/out-short-start-$k
	sleep 5
	# curl http://compute5:7777/postInstancePoison -d "{ \"principal\": \"10.10.1.37:$b2\",  \"otherValues\": [\"test3\", \"10.10.1.37:$b3\"] }"
  k=$b2
    eval $(docker-machine env v1)
  	docker run -dt --rm --name mysql -p 1999:19999 -p 3307:3307 -p 3306:3306 -e ABAC_TEST_PORT=$k -e ABAC_TEST_IP=10.10.1.37  mysql test-short.sh 
    eval $(docker-machine env v2)
        docker run -it --rm mysql-runner run-short.sh >> results/out-short-$k &

	echo -e 'start ' >> results/out-short-start-$k
	./stamp >> results/out-short-start-$k
	sleep 5
	# curl http://compute5:7777/postInstancePoison -d "{ \"principal\": \"10.10.1.37:$b1\",  \"otherValues\": [\"test2\", \"10.10.1.37:$b2\"] }"

  k=$b1
    eval $(docker-machine env v1)
  	docker run -dt --rm --name mysql -p 1999:19999 -p 3307:3307 -p 3306:3306 -e ABAC_TEST_PORT=$k -e ABAC_TEST_IP=10.10.1.37  mysql test-short.sh 
    eval $(docker-machine env v2)
        docker run -it --rm mysql-runner run-short.sh >> results/out-short-$k &

	echo -e 'start ' >> results/out-short-start-$k
	./stamp >> results/out-short-start-$k
	# curl http://compute5:7777/postInstancePoison -d "{ \"principal\": \"$IAAS_IP\",  \"otherValues\": [\"test1\", \"10.10.1.37:$b1\"] }"
	sleep 5
done

base=20002
for n in `seq 1 20`; do
  b1=$base
  b2=$((base-1))
  b3=$((base-2))
  msg=`curl http://compute5:7777/postInstanceSet -d "{ \"principal\": \"$IAAS_IP\",  \"otherValues\": [\"test1\", \"instance-image-hash\", \"image\", \"10.10.1.37:$b1\", \"noconfig\"] }"`
  echo $msg | tee key
  inst_id=`python id.py <key`
  curl http://compute5:7777/updateSubjectSet -d "{ \"principal\": \"10.10.1.37:$b1\",  \"otherValues\": [\"$inst_id\"] }"
  curl http://compute5:7777/postAttesterImage -d "{ \"principal\": \"$IAAS_IP\",  \"otherValues\": [\"instance-image-hash\"]}"
  curl http://compute5:7777/postImageProperty -d "{ \"principal\": \"$IAAS_IP\",  \"otherValues\": [\"instance-image-hash\", \"https://github.com/jerryz920/mysql\"]}"

  msg=`curl http://compute5:7777/postInstanceSet -d "{ \"principal\": \"10.10.1.37:$b1\",  \"otherValues\": [\"test2\", \"container-image-hash\", \"image\", \"10.10.1.37:$b2\", \"noconfig\"] }"`
  echo $msg | tee key
  inst_id=`python id.py <key`
  curl http://compute5:7777/updateSubjectSet -d "{ \"principal\": \"10.10.1.37:$b2\",  \"otherValues\": [\"$inst_id\"] }"
  curl http://compute5:7777/postAttesterImage -d "{ \"principal\": \"$IAAS_IP\",  \"otherValues\": [\"container-image-hash\"]}"
  curl http://compute5:7777/postImageProperty -d "{ \"principal\": \"$IAAS_IP\",  \"otherValues\": [\"container-image-hash\", \"https://github.com/jerryz920/mysql\"]}"

  msg=`curl http://compute5:7777/postInstanceSet -d "{ \"principal\": \"10.10.1.37:$b2\",  \"otherValues\": [\"test3\", \"process-image-hash\", \"image\", \"10.10.1.37:$b3\", \"noconfig\"] }"`
  echo $msg | tee key
  inst_id=`python id.py <key`
  curl http://compute5:7777/updateSubjectSet -d "{ \"principal\": \"10.10.1.37:$b3\",  \"otherValues\": [\"$inst_id\"] }"
  curl http://compute5:7777/postAttesterImage -d "{ \"principal\": \"$IAAS_IP\",  \"otherValues\": [\"process-image-hash\"]}"
  curl http://compute5:7777/postImageProperty -d "{ \"principal\": \"$IAAS_IP\",  \"otherValues\": [\"process-image-hash\", \"https://github.com/jerryz920/mysql\"]}"

  k=$b3
    eval $(docker-machine env v1)
  	docker run -dt --rm --name mysql -p 1999:19999 -p 3307:3307 -p 3306:3306 -e ABAC_TEST_PORT=$k -e ABAC_TEST_IP=10.10.1.37  mysql test-long.sh 
    eval $(docker-machine env v2)
        docker run -it --rm mysql-runner run-long.sh >> results/out-long-$k &

	echo -e 'start ' >> results/out-long-start-$k
	./stamp >> results/out-long-start-$k
	sleep 5
	# curl http://compute5:7777/postInstancePoison -d "{ \"principal\": \"10.10.1.37:$b2\",  \"otherValues\": [\"test3\", \"10.10.1.37:$b3\"] }"
	echo 1 | nc 10.10.1.36 19999

  k=$b2
    eval $(docker-machine env v1)
  	docker run -dt --rm --name mysql -p 1999:19999 -p 3307:3307 -p 3306:3306 -e ABAC_TEST_PORT=$k -e ABAC_TEST_IP=10.10.1.37  mysql test-long.sh 
    eval $(docker-machine env v2)
        docker run -it --rm mysql-runner run-long.sh >> results/out-long-$k &

	echo -e 'start ' >> results/out-long-start-$k
	./stamp >> results/out-long-start-$k
	sleep 5
	# curl http://compute5:7777/postInstancePoison -d "{ \"principal\": \"10.10.1.37:$b1\",  \"otherValues\": [\"test2\", \"10.10.1.37:$b2\"] }"
	echo 1 | nc 10.10.1.36 19999

  k=$b1
    eval $(docker-machine env v1)
  	docker run -dt --rm --name mysql -p 1999:19999 -p 3307:3307 -p 3306:3306 -e ABAC_TEST_PORT=$k -e ABAC_TEST_IP=10.10.1.37  mysql test-long.sh 
    eval $(docker-machine env v2)
        docker run -it --rm mysql-runner run-long.sh >> results/out-long-$k &

	echo -e 'start ' >> results/out-long-start-$k
	./stamp >> results/out-long-start-$k
	# curl http://compute5:7777/postInstancePoison -d "{ \"principal\": \"$IAAS_IP\",  \"otherValues\": [\"test1\", \"10.10.1.37:$b1\"] }"
	echo 1 | nc 10.10.1.36 19999
	sleep 5
done


# base = 20002
# for i = 1 - 20;
# post 10.10.1.37 base - 2 + 3 * i, base - 1 + 3 * i, base + 3 * i with same git source
# for kill = 2000, 2001, 2002; do
#   boot mysql with 10.10.1.36 test port = kill, ip = 10.10.1.37, expose 1999->19999, long.sh
#   boot mysql-runner with /run-long.sh
#   timestamp
#   poison 2000
#

