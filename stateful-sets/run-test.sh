kubectl run utilities --image datianshi/utilities -ti --rm -- /bin/bash


kubectl run mysql-client --image=mysql:5.7 -i --rm --restart=Never --\
  mysql -h mysql-0.mysql.music.svc.cluster.local <<EOF
CREATE DATABASE test;
CREATE TABLE test.messages (message VARCHAR(250));
INSERT INTO test.messages VALUES ('hello');
EOF

kubectl run mysql-client --image=mysql:5.7 -i -t --rm --restart=Never --\
  mysql -h mysql-read.music.svc.cluster.local -e "SELECT * FROM test.messages"

  kubectl run mysql-client --image=mysql:5.7 -i -t --rm --restart=Never --\
    mysql -h mysql-2.mysql.music.svc.cluster.local -e "SELECT * FROM test.messages"  
