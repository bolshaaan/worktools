#!/bin/bash

SCRUM=$1
CMD=$2

WHAT=$3

if [ -z "${WHAT}" ]; then
	WHAT=sh;
fi

echo "SCRUM: $SCRUM; CMD: $CMD; WHAT: $WHAT"

if [ $# -le 1 ]; then
	echo "use following:  kctl.sh scrumN (logs|ca|ru)";
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
elif [ $CMD = "ru" ]; then
	KPOD=`kubectl --namespace ${SCRUM} get pod | perl -ne ' print $1 if /(ru-\d+\w+-\w+)/; '`
	printf '\033[31m%s\033[0m\n\n\n'  "<=== Making SSH to $KPOD ===>"
	kubectl --namespace $SCRUM exec -it $KPOD -c ru sh
else


	KPOD=`kubectl --namespace ${SCRUM} get pod | CMD=$CMD perl -ne ' print $1 if /($ENV{CMD}-\d+\w+-\w+)/; '`
	printf '\033[31m%s\033[0m\n\n\n'  "<=== Making SSH to $KPOD $CMD ===>"

	if [ $WHAT = logs ]; then
		kubectl --namespace $SCRUM logs  $KPOD  $CMD -f
	else
		kubectl --namespace $SCRUM exec -it $KPOD -c $CMD $WHAT
	fi

fi

# elif [ $CMD = "publicapi" ]; then

