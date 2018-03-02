#!/bin/bash

SCRUM=$1
CMD=$2

echo "SCRUM: $SCRUM; CMD: $CMD"

if [ -z "$2" ]; then
	echo "use fullowing:  kctl.sh scrumN (logs|ca|ru)";
	exit 0;
fi


if [ $CMD = "logs" ]; then
	KPOD=`kubectl --namespace ${SCRUM} get pod | perl -ne ' print $1 if /(employee-restrictions-\d+\w+-\w+)/; '`
	printf '\033[31m%s\033[0m\n\n\n\n'  "<=== Making logs from $KPOD ===>"
	kubectl --namespace $SCRUM logs  $KPOD  employee-restrictions -f
elif [ $CMD = "ca" ]; then
	KPOD=`kubectl --namespace ${SCRUM} get pod | perl -ne ' print $1 if /(class-availability-\d+\w+-\w+)/; '`
	printf '\033[31m%s\033[0m\n\n\n'  "<=== Making SSH to $KPOD ===>"
	kubectl --namespace $SCRUM exec -it $KPOD -c class-availability sh
else [ $CMD = "ru" ]
	KPOD=`kubectl --namespace ${SCRUM} get pod | perl -ne ' print $1 if /(ru-\d+\w+-\w+)/; '`
	printf '\033[31m%s\033[0m\n\n\n'  "<=== Making SSH to $KPOD ===>"
	kubectl --namespace $SCRUM exec -it $KPOD -c ru sh
fi


