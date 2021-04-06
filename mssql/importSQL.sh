#!/bin/bash
set -e
POD_NAMESPACE='mssql'							# <--- namespace where the pod resides - default to running ns
POD_NAME=$(kubectl get po -n mssql -o jsonpath="{.items[0].metadata.name}")			# sql pod name 
DB_PASS='IonirP@ssw0rd'
DB_BAK_URL='https://github.com/microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksDW2016_EXT.bak'										

POD_TMP_FOLDER="/tmp"

necho() {
	echo -e "\033[0;32m `date`: $* \033[0m"
}
necho "Restoring to pod (${POD_NAME})  on namspace (${POD_NAMESPACE})"
necho "this url ${DB_BAK_URL}"

necho "Step 1:Entering ${POD_NAMESPACE}/${POD_NAME} and downloading files"

kubectl -n ${POD_NAMESPACE} exec ${POD_NAME} -- sh -c "cd ${POD_TMP_FOLDER} \
  && apt-get update && apt-get -y install wget && rm -rf /var/cache/apt/* \
  && wget ${DB_BAK_URL} "
 

necho "Step 2: Entering ${POD_NAMESPACE}/${POD_NAME} and recovering SQL"

kubectl -n ${POD_NAMESPACE} exec ${POD_NAME} -it -- /opt/mssql-tools/bin/sqlcmd -S . -U sa -P ${DB_PASS} -Q "RESTORE DATABASE [AdventureWorks2016] FROM DISK='/tmp/AdventureWorksDW2016_EXT.bak' WITH MOVE 'AdventureWorksDW2016_EXT_Data' to '/mssql/data/AdventureWorks2016.mdf', MOVE 'AdventureWorksDW2016_EXT_Log' to '/mssql/data/AdventureWorksDW2016_EXT_Log.ldf', NOUNLOAD, STATS = 5"

necho "done. DB Loaded"