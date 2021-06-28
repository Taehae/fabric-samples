#!/bin/bash

function createGroup1() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/group1.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/group1.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-group1 --tls.certfiles "${PWD}/organizations/fabric-ca/group1/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-group1.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-group1.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-group1.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-group1.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/group1.example.com/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-group1 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/group1/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-group1 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/group1/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the group1 admin"
  set -x
  fabric-ca-client register --caname ca-group1 --id.name group1admin --id.secret group1adminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/group1/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-group1 -M "${PWD}/organizations/peerOrganizations/group1.example.com/peers/peer0.group1.example.com/msp" --csr.hosts peer0.group1.example.com --tls.certfiles "${PWD}/organizations/fabric-ca/group1/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/group1.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/group1.example.com/peers/peer0.group1.example.com/msp/config.yaml"


  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-group1 -M "${PWD}/organizations/peerOrganizations/group1.example.com/peers/peer0.group1.example.com/tls" --enrollment.profile tls --csr.hosts peer0.group1.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/group1/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/group1.example.com/peers/peer0.group1.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/group1.example.com/peers/peer0.group1.example.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/group1.example.com/peers/peer0.group1.example.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/group1.example.com/peers/peer0.group1.example.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/group1.example.com/peers/peer0.group1.example.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/group1.example.com/peers/peer0.group1.example.com/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/group1.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/group1.example.com/peers/peer0.group1.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/group1.example.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/group1.example.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/group1.example.com/peers/peer0.group1.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/group1.example.com/tlsca/tlsca.group1.example.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/group1.example.com/ca"
  cp "${PWD}/organizations/peerOrganizations/group1.example.com/peers/peer0.group1.example.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/group1.example.com/ca/ca.group1.example.com-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-group1 -M "${PWD}/organizations/peerOrganizations/group1.example.com/users/User1@group1.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/group1/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/group1.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/group1.example.com/users/User1@group1.example.com/msp/config.yaml"

  infoln "Generating the group1 admin msp"
  set -x
  fabric-ca-client enroll -u https://group1admin:group1adminpw@localhost:7054 --caname ca-group1 -M "${PWD}/organizations/peerOrganizations/group1.example.com/users/Admin@group1.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/group1/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/group1.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/group1.example.com/users/Admin@group1.example.com/msp/config.yaml"
}

function createGroup2() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/group2.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/group2.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-group2 --tls.certfiles "${PWD}/organizations/fabric-ca/group2/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-group2.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-group2.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-group2.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-group2.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/group2.example.com/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-group2 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/group2/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-group2 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/group2/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the group2 admin"
  set -x
  fabric-ca-client register --caname ca-group2 --id.name group2admin --id.secret group2adminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/group2/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-group2 -M "${PWD}/organizations/peerOrganizations/group2.example.com/peers/peer0.group2.example.com/msp" --csr.hosts peer0.group2.example.com --tls.certfiles "${PWD}/organizations/fabric-ca/group2/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/group2.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/group2.example.com/peers/peer0.group2.example.com/msp/config.yaml"


  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-group2 -M "${PWD}/organizations/peerOrganizations/group2.example.com/peers/peer0.group2.example.com/tls" --enrollment.profile tls --csr.hosts peer0.group2.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/group2/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/group2.example.com/peers/peer0.group2.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/group2.example.com/peers/peer0.group2.example.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/group2.example.com/peers/peer0.group2.example.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/group2.example.com/peers/peer0.group2.example.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/group2.example.com/peers/peer0.group2.example.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/group2.example.com/peers/peer0.group2.example.com/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/group2.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/group2.example.com/peers/peer0.group2.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/group2.example.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/group2.example.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/group2.example.com/peers/peer0.group2.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/group2.example.com/tlsca/tlsca.group2.example.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/group2.example.com/ca"
  cp "${PWD}/organizations/peerOrganizations/group2.example.com/peers/peer0.group2.example.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/group2.example.com/ca/ca.group2.example.com-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-group2 -M "${PWD}/organizations/peerOrganizations/group2.example.com/users/User1@group2.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/group2/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/group2.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/group2.example.com/users/User1@group2.example.com/msp/config.yaml"

  infoln "Generating the group2 admin msp"
  set -x
  fabric-ca-client enroll -u https://group2admin:group2adminpw@localhost:8054 --caname ca-group2 -M "${PWD}/organizations/peerOrganizations/group2.example.com/users/Admin@group2.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/group2/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/group2.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/group2.example.com/users/Admin@group2.example.com/msp/config.yaml"
}

