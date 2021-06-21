#!/usr/bin/env python3

import sys
import csv
import heapq as hq

# Import tasks from CSV
with open(sys.argv[1]) as file:
  reader = csv.reader(file, quoting=csv.QUOTE_NONNUMERIC)
  tasks = list(reader)

# Delete the field names from the list: "job_submission_time","runtime_of_task"
if type(tasks[0][0]) == str:
  del tasks[0]

for i in range(len(tasks)):
  tasks[i][0] *= 10

# Convert to min-heap
hq.heapify(tasks)

# Create a priority queue of running tasks
runningtasks = []
hq.heapify(runningtasks)

# Simulate running tasks as they are submitted and create a list of number of active tasks at a particular time
# workload = [[],[]]
workload = []
numTasks = 0
time = 0.0
# workload[0].append(time)
# workload[1].append(numTasks)
workload.append([time, numTasks])
while tasks or runningtasks:
  if tasks:
    minTaskStartTime = tasks[0][0]
    if runningtasks:
      minRunTaskEndTime = runningtasks[0]
      if minTaskStartTime < minRunTaskEndTime:
        time = minTaskStartTime
        while tasks and (tasks[0][0] == time):
          hq.heappush(runningtasks, tasks[0][0]+tasks[0][1])
          hq.heappop(tasks)
          numTasks += 1
      else:
        time = minRunTaskEndTime
        hq.heappop(runningtasks)
        numTasks -= 1
    else:
      time = minTaskStartTime
      while tasks and (tasks[0][0] == time):
        hq.heappush(runningtasks, tasks[0][0]+tasks[0][1])
        hq.heappop(tasks)
        numTasks += 1
  else:
    time = minRunTaskEndTime
    hq.heappop(runningtasks)
    numTasks -= 1
  # workload[0].append(time)
  # workload[1].append(numTasks)
  workload.append([time, numTasks])

# Write a CSV file called workload.csv with the fields: "time","nr_active_tasks"
with open(sys.argv[2] + 'workload.csv', 'w', newline='') as file:
  writer = csv.writer(file, delimiter=',', quoting=csv.QUOTE_NONNUMERIC)
  writer.writerow(['time', 'nr_active_tasks'])
  writer.writerows(workload)
