
POD_NAMESPACE="mongo"
POD_NAME="mongodb-0"

echo "getting the data"
kubectl -n ${POD_NAMESPACE} exec ${POD_NAME} -- bash -c "cd /tmp \
&& apt-get update && apt-get install wget \
&& wget https://datasets.imdbws.com/name.basics.tsv.gz \
$$ wget https://datasets.imdbws.com/title.akas.tsv.gz \
$$ wget https://datasets.imdbws.com/title.basics.tsv.gz \
$$ wget https://datasets.imdbws.com/title.crew.tsv.gz \
$$ wget https://datasets.imdbws.com/title.episode.tsv.gz \
$$ wget https://datasets.imdbws.com/title.principals.tsv.gz \
$$ wget https://datasets.imdbws.com/title.ratings.tsv.gz"

echo "extracting the data"
kubectl -n ${POD_NAMESPACE} exec ${POD_NAME} -- bash -c "cd /tmp \
&& tar -x name.basics.tsv.gz \
$$ tar -x title.akas.tsv.gz \
$$ tar -x title.basics.tsv.gz \
$$ tar -x title.crew.tsv.gz \
$$ tar -x title.episode.tsv.gz \
$$ tar -x title.principals.tsv.gz \
$$ tar -x title.ratings.tsv.gz"

echo "importing the data"
kubectl -n ${POD_NAMESPACE} exec ${POD_NAME} -- bash -c "
mongoimport -d demodb -c title --type tsv --file /tmp/name.basics.tsv --headerline
mongoimport -d demodb -c title --type tsv --file /tmp/title.akas.tsv --headerline
mongoimport -d demodb -c title --type tsv --file /tmp/title.basics.tsv --headerline
mongoimport -d demodb -c title --type tsv --file /tmp/title.crew.tsv --headerline
mongoimport -d demodb -c title --type tsv --file /tmp/title.episode.tsv --headerline
mongoimport -d demodb -c title --type tsv --file /tmp/title.principals.tsv --headerline
mongoimport -d demodb -c title --type tsv --file /tmp/title.ratings.tsv --headerline
"
