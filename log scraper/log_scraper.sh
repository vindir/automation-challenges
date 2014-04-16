#!/bin/bash

ACCESS_LOG='puppet_access_ssl.log'
PROD_SSHD_PATH=/production/file_metadata/modules/ssh/sshd_config
DEV_REPORT_PATH=/dev/report

#Let's assume the reviewer will be running this from somewhere inside the challenge repository
BASE_PATH="$(git rev-parse --show-toplevel)"
CHALLENGE_PATH="${BASE_PATH}/log scraper"
cd "${BASE_PATH}"

LOG_DATA=`awk -F\" '{split($1,ipaddr," "); split($3,code," "); print ipaddr[1], code[1], $2}' "${CHALLENGE_PATH}/${ACCESS_LOG}"`

#Status Code Info
OK_COUNT=`echo "${LOG_DATA}" |awk '($2 ~ /200/){print $2}' | sort |uniq -c |xargs echo|cut -d\  -f1`
NON_OK_COUNT=`echo "${LOG_DATA}" |awk '($2 !~ /200/){print $2}' | sort |uniq -c |xargs echo|cut -d\  -f1`

#SSHD Config Info
SSHD_GETS=`echo "${LOG_DATA}" |awk -v matcher="^${PROD_SSHD_PATH}" '($3 ~ /GET/ && $4 ~ matcher){print}'`
SSHD_FETCH_COUNT=`echo "${SSHD_GETS}" |wc -l |xargs echo`
NON_200_SSHD_COUNT=`echo "${SSHD_GETS}" |awk '($2 !~ /200/){print}' | wc -l| xargs echo`

#Dev Report Info
DEV_REPORT_PUTS=`echo "${LOG_DATA}" |awk -v matcher="^${DEV_REPORT_PATH}" '($3 ~ /PUT/ && $4 ~ matcher){print}'`
DEV_REPORT_PUT_COUNT=`echo "${DEV_REPORT_PUTS}" |wc -l |xargs echo`
DEV_REPORT_PUT_BY_IP=`echo "${DEV_REPORT_PUTS}" |awk '{print $1,$2}' |sort |uniq -c |awk '{print "        "$1" - "$2}'`

printf "#"
printf '=%.0s' {1..40}
printf "\n"
printf "Apache ${ACCESS_LOG} Analysis\n"
printf "\n"
printf "Status Code Counts:\n"
printf "    OK(200): ${OK_COUNT}\n"
printf "    Non-OK: ${NON_OK_COUNT}\n"
printf "\n"
printf "Production sshd_config:\n"
printf "    Fetch Count: ${SSHD_FETCH_COUNT}\n"
printf "    Non-OK Status Count: ${NON_200_SSHD_COUNT}\n"
printf "\n"
printf "dev/report Requests:\n"
printf "    PUT Requests: ${DEV_REPORT_PUT_COUNT}\n"
printf "    PUT Requests by IP:\n"
printf "${DEV_REPORT_PUT_BY_IP}\n"
printf "#"
printf '=%.0s' {1..40}
printf "\n"

