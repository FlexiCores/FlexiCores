import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import csv


def load_data(path):
    arr = [[None for _ in range(16)] for _ in range(16)]
    with open(path, newline='') as csvfile:
        reader = csv.reader(csvfile, delimiter=',')
        next(reader)  # ignore header
        for row in reader:
            in1 = int(row[0])
            in2 = int(row[1])
            val = int(row[2])
            arr[in1][in2] = val

    return np.array(arr)


if __name__ == '__main__':
    arr = load_data('results.csv')
    f, ax = plt.subplots(figsize=(9, 6))
    sns.heatmap(arr, annot=True, fmt="d", linewidth=0.5, ax=ax)
    plt.show()
