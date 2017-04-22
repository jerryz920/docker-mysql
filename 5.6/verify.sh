
b1=$1
b2=$((b1-1))
b3=$((b2-1))
curl http://compute5:7777/appAccessesObject -d "{ \"principal\": \"152.3.145.138:4144\",  \"otherValues\": [\"1.1.1.1:$b1\", \"alice:object1\"]}"
curl http://compute5:7777/appAccessesObject -d "{ \"principal\": \"152.3.145.138:4144\",  \"otherValues\": [\"1.1.1.1:$b2\", \"alice:object1\"]}"
curl http://compute5:7777/appAccessesObject -d "{ \"principal\": \"152.3.145.138:4144\",  \"otherValues\": [\"1.1.1.1:$b3\", \"alice:object1\"]}"

