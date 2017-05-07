 docker run --rm -i -t -p 3307:3307 -p 13306:3306 -e MYSQL_ROOT_PASSWORD=root@sonar -e MYSQL_DATABASE=wikidb -e MYSQL_USER=wikiuser -e MYSQL_PASSWORD=wikipass mysql docker-entrypoint.sh mysqld

