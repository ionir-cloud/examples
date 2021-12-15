
POD_NAMESPACE="mongo"
POD_NAME="mongodb-0"

echo "getting the data"
kubectl -n ${POD_NAMESPACE} exec ${POD_NAME} -- bash -c "cd /tmp \
&& apt-get update && apt-get install wget && apt-get install gzip \
&& wget https://datasets.imdbws.com/name.basics.tsv.gz \
$$ wget https://datasets.imdbws.com/title.akas.tsv.gz \
$$ wget https://datasets.imdbws.com/title.basics.tsv.gz \
$$ wget https://datasets.imdbws.com/title.crew.tsv.gz \
$$ wget https://datasets.imdbws.com/title.episode.tsv.gz \
$$ wget https://datasets.imdbws.com/title.principals.tsv.gz \
$$ wget https://datasets.imdbws.com/title.ratings.tsv.gz"

echo "extracting the data"
kubectl -n ${POD_NAMESPACE} exec ${POD_NAME} -- bash -c "cd /tmp \
&& gzip -dk name.basics.tsv.gz \
$$ gzip -dk title.akas.tsv.gz \
$$ gzip -dk title.basics.tsv.gz \
$$ gzip -dk title.crew.tsv.gz \
$$ gzip -dk title.episode.tsv.gz \
$$ gzip -dk title.principals.tsv.gz \
$$ gzip -dk title.ratings.tsv.gz"

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
