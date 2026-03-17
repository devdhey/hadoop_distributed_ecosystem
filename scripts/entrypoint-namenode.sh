#!/bin/bash

# Function to log messages
log() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

# 1. Format NameNode if necessary
if [ ! -f /hadoop/dfs/name/current/VERSION ]; then
  log "Formatting NameNode..."
  hdfs namenode -format -force
fi

# 2. Start NameNode in the background
log "Starting NameNode..."
hdfs namenode &

# 3. Wait for NameNode to be responsive
log "Waiting for NameNode (9870) to be up..."
until curl -s http://localhost:9870 > /dev/null; do
  sleep 2
done
log "NameNode UI is up."

# 4. Wait for DataNodes to connect
log "Waiting for DataNodes to connect..."
MIN_DATANODES=2
ACTUAL_DATANODES=0
while [ $ACTUAL_DATANODES -lt $MIN_DATANODES ]; do
  # Silence stderr to avoid "Call to localhost:8020 failed" spam while NameNode is initializing
  ACTUAL_DATANODES=$(hdfs dfsadmin -report 2>/dev/null | grep "Live datanodes" | awk '{print $3}' | tr -d '()')
  ACTUAL_DATANODES=${ACTUAL_DATANODES:-0}
  
  if [ $ACTUAL_DATANODES -lt $MIN_DATANODES ]; then
    log "Live DataNodes: $ACTUAL_DATANODES (Waiting for $MIN_DATANODES...)"
    sleep 5
  fi
done
log "Minimum DataNodes reached ($ACTUAL_DATANODES)."

# 5. Leave Safe Mode
log "Attempting to leave Safe Mode..."
hdfs dfsadmin -safemode leave
log "Safe Mode left."

# 6. Setup HDFS directories
log "Setting up HDFS directories..."
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -mkdir -p /tmp/hive
hdfs dfs -mkdir -p /apps/tez
hdfs dfs -chmod -R 777 /tmp
hdfs dfs -chmod -R 777 /tmp/hive
hdfs dfs -chmod -R 777 /user/hive
hdfs dfs -chmod -R 777 /apps/tez
log "HDFS setup complete."

# 7. Wait for NameNode process to finish (which it shouldn't unless stopped)
wait
