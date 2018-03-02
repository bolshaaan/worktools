#!/bin/bash


echo "PARAM: $1"

if [ $1 = "logs" ]; then
	KPOD=`kubectl --namespace scrum50 get pod | perl -ne ' print $1 if /(employee-restrictions-\d+\w+-\w+)/; '`
	printf '\033[31m%s\033[0m\n\n\n\n'  "<=== Making logs from $KPOD ===>"
	kubectl --namespace scrum50 logs  $KPOD  employee-restrictions -f
elif [ $1 = "ca" ]; then
	KPOD=`kubectl --namespace scrum50 get pod | perl -ne ' print $1 if /(class-availability-\d+\w+-\w+)/; '`
	printf '\033[31m%s\033[0m\n\n\n'  "<=== Making SSH to $KPOD ===>"
	kubectl --namespace scrum50 exec -it $KPOD -c class-availability sh
else
	KPOD=`kubectl --namespace scrum50 get pod | perl -ne ' print $1 if /(ru-\d+\w+-\w+)/; '`
	printf '\033[31m%s\033[0m\n\n\n'  "<=== Making SSH to $KPOD ===>"
	kubectl --namespace scrum50 exec -it $KPOD -c ru sh
fi

