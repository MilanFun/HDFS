#!/usr/bin/env bash

IN_DIR="/data/minecraft-server-logs"
OUT_DIR="streaming_wc_result"
NUM_REDUCERS=2

hadoop fs -rm -r -skipTrash ${OUT_DIR}* > /dev/null
 
yarn jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar \
    -D mapreduce.job.reduces=${NUM_REDUCERS} \
    -files solve \
    -mapper solve/mapper.py \
    -reducer solve/reducer.py \
    -input ${IN_DIR} \
    -output ${OUT_DIR}.tmp > /dev/null
 
yarn jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar \
    -D stream.num.map.output.key.fields=2 \
    -D mapreduce.job.reduces=1 \
    -D mapreduce.job.output.key.comparator.class=org.apache.hadoop.mapreduce.lib.partition.KeyFieldBasedComparator \
    -D mapreduce.partition.keycomparator.options='-k2,2nr -k3' \
    -mapper cat \
    -reducer cat \
    -input ${OUT_DIR}.tmp \
    -output ${OUT_DIR} > /dev/null
 
# Print results
hdfs dfs -cat ${OUT_DIR}/part-00000 | sort -k2nr -k3nr > file
head file
rm -f file

