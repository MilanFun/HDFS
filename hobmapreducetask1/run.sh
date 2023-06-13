#!/usr/bin/env bash
 
IN_DIR="/data/wiki/en_articles"
OUT_DIR="streaming_wc_result"
NUM_REDUCERS=3
 
hadoop fs -rm -r -skipTrash ${OUT_DIR}* > /dev/null
 
yarn jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar \
    -D mapred.job.name="hob mapreduce step1" \
    -D mapreduce.job.reduces=${NUM_REDUCERS} \
    -files solve \
    -mapper solve/mapper.py \
    -reducer solve/reducer.py \
    -input ${IN_DIR} \
    -output ${OUT_DIR}.tmp > /dev/null
 
yarn jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar \
    -D mapred.job.name="hob mapreduce step2 post-sorting" \
    -D stream.num.map.output.key.fields=2 \
    -D mapreduce.job.reduces=1 \
    -D mapreduce.job.output.key.comparator.class=org.apache.hadoop.mapreduce.lib.partition.KeyFieldBasedComparator \
    -D mapreduce.partition.keycomparator.options='-k2,2nr -k1' \
    -mapper cat \
    -reducer cat \
    -input ${OUT_DIR}.tmp \
    -output ${OUT_DIR} > /dev/null
 
# Print results
hdfs dfs -cat ${OUT_DIR}/part-00000 | tr '[:upper:]' '[:lower:]' > file
head -10 file
rm -f file

