#!/bin/bash
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=${PWD}/configtx
export VERBOSE=false

. scripts/utils.sh

#초기화
rm -Rf organizations/peerOrganizations && rm -Rf organizations/ordererOrganizations
rm -Rf organizations/fabric-ca/group* && rm -Rf organizations/fabric-ca/order*

#cryptogen 을 이용하여 인증서 생성
cryptogen generate --config=./organizations/cryptogen/crypto-config-group1.yaml --output="organizations"
cryptogen generate --config=./organizations/cryptogen/crypto-config-group2.yaml --output="organizations"
cryptogen generate --config=./organizations/cryptogen/crypto-config-group3.yaml --output="organizations"
cryptogen generate --config=./organizations/cryptogen/crypto-config-orderer1.yaml --output="organizations"
cryptogen generate --config=./organizations/cryptogen/crypto-config-orderer2.yaml --output="organizations"
cryptogen generate --config=./organizations/cryptogen/crypto-config-orderer3.yaml --output="organizations"


#Fabric CA 컨테이너 삭제
infoln "컨테이너를 삭제합니다."
docker rm -f $(docker ps -q) 2>/dev/null || true

#Fabric CA를 이용하여 인증서 생성
infoln "컨테이너를 생성합니다."
COMPOSE_FILE_CA=docker/docker-compose-ca.yaml
docker-compose -f $COMPOSE_FILE_CA up -d 2>&1

. organizations/fabric-ca/registerEnroll.sh

infoln "Creating group1 Identities"
while :
  do
    if [ ! -f "organizations/fabric-ca/group1/tls-cert.pem" ]; then
      sleep 1
    else
      break
    fi
  done

createGroup1


infoln "Creating group2 Identities"
while :
  do
    if [ ! -f "organizations/fabric-ca/group2/tls-cert.pem" ]; then
      sleep 1
    else
      break
    fi
  done

createGroup2

infoln "Creating group3 Identities"
while :
  do
    if [ ! -f "organizations/fabric-ca/group3/tls-cert.pem" ]; then
      sleep 1
    else
      break
    fi
  done

createGroup3


infoln "Creating Orderer1 Org Identities"
createOrderer1
infoln "Creating Orderer2 Org Identities"
createOrderer2
infoln "Creating Orderer3 Org Identities"
createOrderer3







