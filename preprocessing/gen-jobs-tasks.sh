#!/bin/bash

TRACE=$1

awk 'BEGIN{FS=" "; print "job_id,job_submission_time,nr_of_tasks_in_job,average_task_duration"}{print NR-1","$1","$2","$3}' $TRACE > jobs.csv

awk 'BEGIN{FS=" "}{out=NR-1","$4; for(i=5;i<=NF;i++){out=out"\n"NR-1","$i}; print out}' $TRACE | awk 'BEGIN{print "task_id,job_id,runtime_of_task"}{print NR-1","$0}' > tasks.csv