function createGroup3() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/group3.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/group3.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:6054 --caname ca-group3 --tls.certfiles "${PWD}/organizations/fabric-ca/group3/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-6054-ca-group3.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-6054-ca-group3.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-6054-ca-group3.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-6054-ca-group3.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/group3.example.com/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-group3 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/group3/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-group3 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/group3/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the group3 admin"
  set -x
  fabric-ca-client register --caname ca-group3 --id.name group3admin --id.secret group3adminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/group3/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:6054 --caname ca-group3 -M "${PWD}/organizations/peerOrganizations/group3.example.com/peers/peer0.group3.example.com/msp" --csr.hosts peer0.group3.example.com --tls.certfiles "${PWD}/organizations/fabric-ca/group3/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/group3.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/group3.example.com/peers/peer0.group3.example.com/msp/config.yaml"


  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:6054 --caname ca-group3 -M "${PWD}/organizations/peerOrganizations/group3.example.com/peers/peer0.group3.example.com/tls" --enrollment.profile tls --csr.hosts peer0.group3.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/group3/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/group3.example.com/peers/peer0.group3.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/group3.example.com/peers/peer0.group3.example.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/group3.example.com/peers/peer0.group3.example.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/group3.example.com/peers/peer0.group3.example.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/group3.example.com/peers/peer0.group3.example.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/group3.example.com/peers/peer0.group3.example.com/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/group3.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/group3.example.com/peers/peer0.group3.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/group3.example.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/group3.example.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/group3.example.com/peers/peer0.group3.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/group3.example.com/tlsca/tlsca.group3.example.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/group3.example.com/ca"
  cp "${PWD}/organizations/peerOrganizations/group3.example.com/peers/peer0.group3.example.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/group3.example.com/ca/ca.group3.example.com-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:6054 --caname ca-group3 -M "${PWD}/organizations/peerOrganizations/group3.example.com/users/User1@group3.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/group3/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/group3.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/group3.example.com/users/User1@group3.example.com/msp/config.yaml"

  infoln "Generating the group3 admin msp"
  set -x
  fabric-ca-client enroll -u https://group3admin:group3adminpw@localhost:6054 --caname ca-group3 -M "${PWD}/organizations/peerOrganizations/group3.example.com/users/Admin@group3.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/group3/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/group3.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/group3.example.com/users/Admin@group3.example.com/msp/config.yaml"
}

