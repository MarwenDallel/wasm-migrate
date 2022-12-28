import subprocess
import csv
import sys
import os
from pathlib import Path

def run_time_bench():
    # Use /usr/bin/time to collect metrics
    # Explain each of %e %K %M %P
    # %e real (elapsed) time in seconds
    # %K average memory usage, in kilobytes
    # %M maximum resident set size, in kilobytes
    # %P percentage of CPU that this job got
    time_command = '/usr/bin/time -f "%e %K %M %P" ' + command
    time_output = subprocess.check_output(time_command, stderr=subprocess.STDOUT, shell=True)
    # Expect the first line to be the command output
    # Expect the second line to be the metrics (collected individually)
    time_output_list = time_output.decode("utf-8").splitlines()
    command_output = time_output_list[0]
    real_time, average_memory_usage, maximum_memory_usage, cpu_usage = time_output_list[1].split(" ")
    time_metrics = [real_time, average_memory_usage, maximum_memory_usage, cpu_usage]
    return time_metrics

def run_perf_bench():
    # Collect cpu usage with perf
    perf_command = 'perf stat ' + command
    perf_output = subprocess.check_output(perf_command, stderr=subprocess.STDOUT, shell=True)
    perf_output_list = perf_output.decode("utf-8").splitlines()
    task_clock = [line for line in perf_output_list if "task-clock" in line][0].strip().split(" ")[0].replace("\"", "")
    perf_metrics = [task_clock]
    return perf_metrics

def run_bench():
    # Create csv file
    csvfile = open(output_file, 'w', newline='');
    writer = csv.writer(csvfile, delimiter=',')
    writer.writerow(headers)

    metrics = []
    time_metrics = []
    perf_metrics = []

    for i in range(runs):
        print("[time] Run {}/{}".format(i+1, runs), end="\r")
        # Run time metrics
        time_metrics.append(run_time_bench())
    print(" "*80, end="\r")
    print("[time] finished!")

    for i in range(runs):
        print("[perf] Run {}/{}".format(i+1, runs), end="\r")
        # Run perf metrics
        perf_metrics.append(run_perf_bench())
    print(" "*80, end="\r")
    print("[perf] finished!")


    # Get one item from time metrics, perf metrics
    # time_metrics = [[1,2,3,4], [5,6,7,8]]
    # perf_metrics = [[1], [2]]
    # metrics = [[1,2,3,4,1,1], [5,6,7,8,2,2]]
    for i in range(runs):
        metrics.append([runtime, program_name, command] + time_metrics[i] + perf_metrics[i])

    print("Writing to file...")
    for metrics_list in metrics:
        writer.writerow(metrics_list)

    csvfile.close()

runs = int(sys.argv[1])
runtime = sys.argv[2]
command = " ".join(sys.argv[2:])
program_args = " ".join(sys.argv[3:])
program_path = [word for word in sys.argv[3:] if word.endswith(".wasm")][0]
program_name = Path(program_path).stem

output_file = f"benchmark/{program_name}_{os.sys.platform}_benchmark.csv"

# CSV Headers
info_header = ["Runtime", "Program", "Command"]
time_header = ["Real Time (seconds)", "Average Memory Usage (KB)", "Maximum Memory Usage RSS (KB)", "CPU Usage (%)"]
perf_header = ["Task-clock (milliseconds)"]
headers = info_header + time_header + perf_header

if __name__ == "__main__":
    print("Runtime:", runtime)
    print("Program name:", program_name)
    print("Arguments:", program_args)
    print("Output file:", output_file)

    run_bench()