# Configuring Grassroots {#configuration_guide}

Both the Grassroots core and its services are configured using JSON files. 


## Apache configuration



## Core configuration

The core configuration file is specified in the Apache configuration file using the 
```GrassrootsConfig``` directive within the Apache configuration file. For example the 
following snippet

```
	# The global configuration file to use
	GrassrootsConfig grassroots.public
```

specifies that the core configuration file that we will use is called *grassroots.public*.

There are various sections within the core configuration file that we will now detail.

 * **so:url**: This is the web address of this Grassroots instance. This is only used when 
federating multiple Grassroots instances together. An examppe of this is 

   ```
  "so:url": "http://localhost/grassroots/public"
   ```

 * **services**:


 * **mongodb**: This contains the configuration details for the MongoDB instance that Grassroots
will use. This block currently contains a single configuration directive:
 
     * **uri**: This specifies the web address of the MongoDB instance that Grassroots will 
connect to. By default, MongoDB runs on port 27017 so to use a MongoDB server running on the
same machine, the configuration snippet would be

    ```
	"mongodb": {
		"uri": "mongodb://localhost:27017"
	}

    ```

 * **provider**: This specifies the information about the orgraization hosting this Grassroots 
instance. It is defined as an [Organization](https://schema.org/Organization) from schema.org 
and it uses the following fields:

    * **so:name**: "billy public",
    * **so:description**: "Billy's public grassroots",
    * **so:url**: "localhost:2000/info",
    * **so:logo**: "http://localhost:2000/grassroots/images/ei_logo.jpg"

 An example snippet is shown below

```
	"provider": {
		"@type": "so:Organization",
		"so:name": "billy public",
		"so:description": "Billy's public grassroots",
		"so:url": "localhost:2000/info",
		"so:logo": "http://localhost:2000/grassroots/images/ei_logo.jpg"
	}
```


A complete example configuration file is shown below

```.json
{
  "so:url": "http://localhost:8080/grassroots/public/",
	"services": {
		"status": {
			"default": true,
			"Manage Field Trial indexes": false
		}
	},
	"mongodb": {
		"uri": "mongodb://localhost:27017"
	},
	"provider": {
		"@type": "so:Organization",
		"so:name": "billy public",
		"so:description": "Billy's public grassroots",
		"so:url": "localhost:2000/info",
		"so:logo": "http://localhost:2000/grassroots/images/ei_logo.jpg"
	},
	"jobs_manager": "mongodb_jobs_manager",
	"mongodb_jobs_manager": {
		"database": "grassroots",
		"collection": "jobs"
	},
	"servers_manager": "simple_external_servers_manager",
	"admin": {
		"jobs": {
		}
	},
	"geocoder": {
		"default_geocoder": "nominatim",
		"geocoders": [{
			"name": "nominatim",
			"reverse_geocode_url": "https://nominatim.openstreetmap.org/reverse",
			"geocode_url": "https://nominatim.openstreetmap.org/search?format=json"
		}, {
			"name": "google",
			"geocode_url": "https://maps.googleapis.com/maps/api/geocode/json?sensor=<YOUR API KEY>"
		}, {
			"name": "opencage",
			"geocode_url": "https://api.opencagedata.com/geocode/v1/json?key=<YOUR API KEY>"
		}]
	},
	"lucene": {
		"classpath": "/home/billy/Applications/lucene/analysis/common/lucene-analyzers-common-8.11.1.jar:/home/billy/Applications/lucene/core/lucene-core-8.11.1.jar:/home/billy/Applications/lucene/facet/lucene-facet-8.11.1.jar:/home/billy/Applications/lucene/queryparser/lucene-queryparser-8.11.1.jar:/home/billy/Applications/lucene/backward-codecs/lucene-backward-codecs-8.11.1.jar:/home/billy/Applications/lucene/highlighter/lucene-highlighter-8.11.1.jar:/home/billy/Applications/lucene/queries/lucene-queries-8.11.1.jar:/home/billy/Applications/lucene/memory/lucene-memory-8.11.1.jar:/home/billy/Applications/grassroots/lucene/lib/grassroots-search-core-0.1.jar:/home/billy/Applications/grassroots/lucene/lib/grassroots-search-lucene-app-0.1.jar:/home/billy/Applications/grassroots/lucene/lib/json-simple-1.1.1.jar",
		"index": "/home/billy/Applications/grassroots/lucene/index",
		"taxonomy": "/home/billy/Applications/grassroots/lucene/tax/",
		"search_class": "uk.ac.earlham.grassroots.app.lucene.Searcher",
		"index_class": "uk.ac.earlham.grassroots.app.lucene.Indexer",
		"delete_class": "uk.ac.earlham.grassroots.app.lucene.Deleter",
		"working_directory": "/home/billy/Applications/grassroots/working_directory/lucene",
		"facet_key": "facet_type"
	}
}
```
