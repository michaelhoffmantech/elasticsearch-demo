# Demos

Below are the full details of demos for the Food Facts Elasticsearch presentation. 

# Demo Initialization

1. Run the following to reset for the start of the demo:
    ```
    DELETE food_product_index_v1 
    ```
2. Open docker/elasticsearch.yml in IntelliJ
3. Open data/openfoodfacts.txt in IntelliJ
4. Open data/openfoodfacts_search.csv in Numbers
5. Open a browser with http://localhost:5601 ready to load
6. Open two terminal windows to the project under ~/Personal/elasticsearch-demo
7. 

# Demo Contents

[Demo 1 - Running Elasticsearch](#demo-1-running-elasticsearch)
[Demo 2 - Adding the Schema to Elasticsearch](#demo-2-adding-the-schema-to-elasticsearch)
[Demo 3 - Analyzing Data](#demo-3-analyzing-data)
[Demo 4 - Search Queries](#demo-4-search-queries)

# Demo 1 Running Elasticsearch

Going to run Elasticsearch and Kibana

* Configure Docker for 4-6GB
* Latest version of Docker

1. Run the command below in the terminal:
    ```cmd
    docker-compose -f docker/elasticsearch.yml up
    ```

* Server status -> Green
* Issue with single node -> Yellow

1. Open Kibana and run:
    ```
    GET _cluster/health
    ```
    
* Convenience endpoint for health
* Usage of Kibana at client

# Demo 2 Adding the Schema to Elasticsearch

Start by showing data source 

1. Open the file data/openfoodfacts_search.csv

* Only subset of data
* Data structure and wording is inconsistent

Open the index

1. Open Kibana at http://localhost:5601
2. Show project file: schema/food_product_index_v1.json
3. In Kibana, paste the contents of the file after the following API URI:
    ```
    PUT food_product_index_v1
    <insert food_product_index_v1.json contents here>
    ```

* Should see acknowledged
* Should see index name

Use Elasticsearch bulk loader to load data into the index

* Required format for bulk load
* New line character is really important
* This is a process, but I did it with script

1. Execute the following CURL command from new terminal:
    ```
    curl -s -XPOST localhost:9200/_bulk -H "Content-Type:application/x-ndjson" --data-binary @/Users/mhoffman/Personal/elasticsearch-demo/data/openfoodfacts.txt
    ```

* Content output back to console

Show the scripted output 

1. Open IntelliJ to show data/openfoodfacts.txt

Show the result

1. Open up Kibana and run the following command to view records (679):
    ```
    GET food_product_index_v1/product/_search
    {
      "query": {
        "match_all": {}
      }
    }
    ```

# Demo 3 Analyzing Data

Execute the Analyze API against sample data from our source

1. Execute the following API call for product name:
    ```
    POST _analyze
    {
        "analyzer" : "standard",
        "text" : "Cranberry Raspberry 100% Juice Blend"
    }
    ```

* Lowercase tokenizer
* Start and end offsets -> Stemming
* Type as alpha or num
* 100 with % stripped
* Token position

2. Execute the following API call for product categories

    ```
    POST _analyze
    {
      "tokenizer" : {
        "type": "standard"
      },
      "filter": [
        "lowercase", 
        {
          "type": "stemmer",
          "name": "light_english"
        },
        "unique",
        {
          "type": "stop", 
          "stopwords": "_english_, non"
        }
      ], 
        "text" : "Plant-based foods and beverages,Beverages,Plant-based foods,Hot beverages,Herbal teas,Teas in tea bags,Non-sugared beverages"
    }    
    
    ```

* Builds tokens using common grammar
* Filter order matters
* Lowercase filter
* Stemmer takes stems of a word for filtering
* Unique filter removes duplicate. Use English by default. Show issue with non.

# Demo 4 Search Queries

Run several Boolean queries in Kibana

1. Execute the following query in Kibana

    ```
    GET food_product_index_v1/product/_search
    {
      "query": {
        "bool": {
          "must": [
            {
              "match": {
                "productName": "Monster"
              }
            }
          ]
        }
      }
    }
    ```

* URI structure index/type/_search
* Bool is the query type
* Must means there must be a match in the doc to be returned

2. Execute the following query in Kibana

    ```
    GET food_product_index_v1/product/_search
    {
      "query": {
        "bool": {
          "should": [
            {
              "nested": {
                "path": "categories",
                "query": {
                  "match": {
                    "categories.name": "beers"
                  }
                }
              }
            }, 
            {
              "match": {
                "productName": "Heineken"
              }
            }
          ]
        }
      }
    }
    ```
    
* Should instead of must. 
* One criteria should match
* Note categories are nested. 

3. Execute the following query in Kibana:

    ```
    GET food_product_index_v1/product/_search
    {
      "query": {
        "bool": {
          "should": [
            {
              "nested": {
                "path": "categories",
                "query": {
                  "match": {
                    "categories.name": "beers"
                  }
                }
              }
            }
          ], 
          "must_not": [
            {
              "match": {
                "productName": "Heineken"
              }
            }
          ]
        }
      }
    }
    ```

* Now using a Should and a Must Not
* The results dropped from 32 to 30
* Must not means to remove resulting documents if they have product name of Heineken

4. Execute the following query in Kibana:

