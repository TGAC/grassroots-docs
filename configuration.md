# Configuring Grassroots 

Both the Grassroots core and its services are configured using JSON files. 


## Apache configuration

The Apache httpd configuration is detailed at the
 [Grassroots httpd](https://github.com/TGAC/grassroots-server-apache-httpd) 
module


## Core configuration

The core configuration file is specified in the Apache configuration file using the 
`GrassrootsConfig` directive within the Apache configuration file. The filename is relative to
the directory in which Grassroots has been installed which is the `GrassrootsRoot` directive 
specified in the Grassroots httpd documentation specified above. 

For example the following snippet

```
	# The global configuration file to use
	GrassrootsConfig grassroots.public
```

specifies that the core configuration file that we will use is called *grassroots.public*.
If the `GrassrootsConfig` directive is not set then the default filename of *grassroots.config*
will be used


There are various sections within the core configuration file that we will now detail.

* **so:url**: This is the web address of this Grassroots instance. This is only used when 
federating multiple Grassroots instances together. An example of this is 

   ```
  "so:url": "http://localhost/grassroots/public"
   ```

* **services**: This contains global configuration relating to services.
It contains the following child objects
	* **status**: This object details whether particular services are enabled. 

		* **default**: By default all services are available although this can be changed by the use of this key. Setting it to `false` specifies that by default all services will be unavailable.

		Any default value can be overriden for individual services by using the service name as the key and either `true`, to make the service enabled, or `false` to specify that is disabled. For example, to set that all services except for the *BlastN* service are enabled, the 
configuration would be

     
	```
	"services": {
		"status": {
			"default": true,
			"BlastN": false
		}
	}
	```

	Alternatively, to specify that only the *Manage Study* and *Manage Field Trial data* services were available, the configuration would be 

	```
	"services": {
		"status": {
			"default": false,
			"Manage Study": true,
			"Manage Field Trial data": true
		}
	}
	```


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

    * **so:name**: The name of this Grassroots server.
    * **so:description**: A description of this server.
    * **so:url**: An optional web page with further details of this server.
    * **so:logo**: An optional logo for this server.

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


* **jobs_manager**:


* **servers_manager**: "simple_external_servers_manager",


* **admin**:
	* **jobs**: 


* **geocoder**: 
	* **geocoders**: This is an array of available geocoder configurations. These are external web service REST APIs available
from various organisations such as openstreetmap, google, opencage, *etc.* For more information see the [Grassroots geocoder]() library. 
Each object in this array can have the following keys:
		* **name**: This is required and is a name to give to this configuration object. 
Any value is fine as it is only used for setting the *default_geocoder* 
value explained below.
		* **geocode_url**: This is REST web service endpoint for converting a postal address into GPS coordinates.
		* **reverse_geocode_url**: This is REST web service endpoint for converting GPS coordinates into a postal address.

	* **default_geocoder**: This specifies the name of which of the entries in the *geocoders* array to use. T

```
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
	}
```

* **lucene**: 



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
