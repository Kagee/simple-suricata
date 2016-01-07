#! /bin/bash

sudo docker run -i --rm=true -v ${PWD}/rules:/etc/rules -v ${PWD}/test:/etc/test -v ${PWD}/etc:/etc/sur -v ${PWD}/log:/var/log/suricata my_sur bash -c "suricata -k none -r /etc/$1 -c /etc/sur/suricata.yaml"
