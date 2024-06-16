#!/bin/bash

USERS="./hack_files/users"
LOG_FILE="log.txt"
CONSUMER="${USERS}/it_consumer"
USER_CONTRACT="0x36f3CBB321eD03Acb649651158FF244b4b6D25b4"
OWNER_CONTRACT="0xC46C17e8c6358a0cb1E45874B08D6EFf81cdD533"

# check for contact count
cast call --rpc-url fuji-c --keystore $CONSUMER $USER_CONTRACT "getContractCount()(uint256)" 2>&1 | tee -a $LOG_FILE

# buy new access
cast call --value 100000000000000 --rpc-url fuji-c --keystore $CONSUMER $USER_CONTRACT "buyAccessKeyFromCourseContract(address)" $OWNER_CONTRACT 2>&1 | tee -a $LOG_FILE

# check for contact count
cast call --rpc-url fuji-c --keystore $CONSUMER $USER_CONTRACT "getContractCount()(uint256)" 2>&1 | tee -a $LOG_FILE

# get video links
cast call --rpc-url fuji-c --keystore $CONSUMER $USER_CONTRACT "getVideoLinksFromCourseContract(address)(string[] memory)" $OWNER_CONTRACT 2>&1 | tee -a $LOG_FILE
