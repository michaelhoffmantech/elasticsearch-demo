# Demos

Below are the full details of demos for the Food Facts Elasticsearch presentation. 

# Demo Contents

[Demo 1 - Running Elasticsearch](#demo-1-running-elasticsearch)
[Demo 2 - Adding the Schema to Elasticsearch](#demo-2-adding-the-schema-to-elasticsearch)

# Demo 1 Running Elasticsearch

I've provided support for running a Docker image of Elasticsearch and Kibana. Here are steps for running it.

1. Install the latest version of Docker for your O/S. I'll be demonstrating with Mac OS. Assure you have given Docker the appropriate amount of memory 4-6GB is suggested. 
2. Open a terminal
3. Navigate to the root directory of the project. 
4. Run the following command:
    ```cmd
    docker-compose -f docker/elasticsearch.yml up
    ```
5. Once the services are up, you should see a message noting the server is started.
6. Open a browser and navigate to http://localhost:5601. This should successfully display the Kibana application.
7. Navigate to the dev tools page and run the following:
    ```
    GET _cluster/health
    ```
    This will show you health information about the cluster, including the cluster name, status, nodes, etc. 

# Demo 2 Adding the Schema to Elasticsearch

## 2.1 - Viewing the Food Facts Data

I've used a CSV extract from an open source database of food facts. 

1. Open the file data/openfoodfacts_search.csv
2. I'm only going to use a subset of the data from here. 
3. Note that the data is inconsistent when it comes to case and structure. 

## 2.2 - Creating the Index

I've included the index in the project. It will need to be loaded via the index REST API.

1. Open Kibana at http://localhost:5601
2. Open the file in the project: schema/food_product_index_v1.json
3. In Kibana, paste the contents of the file after the following API URI:
    ```
    PUT food_product_index_v1
    <insert food_product_index_v1.json contents here>
    ```
4. Execute the API call. The following should be the response from the call:
    ```json
    {
      "acknowledged": true,
      "shards_acknowledged": true,
      "index": "food_product_index_v1"
    }
    ```

