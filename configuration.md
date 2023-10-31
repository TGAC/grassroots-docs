# Configuring Grassroots 

Grassroots is to be as modular and adaptable as possible so there are many levels of configuration within the system. These are grouped into 3 areas:

* Apache: As Apache is the way to access the Grassroots infrastructure,
it has to be configured to make the Grassroots functionality available.
* Grassroots core: Each Grassroots server has a global configuration 
file which allows the non-service-specific functionality to be altered. 
* Services: Each service has a separate configuration file which allows any of its 
settings to be altered

Any changes to the Apache or Grassroots core configuration files requires a restart
of the Apache web server to take effect. Any changes to service configuration files
are active immediately.

Both the Grassroots core and its services configuration files are in JSON format. 
The configuration files for the individual services are detailed in their respective 
documentation which are in the Services section on the [Components](components.md) page
although they all have various common [non-service-specific configuation options](service_configuration.md) that can be edited
Similarly the Apache httpd configuration is detailed in the [Grassroots httpd](servers/apache-server.md) documentation. 
Therefore we will concentrate on the core configuration here.

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

   ```json
	"so:url": "http://localhost/grassroots/public"
   ```

* **services**: This contains global configuration relating to services.
It contains the following child objects
	* **status**: This object details whether particular services are enabled. 

		* **default**: By default all services are available although this can be changed by the use of this key. Setting it to `false` specifies that by default all services will be unavailable.

		Any default value can be overriden for individual services by using the service name as the key and either `true`, to make the service enabled, or `false` to specify that is disabled. For example, to set that all services except for the *BlastN* service are enabled, the 
configuration would be

     
	```json
	"services": {
		"status": {
			"default": true,
			"BlastN": false
		}
	}
	```

	Alternatively, to specify that only the *Manage Study* and *Manage Field Trial data* services were available, the configuration would be 

	```json
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


	```json
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

	```json
	"provider": {
		"@type": "so:Organization",
		"so:name": "billy public",
		"so:description": "Billy's public grassroots",
		"so:url": "localhost:2000/info",
		"so:logo": "http://localhost:2000/grassroots/images/ei_logo.jpg"
	}
	```


* **jobs_manager**: Since Grassroots can run its services as multi-threaded and multi-process as well as asynchronously it needs a way of tracking these. This is done by the *Jobs Manager* component. 
The standard component is the one that uses MongoDB to store its data and this is called `mongodb_jobs_manager`. 
This can also be configured to specify the names of the database and collection that the MongoDB Jobs Manager will use by using the `mongodb_jobs_manager`
key.
For example to use the `mongodb_jobs_manager` which is standard and specify 
that you want to use a database called *my_jobs_db* and collection called *my_jobs_collection*, the configuration would be:


	```json
	"jobs_manager": "mongodb_jobs_manager",
	"mongodb_jobs_manager": {
		"database": "my_jobs_db",
		"collection": "my_jobs_collection"
	}
	```


* **servers_manager**: When federating Grassroots servers, the Servers Manager takes care of creating the list of combined services and where jobs are running. Currently there is a single available module for this which is the *Simple External Servers Manager*. So the configuration needs to be 

	```json
"servers_manager": "simple_external_servers_manager"
	```

* **geocoder**: These are external web service REST APIs available
from various organisations such as openstreetmap, google, opencage, *etc.*
 For more information see the [Grassroots geocoder](libs/geocoder.md) library. 
	* **geocoders**: This is an array of available geocoder configurations. 
Each object in this array can have the following keys:
		* **name**: This is required and is a name to give to this configuration object. 
Any value is fine as it is only used for setting the *default_geocoder* 
value explained below.
		* **geocode_url**: This is REST web service endpoint for converting a postal address into GPS coordinates.
		* **reverse_geocode_url**: This is REST web service endpoint for converting GPS coordinates into a postal address.

	* **default_geocoder**: This specifies the name of which of the entries in the *geocoders* array to use. T

	```json
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

* **servers**: This is where you can connect Grassroots servers together to share their services. More infromation is given in the [federation guide](federation.md).

* **lucene**: 
The [Grassroots Lucene](lucene/lucene.md) module handles the searching 
and indexing of data within Grassroots.
The confguration file details where its libraries are installed, 
which programs to run for indexing and searching, and where it's working
files are stored.

	* **classpath**: This is the classpath that contains all of the jar files required for running the Lucene programs. 
The Grassroots Lucene code is compatible with both versions 8.x and 9.x of Lucene although the required entries on the classpath are different.
For either version, the following jar files are required:
	
	* `PATH TO GRASSROOTS INSTALLATION`/lucene/lib/grassroots-search-core-0.1.jar
	* `PATH TO GRASSROOTS INSTALLATION`/lucene/lib/grassroots-search-lucene-app-0.1.jar:
	* `PATH TO GRASSROOTS INSTALLATION`/lucene/lib/json-simple-1.1.1.jar
			
	For Lucene 8.x, the following jars are needed:

	* `PATH TO LUCENE INSTALLATION`/analysis/common/lucene-analyzers-common-`LUCENE VERSION`.jar
	* `PATH TO LUCENE INSTALLATION`/core/lucene-core-`LUCENE VERSION`.jar
	* `PATH TO LUCENE INSTALLATION`/facet/lucene-facet-`LUCENE VERSION`.jar
	* `PATH TO LUCENE INSTALLATION`/queryparser/lucene-queryparser-`LUCENE VERSION`.jar
	* `PATH TO LUCENE INSTALLATION`/backward-codecs/lucene-backward-codecs-`LUCENE VERSION`.jar
	* `PATH TO LUCENE INSTALLATION`/highlighter/lucene-highlighter-`LUCENE VERSION`.jar
	* `PATH TO LUCENE INSTALLATION`/queries/lucene-queries-`LUCENE VERSION`.jar
	* `PATH TO LUCENE INSTALLATION`/memory/lucene-memory-`LUCENE VERSION`.jar
 

	For Lucene 9.x, the following jars are needed:

	* `PATH TO LUCENE INSTALLATION`/modules/lucene-analysis-common-`LUCENE VERSION`.jar
	* `PATH TO LUCENE INSTALLATION`/modules/lucene-core-`LUCENE VERSION`.jar
	* `PATH TO LUCENE INSTALLATION`/modules/lucene-queryparser-`LUCENE VERSION`.jar
	* `PATH TO LUCENE INSTALLATION`/modules/lucene-facet-`LUCENE VERSION`.jar
	* `PATH TO LUCENE INSTALLATION`/modules/lucene-queries-`LUCENE VERSION`.jar
	* `PATH TO LUCENE INSTALLATION`/modules/lucene-memory-`LUCENE VERSION`.jar
	* `PATH TO LUCENE INSTALLATION`/modules/lucene-highlighter-`LUCENE VERSION`.jar

 
	where `PATH TO GRASSROOTS INSTALLATION` is where you have Grassroots installed, `PATH TO LUCENE INSTALLATION` is where you have Lucene installed and `LUCENE VERSION` is its version. 
	For example, if you have Grassroots installed in `/opt/grassroots` and Lucene version 8.11.1 installed at `/opt/lucene` then the classpath variable would be: 

	```json
