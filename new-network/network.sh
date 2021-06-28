#!/bin/bash

# txt color
C_RESET='\033[0m'
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_BLUE='\033[0;34m'
C_YELLOW='\033[1;33m'

# println echos string
function println() {
  echo -e "$1"
}

# errorln echos i red color
function errorln() {
  println "${C_RED}${1}${C_RESET}"
}

# successln echos in green color
function successln() {
  println "${C_GREEN}${1}${C_RESET}"
}

# infoln echos in blue color
function infoln() {
  println "${C_BLUE}${1}${C_RESET}"
}

# warnln echos in yellow color
function warnln() {
  println "${C_YELLOW}${1}${C_RESET}"
}

successln "환경변수 설정"
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=${PWD}/configtx

successln "인증서 초기화"
rm -Rf organizations/peerOrganizations && rm -Rf organizations/ordererOrganizations
println "도커 초기화"
docker rm -f $(docker ps -aq) 2>/dev/null || true
docker volume prune

successln "인증서 생성"
#configtxgen
cryptogen generate --config=./cryptogen/crypto-config.yaml --output="organizations"

successln "제네시스 블록 생성"
export FABRIC_CFG_PATH=${PWD}/configtx
echo $FABRIC_CFG_PATH
configtxgen -profile MyOrgsApplicationGenesis -outputBlock ./channel-artifacts/genesis.block -channelID "mysyschannel"

successln "체널 tx 생성"
#channel create
configtxgen -profile first -outputCreateChannelTx ./channel-artifacts/first.tx -channelID "first"
configtxgen -profile second -outputCreateChannelTx ./channel-artifacts/second.tx -channelID "second"
configtxgen -profile third -outputCreateChannelTx ./channel-artifacts/third.tx -channelID "third"


successln "도커 노드 생성"
#docker-compose < core.yaml/ orderer.yaml
COMPOSE_FILE_BASE=docker/docker-compose-test-net.yaml
#COMPOSE_FILE_COUCH=docker/docker-compose-couch.yaml
COMPOSE_FILES="-f ${COMPOSE_FILE_BASE}"
#COMPOSE_FILES="${COMPOSE_FILES} -f ${COMPOSE_FILE_COUCH}"
docker-compose ${COMPOSE_FILES} up -d 2>&1

successln "도커 노드 확인"
docker ps -a

#channel join

#chaincode package /install

#chaincode approve org / commit

#chaincode invoke / query
