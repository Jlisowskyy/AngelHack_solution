#!/bin/bash

USERS="./hack_files/users"
LOG_FILE="log.txt"
CONSUMER="${USERS}/it_consumer"
USER_CONTRACT="0xA6490f20c67390DA5c25Eec82A033E8874994D64"
OWNER_CONTRACT="0xC46C17e8c6358a0cb1E45874B08D6EFf81cdD533"

# check for contact count
cast send --rpc-url fuji-c --keystore $CONSUMER $USER_CONTRACT "getContractCount" 2>&1 | tee -a $LOG_FILE

# buy new access
cast send --rpc-url fuji-c --keystore $CONSUMER $USER_CONTRACT "buyAccessKeyFromCourseContract(address)" $OWNER_CONTRACT 2>&1 | tee -a $LOG_FILE

# check for contact count
cast send --rpc-url fuji-c --keystore $CONSUMER $USER_CONTRACT "getContractCount" 2>&1 | tee -a $LOG_FILE

# get video links
cast send --rpc-url fuji-c --keystore $CONSUMER $USER_CONTRACT "getVideoLinksFromCourseContract(address)" $OWNER_CONTRACT 2>&1 | tee -a $LOG_FILE
