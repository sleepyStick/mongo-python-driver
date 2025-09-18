from __future__ import annotations

import csv
import pprint
import re
from collections import defaultdict


def testing_n_threads(f_in, data):
    threads = re.match(r"Testing (?P<n_threads>.*) threads", f_in.readline()).group("n_threads")
    seconds = re.match(
        r"All threads completed after (?P<n_seconds>.*) seconds", f_in.readline()
    ).group("n_seconds")
    tries = re.match(r"Total number of retry attempts: (?P<n_tries>.*)", f_in.readline()).group(
        "n_tries"
    )
    data[f"{threads}_sec"].append(float(seconds))
    data[f"{threads}_try"].append(int(tries))
    return data


def read_table(f_in, data):
    # Initialize the CSV reader with the pipe '|' as the delimiter
    reader = csv.reader(f_in, delimiter="|")
    next(reader)  # skip header

    for row in reader:
        if "threads " in row:
            continue
        row = [col.strip() for col in row]  # noqa:PLW2901
        # Convert numbers to appropriate types (int for threads, float for statistics)
        threads = int(row[0])
        avg, p50, p90, p99, p100 = map(float, row[1:])
        # Append the parsed row to the list
        data[f"{threads}_avg"].append(avg)
        data[f"{threads}_p50"].append(p50)
        data[f"{threads}_p90"].append(p90)
        data[f"{threads}_p99"].append(p99)
        data[f"{threads}_p100"].append(p100)
    return data


def summarize(data):
    summary = {}
    for k, v in data.items():
        summary[k] = (min(v), sum(v) / len(v), max(v))
    return summary


path = "/Users/iris.ho/Github/backpressure/runs64/"
backoff_max = ["75", "1", "1.5"]
initial = ["5", "25", "50"]
print_data = {}
pp = pprint.PrettyPrinter(width=80)
THREADS = [1, 2, 4, 8, 16, 32, 64, 128, 256, 512]
for m in backoff_max:
    for n in initial:
        data = defaultdict(list)
        with open(f"{path}{m}/{n}/summary.txt", "w") as f_out:
            for i in range(1, 101):
                with open(f"{path}{m}/{n}/{i}.txt") as f_in:
                    for _ in range(len(THREADS)):
                        data = testing_n_threads(f_in, data)
                        f_in.readline()
                    data = read_table(f_in, data)
            avgs = summarize(data)
            print_data[(f"{m}s", f"{n}ms")] = {
                "avg": [avgs[f"{thread}_avg"] for thread in THREADS],
                "p50": [avgs[f"{thread}_p50"] for thread in THREADS],
                "p90": [avgs[f"{thread}_p90"] for thread in THREADS],
                "p99": [avgs[f"{thread}_p99"] for thread in THREADS],
                "p100": [avgs[f"{thread}_p100"] for thread in THREADS],
            }
            for thread in THREADS:
                f_out.write(f"{thread} threads:\n")
                f_out.write(
                    f"All threads completed after {avgs[f'{thread}_sec']} seconds on average\n"
                )
                f_out.write(f"Total number of retry attempts on average {avgs[f'{thread}_try']}\n")
                f_out.write("\n")
            f_out.write("threads |  avg  |  p50  |  p90  |  p99  |  p100\n")
            for thread in THREADS:
                f_out.write(
                    f"{thread:7} | {avgs[f'{thread}_avg']} | {avgs[f'{thread}_p50']} | {avgs[f'{thread}_p90']} | {avgs[f'{thread}_p99']} | {avgs[f'{thread}_p100']}\n"
                )
# pp.pprint(print_data)

baseline = {}
with open(f"{path}main.txt") as f:
    data = defaultdict(list)
    for _ in range(len(THREADS)):
        data = testing_n_threads(f, data)
        f.readline()
    data = read_table(f, data)
    avgs = summarize(data)
    print_data = {
        "avg": [avgs[f"{thread}_avg"] for thread in THREADS],
        "p50": [avgs[f"{thread}_p50"] for thread in THREADS],
        "p90": [avgs[f"{thread}_p90"] for thread in THREADS],
        "p99": [avgs[f"{thread}_p99"] for thread in THREADS],
        "p100": [avgs[f"{thread}_p100"] for thread in THREADS],
    }
pp.pprint(print_data)
