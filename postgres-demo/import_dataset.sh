#!/bin/bash
set -e

POD_NAME='postgres-demo-0'													# image-gallery pod name - TODO: get it dynamically
POD_NAMESPACE="${POD_NAMESPACE:-postgres}"								# namespace where the pod resides - defaults to 'image-gallery'
WORK_FILE="http://prod.publicdata.landregistry.gov.uk.s3-website-eu-west-1.amazonaws.com/pp-complete.csv"													# temporary file to store the list of files in the S3 bucket
# the https name for the S3 bucket (hosted static webserver by S3)
#POD_PERSISTENT_DATA_DIR="/persistent_data"									# the ionir volume mount point
#POD_IMAGES_FOLDER="${POD_PERSISTENT_DATA_DIR}/images"						# the folder inside the application to which images should be copied to
POD_TMP_FOLDER="/tmp"

necho() {
	echo -e "`date`: $* "
}

# staging locally option
#necho "Fetching files list from wget http://prod.publicdata.landregistry.gov.uk.s3-website-eu-west-1.amazonaws.com/pp-complete.csv"
#wget http://prod.publicdata.landregistry.gov.uk.s3-website-eu-west-1.amazonaws.com/pp-complete.csv

#mkdir ${POD_TMP_FOLDER} &&
necho "Entering ${POD_NAMESPACE}/${POD_NAME} and downloading files"
kubectl -n ${POD_NAMESPACE} exec ${POD_NAME} -- sh -c " cd ${POD_TMP_FOLDER} \
  && apt-get update && apt-get -y install wget && rm -rf /var/cache/apt/* 
  wget ${WORK_FILE}
"

necho "Entering ${POD_NAMESPACE}/${POD_NAME} and creating testdb and table"

kubectl -n ${POD_NAMESPACE} exec ${POD_NAME} -- sh -c ' psql -U postgresadmin -d postgres -c "CREATE DATABASE  testdb"'
necho " testdb Database created"

kubectl -n ${POD_NAMESPACE} exec ${POD_NAME} -- sh -c ' psql -U postgresadmin -d testdb -c "CREATE TABLE  testdb (
  transaction uuid,
  price numeric,
  transfer_date date,
  postcode text,
  property_type char(1),
  newly_built boolean,
  duration char(1),
  paon text,
  saon text,
  street text,
  locality text,
  city text,
  district text,
  county text,
  ppd_category_type char(1),
  record_status char(1) );
  "'
necho "testdb Table created"


####
necho "Entering ${POD_NAMESPACE}/${POD_NAME} and importing data"
kubectl -n ${POD_NAMESPACE} -it exec ${POD_NAME} -- psql -U postgresadmin -d testdb -c "
COPY testdb FROM '/tmp/pp-complete.csv' DELIMITER ',' CSV HEADER; "
    
    
necho "done."
