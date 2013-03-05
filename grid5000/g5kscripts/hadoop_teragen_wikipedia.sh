#!/bin/bash

MAPS="1000"
REDUCES="500"
TIME_COMMAND="/usr/bin/time -p"
HADOOP_HOME="/opt/hadoop"
HADOOP_BIN="$TIME_COMMAND env JAVA_HOME=/usr/lib/jvm/java-6-sun env HADOOP_INSTALL=$HADOOP_HOME $HADOOP_HOME/bin/hadoop"
HADOOP_RUN_JAR="$HADOOP_BIN jar"
HADOOP_FS="$HADOOP_BIN fs"
HADOOP_COPY_FROM_LOCAL="$HADOOP_BIN fs -copyFromLocal"
HADOOP_BENCHMARKS="$HADOOP_HOME/hadoop-0.20.2-examples.jar"
SLEEP_TIME="120"

# TERAGEN AND TERASORT STUFF
TERAGEN_INPUT_SIZES="1000000000 2000000000 3000000000 4000000000 5000000000"
TERASORT_INPUT_DIR="/data/terasort-input"
TERASORT_OUTPUT_DIR="/data/terasort-output"
TERASORT_RMDIR_INPUT="$HADOOP_FS -rmr $TERASORT_INPUT_DIR"
TERASORT_RMDIR_OUTPUT="$HADOOP_FS -rmr $TERASORT_OUTPUT_DIR"
TERAGEN_HADOOP_BIN="$HADOOP_RUN_JAR $HADOOP_BENCHMARKS teragen -Dmapred.map.tasks=$MAPS"
TERASORT_HADOOP_BIN="$HADOOP_RUN_JAR $HADOOP_BENCHMARKS terasort -Dmapred.map.tasks=$MAPS -Dmapred.reduce.tasks=$REDUCES $TERASORT_INPUT_DIR $TERASORT_OUTPUT_DIR"

# WIKIPEDIA STUFF
WIKIBENCH_INPUT_DATA_DIR="/mnt/wikidata"
WIKIBENCH_INPUT_DIR="/data/wikipedia-input"
WIKIBENCH_OUTPUT_DIR="/data/wikipedia-output"
WIKIBENCH_INPUT_FILE="enwiki-latest-pages-articles.xml"
WIKIBENCH_RMDIR_INPUT="$HADOOP_FS -rmr $WIKIBENCH_INPUT_DIR" 
WIKIBENCH_RMDIR_OUTPUT="$HADOOP_FS -rmr $WIKIBENCH_OUTPUT_DIR"
WIKIBENCH_MKDIR_INPUT="$HADOOP_FS -mkdir $WIKIBENCH_INPUT_DIR" 
WIKIBENCH_HADOOP_BIN="$HADOOP_RUN_JAR $HADOOP_HOME/lbnl/wikiproc.jar"
WIKIBENCH_RUNS="0 1 2"
WIKIBENCH_MODES="0 1 2"

run_terasort() {
for size in $TERAGEN_INPUT_SIZES
do
  teragen_dat="teragen_$size.dat"
  $TERASORT_RMDIR_INPUT
  $TERAGEN_HADOOP_BIN $size $TERASORT_INPUT_DIR 2>> $teragen_dat
  sleep $SLEEP_TIME
  terasort_dat="terasort_$size.dat"
  $TERASORT_RMDIR_OUTPUT
  $TERASORT_HADOOP_BIN 2>> $terasort_dat 
  sleep $SLEEP_TIME
done

$TERASORT_RMDIR_INPUT
$TERASORT_RMDIR_OUTPUT
}

run_wikipedia() {
$WIKIBENCH_RMDIR_INPUT
$WIKIBENCH_MKDIR_INPUT

for run in $WIKIBENCH_RUNS
do
  source_file_name=$WIKIBENCH_INPUT_DATA_DIR/$WIKIBENCH_INPUT_FILE
  destination_file_name=$WIKIBENCH_INPUT_DIR/$WIKIBENCH_INPUT_FILE$run
  echo "Uploading $source_file_name in round $run to $destination_file_name"
  $HADOOP_COPY_FROM_LOCAL $source_file_name $destination_file_name 2>> "wikidata_$run.dat"
  sleep $SLEEP_TIME
  for mode in $WIKIBENCH_MODES 
  do
     echo "Running Wikipedia benchmark in mode $mode"
     $WIKIBENCH_HADOOP_BIN $mode $MAPS $REDUCES $WIKIBENCH_INPUT_DIR $WIKIBENCH_OUTPUT_DIR 2>> "wikibench_"$run"_$mode.dat"
     $WIKIBENCH_RMDIR_OUTPUT
     sleep $SLEEP_TIME
  done
done

$WIKIBENCH_RMDIR_INPUT
$WIKIBENCH_RMDIR_OUTPUT
}

run_wikipedia
run_terasort
