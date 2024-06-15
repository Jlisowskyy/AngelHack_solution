#!/bin/bash

USERS="./hack_files/users"
SRC="./hack_files/src"
LOG_FILE="log.txt"
CONSUMER="${USERS}/it_consumer"
CREATOR="${USERS}/it_creator"

# create simple course example 0.0001 AVX cost
forge create --rpc-url fuji-c --keystore $CREATOR "${SRC}/course_token.sol:CourseContract" --constructor-args 12345 '["https://www.youtube.com/watch?v=3ZEoAq4JdxU", "https://www.youtube.com/watch?v=3ZEoAq4JdxU", "https://www.youtube.com/watch?v=3ZEoAq4JdxU"]' 100000000000000 2>&1 | tee -a $LOG_FILE

# create user contract
forge create --rpc-url fuji-c --keystore $CONSUMER "${SRC}/user_contract.sol:UserContract" --constructor-args "Chess-Enjoyer" "https://icons.iconarchive.com/icons/microsoft/fluentui-emoji-mono/256/Chess-Pawn-icon.png" 2>&1 | tee -a $LOG_FILE