"classpath": "/opt/grassroots/lucene/lib/grassroots-search-core-0.1.jar:/opt/grassroots/lucene/lib/grassroots-search-lucene-app-0.1.jar:/opt/grassroots/lucene/lib/json-simple-1.1.1.jar:/opt/lucene/analysis/common/lucene-analyzers-common-8.11.1.jar:/opt/lucene/core/lucene-core-8.11.1.jar:/opt/lucene/facet/lucene-facet-8.11.1.jar:/opt/lucene/queryparser/lucene-queryparser-8.11.1.jar:/opt/lucene/backward-codecs/lucene-backward-codecs-8.11.1.jar:/opt/lucene/highlighter/lucene-highlighter-8.11.1.jar:/opt/lucene/queries/lucene-queries-8.11.1.jar:/opt/lucene/memory/lucene-memory-8.11.1.jar"
``` 

* **index**: This specifies the directory where Lucene will store its index files.
* **taxonomy**: This specifies the directory where Lucene will store its taxonmony files.
* **search_class**: This is the class for the program that will be used for searching 
the Grassroots system. The default is `uk.ac.earlham.grassroots.app.lucene.Searcher`. 
* **index_class**: This is the class for the program that will be used for searching 
the Grassroots system. The default is `uk.ac.earlham.grassroots.app.lucene.Indexer`.
* **delete_class**: This is the class for the program that will be used for searching 
the Grassroots system. The default is `uk.ac.earlham.grassroots.app.lucene.Deleter`.
* **working_directory**: This is the directory where all of the temporary files used when indexing and searching are stored. 
This directory must be writeable to by the user that is running the apache process.  
* **facet_key**: This specifies the key used within the indexing process used to store the type of data being indexed such as dataset, field trial, *etc.* By default this is set to `facet_type`. 
If you change this, then you will need to reindex all data to use the new
key.



### Example

A complete example configuration file is shown below

```json
{
  "so:url": "http://localhost/grassroots/public/",
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
		"so:name": "Demo server",
		"so:description": "Grassroots demo instance",
		"so:url": "http://localhost/info",
		"so:logo": "http://localhost//images/logo.jpg"
	},
	"jobs_manager": "mongodb_jobs_manager",
	"mongodb_jobs_manager": {
		"database": "grassroots",
		"collection": "jobs"
	},
	"servers_manager": "simple_external_servers_manager",
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
		"classpath": "/opt/lucene/analysis/common/lucene-analyzers-common-8.11.1.jar:/opt/lucene/core/lucene-core-8.11.1.jar:/opt/lucene/facet/lucene-facet-8.11.1.jar:/opt/lucene/queryparser/lucene-queryparser-8.11.1.jar:/opt/lucene/backward-codecs/lucene-backward-codecs-8.11.1.jar:/opt/lucene/highlighter/lucene-highlighter-8.11.1.jar:/opt/lucene/queries/lucene-queries-8.11.1.jar:/opt/lucene/memory/lucene-memory-8.11.1.jar:/opt/grassroots/lucene/lib/grassroots-search-core-0.1.jar:/opt/grassroots/lucene/lib/grassroots-search-lucene-app-0.1.jar:/opt/grassroots/lucene/lib/json-simple-1.1.1.jar",
		"index": "/opt/grassroots/lucene/index",
		"taxonomy": "/opt/grassroots/lucene/tax/",
		"search_class": "uk.ac.earlham.grassroots.app.lucene.Searcher",
		"index_class": "uk.ac.earlham.grassroots.app.lucene.Indexer",
		"delete_class": "uk.ac.earlham.grassroots.app.lucene.Deleter",
		"working_directory": "/opt/grassroots/working_directory/lucene",
		"facet_key": "facet_type"
	}
}
```