function createOrderer1(){ 
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/example.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/example.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer1 --tls.certfiles "${PWD}/organizations/fabric-ca/orderer1/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer1.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer1.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer1.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer1.pem
    OrganizationalUnitIdentifier: orderer1' > "${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml"

  infoln "Registering orderer1"
  set -x
  fabric-ca-client register --caname ca-orderer1 --id.name orderer1 --id.secret orderer1pw --id.type orderer --tls.certfiles "${PWD}/organizations/fabric-ca/orderer1/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the orderer1 admin"
  set -x
  fabric-ca-client register --caname ca-orderer1 --id.name orderer1Admin --id.secret orderer1Adminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/orderer1/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer1:orderer1pw@localhost:9054 --caname ca-orderer1 -M "${PWD}/organizations/ordererOrganizations/example.com/orderer1/orderer1.example.com/msp" --csr.hosts orderer1.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/orderer1/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/example.com/orderer1/orderer1.example.com/msp/config.yaml"

  infoln "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer1:orderer1pw@localhost:9054 --caname ca-orderer1 -M "${PWD}/organizations/ordererOrganizations/example.com/orderer1/orderer1.example.com/tls" --enrollment.profile tls --csr.hosts orderer1.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/orderer1/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/example.com/orderer1/orderer1.example.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/example.com/orderer1/orderer1.example.com/tls/ca.crt"
  cp "${PWD}/organizations/ordererOrganizations/example.com/orderer1/orderer1.example.com/tls/signcerts/"* "${PWD}/organizations/ordererOrganizations/example.com/orderer1/orderer1.example.com/tls/server.crt"
  cp "${PWD}/organizations/ordererOrganizations/example.com/orderer1/orderer1.example.com/tls/keystore/"* "${PWD}/organizations/ordererOrganizations/example.com/orderer1/orderer1.example.com/tls/server.key"

  mkdir -p "${PWD}/organizations/ordererOrganizations/example.com/orderer1/orderer1.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/example.com/orderer1/orderer1.example.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/example.com/orderer1/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"

  mkdir -p "${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/example.com/orderer1/orderer1.example.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem"

  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://orderer1Admin:orderer1Adminpw@localhost:9054 --caname ca-orderer1 -M "${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/orderer1/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml"
}
function createOrderer2(){ 
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/example.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/example.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:10054 --caname ca-orderer2 --tls.certfiles "${PWD}/organizations/fabric-ca/orderer2/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-orderer2.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-orderer2.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-orderer2.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-orderer2.pem
    OrganizationalUnitIdentifier: orderer2' > "${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml"

  infoln "Registering orderer2"
  set -x
  fabric-ca-client register --caname ca-orderer2 --id.name orderer2 --id.secret orderer2pw --id.type orderer --tls.certfiles "${PWD}/organizations/fabric-ca/orderer2/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the orderer2 admin"
  set -x
  fabric-ca-client register --caname ca-orderer2 --id.name orderer2Admin --id.secret orderer2Adminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/orderer2/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer2:orderer2pw@localhost:10054 --caname ca-orderer2 -M "${PWD}/organizations/ordererOrganizations/example.com/orderer2/orderer2.example.com/msp" --csr.hosts orderer2.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/orderer2/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/example.com/orderer2/orderer2.example.com/msp/config.yaml"

  infoln "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer2:orderer2pw@localhost:10054 --caname ca-orderer2 -M "${PWD}/organizations/ordererOrganizations/example.com/orderer2/orderer2.example.com/tls" --enrollment.profile tls --csr.hosts orderer2.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/orderer2/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/example.com/orderer2/orderer2.example.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/example.com/orderer2/orderer2.example.com/tls/ca.crt"
  cp "${PWD}/organizations/ordererOrganizations/example.com/orderer2/orderer2.example.com/tls/signcerts/"* "${PWD}/organizations/ordererOrganizations/example.com/orderer2/orderer2.example.com/tls/server.crt"
  cp "${PWD}/organizations/ordererOrganizations/example.com/orderer2/orderer2.example.com/tls/keystore/"* "${PWD}/organizations/ordererOrganizations/example.com/orderer2/orderer2.example.com/tls/server.key"

  mkdir -p "${PWD}/organizations/ordererOrganizations/example.com/orderer2/orderer2.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/example.com/orderer2/orderer2.example.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/example.com/orderer2/orderer2.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"

  mkdir -p "${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/example.com/orderer2/orderer2.example.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem"

  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://orderer2Admin:orderer2Adminpw@localhost:10054 --caname ca-orderer2 -M "${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/orderer2/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml"
}
function createOrderer3(){ 
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/example.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/example.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:10054 --caname ca-orderer3 --tls.certfiles "${PWD}/organizations/fabric-ca/orderer3/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-orderer3.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-orderer3.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-orderer3.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-orderer3.pem
    OrganizationalUnitIdentifier: orderer3' > "${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml"

  infoln "Registering orderer3"
  set -x
  fabric-ca-client register --caname ca-orderer3 --id.name orderer3 --id.secret orderer3pw --id.type orderer --tls.certfiles "${PWD}/organizations/fabric-ca/orderer3/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the orderer3 admin"
  set -x
  fabric-ca-client register --caname ca-orderer3 --id.name orderer3Admin --id.secret orderer3Adminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/orderer3/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer3:orderer3pw@localhost:10054 --caname ca-orderer3 -M "${PWD}/organizations/ordererOrganizations/example.com/orderer3/orderer3.example.com/msp" --csr.hosts orderer3.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/orderer3/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/example.com/orderer3/orderer3.example.com/msp/config.yaml"

  infoln "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer3:orderer3pw@localhost:10054 --caname ca-orderer3 -M "${PWD}/organizations/ordererOrganizations/example.com/orderer3/orderer3.example.com/tls" --enrollment.profile tls --csr.hosts orderer3.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/orderer3/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/example.com/orderer3/orderer3.example.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/example.com/orderer3/orderer3.example.com/tls/ca.crt"
  cp "${PWD}/organizations/ordererOrganizations/example.com/orderer3/orderer3.example.com/tls/signcerts/"* "${PWD}/organizations/ordererOrganizations/example.com/orderer3/orderer3.example.com/tls/server.crt"
  cp "${PWD}/organizations/ordererOrganizations/example.com/orderer3/orderer3.example.com/tls/keystore/"* "${PWD}/organizations/ordererOrganizations/example.com/orderer3/orderer3.example.com/tls/server.key"

  mkdir -p "${PWD}/organizations/ordererOrganizations/example.com/orderer3/orderer3.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/example.com/orderer3/orderer3.example.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/example.com/orderer3/orderer3.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"

  mkdir -p "${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/example.com/orderer3/orderer3.example.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem"

  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://orderer3Admin:orderer3Adminpw@localhost:10054 --caname ca-orderer3 -M "${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/orderer3/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml"
}
