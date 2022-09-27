#!/bin/bash
go get -u github.com/jvehent/pineapple
$GOPATH/bin/pineapple <<EOF
aws:
    region: us-east-1
    accountnumber: 991528416474

components:
    - name: load-balancer
      type: elb
      tag:
          key: elasticbeanstalk:environment-name
          value: invoicer-api
    
    - name: application
      type: ec2
      tag:
          key: elasticbeanstalk:environment-name
          value: invoicer-api

    - name: database
      type: rds
      tag:
          key: environment-name
          value: invoicer-api

rules:
    - src: 0.0.0.0/0
      dst: load-balancer
      dport: 443

    - src: load-balancer
      dst: application
      dport: 80

    - src: application
      dst: database
      dport: 5432
EOF