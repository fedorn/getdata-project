All code is in one file "run_analysis.R".

First, it creates "data" folder for input and output data if it not exists yet. Then, it downloads Samsung data and unzip it.

Then data is readed and the following steps are performed on it:

1. Merging train and test sets.
2. Extracting only mean and standard deviation features (we look for "mean()" and "std()" in variables names).
3. Adding activity labels to dataset, based on "activity_labels.txt" files from original data.
4. Calculating averages for each feature we select in step 2.

Then we output tidy data from step 4. to file "data/averages.csv".