# Server Configuration {#server_configuration_guide}


The global Server configuration is specified by a JSON file at the top level of the Grassroots directory.
By default this is called *grassroots.config* but can be altered using the *GrassrootsConfig* directive as detailed in the [Apache Grassroots module](@ref apache_server_guide) guide.
Unlike the individual [Service configuration](@ref service_configuration_guide) files, any changes in this file require a restart of the Grassroots Server to take effect.

## Options

There are various keys that can be placed in this file described below.

### Server web address

This is specified with the ```so:url``` key and is the web address for this Grassroots server.

### Default service statuses

By default, all of the Services that are installed in Grassroots will be available for users. 
However Grassroots has the ability to enable or disable services from within this configuration file.
This is done within the ```services``` key. Within this, there is a ```status``` child key. 
Within this ```status``` key, a ```default``` boolean key specifies whether services are enabled, by setting this to ```true```, or disabled, by setting this to ```false```, by default. 
As well as this default setting, each individual service can be enabled or disabled by using their
names as keys with the same boolean values as for the ```default``` key.

For example, to enable all services except the one named *Manage Field Trial indexes*, the following 
configuration snippet would be suitable.

~~~{json}
"services": {
	"status": {
		"default": true,
		"Manage Field Trial indexes": false
	}
}
~~~


### Provider

This is the object that describes this Grassroots Server and the organization hosting it. 
There are further details in the [Provider](@ref provider_guide) section of the Grassroots schema guide.

 * **provider**: This key is used to describe this Grassroots system 
  * **so:name**: The name to use for this Grassroots system.
  * **so:description**: A description of this Grassroots system to display to the user. 
  * **so:url**: The web address of a description of this Grassroots system.
  * **so:logo**: An image to use as the logo for this Provider.

~~~{json}
"provider": {
	"@type": "so:Organization",
	"so:name": "billy public",
	"so:description": "Billy's public grassroots",
	"so:url": "localhost:2000/info",
	"so:logo": "http://localhost:2000/grassroots/images/ei_logo.jpg"
}
~~~


### MongoDB configuration 

Grassroots comes with support for [MongoDB](https://www.mongodb.com/) with a library for common operations that uses the [MongoDB C Driver](http://mongoc.org/) which gets installed by the *install_dependencies* script which is part of the [build tools](https://github.com/TGAC/grassroots-build-tools) repository.

 * **mongodb**: This key has the details for any MongoDB server for this Grassroots Server to access. 
  * **uri**:  This specifies the uri of the MongoDB server to access.

~~~{json}
	"mongodb": {
		"uri": "mongodb://localhost:27017"
	}
~~~
     
### Federated servers

Grassroots servers can be federated together so that users logging into any of these will see the combined list of services from all of the different servers. 
This is configured within the ```servers``` object within in this file. 
This is an array of entries, each of which specify a Grassroots server to federate with.
Each of these entries require the following keys:

  * **server_name**: The name of the Grassroots system to connect to. This should match the so:name value
from its ```Provider```` object.
  * **server_uri**: The web address of the Grassroots system to connect to.
 
As well as these individual services can be federated together. 
For example [Grassroots BLAST services](https://github.com/TGAC/grassroots-service-blast) can be paired
so that all of the available databases appear upon a single page so that from a user's point of view,
they are all available in a single place. 
These are specified in an array called ```paired_services```. 
Each entry in this array require two bits of information, one to specify the service running on this Grassroots, using the ```local``` key and the other to specify the service running on the remote federated Grassroots server, specified using the ```remote``` key

For example to federate two servers; https://grassroots.one, our local server, and https://grassroots.two  remote server, the configuration would be


~~~{json}
  "servers": {[
		"server_name": "Grassroots Two server",
		"server_url": "https://grassroots.two"
  ]}
~~~

If you wished to pair a service called *Foo* running on https://grassroots.one and *Bar* running on https://grassroots.two, along with BlastN running on each server, then the configuration would become


~~~{json}
"servers": [{
	"server_name": "Grassroots Two server",
	"server_url": "https://grassroots.two",
	"paired_services": [{
		"local": "Foo",
		"remote": "Bar"
	}, {
		"local": "BlastN",
		"remote": "BlastN"	
	}]
}]
~~~

### Jobs manager

When needed Grassroots uses a component to manage job logging details along with sharing data in a safe way across processes and tasks. Currently the only available jobs manager is the [MongoDB Jobs Manager](https://github.com/TGAC/grassroots-jobs-manager-mongodb). To use this JobsManager module on the Grassroots system, you need to add an entry to the global configuration file using the ```jobs_manager``` key.

~~~{json}
"jobs_manager": "mongodb_jobs_manager",
~~~

which specifies that this module will be used.

The module can be configured by adding a section called mongodb_jobs_manager where you can override the default database (this defaults to *grassroots*) and collection (this defaults to *jobs*) names. *e.g.*

~~~{json}
"mongodb_jobs_manager": {
	"database": "my_database",
	"collection": "my_collection"
}	
~~~


### Servers manager

When one or more Grassroots servers are federated together, a component called a *Servers Manager* is used to broker the details between them. Currently the only Servers Manager available is the [Simple Servers Manager](https://github.com/TGAC/grassroots-simple-servers-manager). 
To set this in the configuration, use the ```servers_manager``` key.

~~~{json}
"servers_manager": "simple_external_servers_manager"
~~~

### Geocoder

Grassroots has an optional [Geocoder library](https://github.com/TGAC/grassroots-geocoder) library for getting GPS coordinates from address details such as town, county, country, etc. and vice versa.
The configuration options for this library are specified with the ```geocoder``` key. It has an array of geocoder configuration details specified by the ```geocoders``` key. Each one of these consists of two entries:

 * **name**: The name to use for this geocoder. Currently there are three available options; [google](https://developers.google.com/maps/documentation/geocoding/overview), [opencage](https://opencagedata.com/api) and [nominatim](https://nominatim.org/).

 * **geocode_url**: This is the web address to call when you have address details and wish to determine the corresponding GPS coordinates. These uri values are vendor-dependent and you will need to get an API key from the appropriate vendor and assign its value to the key parameter in this address.
       
 * **reverse_geocode_url**: This is the web address to call to when you have some GPS coordinates and wish to discover the corresponding address. These uri values are vendor-dependent and you will need to get an API key from the appropriate vendor and assign its value to the key parameter in this address.

The other key is ```default_geocoder``` and the associated value needs to be one of the names of the entries in the geocoders array.


~~~{json}
	"geocoder": {
		"default_geocoder": "nominatim",
		"geocoders": [{
			"name": "nominatim",
			"reverse_geocode_url": "https://nominatim.openstreetmap.org/reverse",
			"geocode_url": "https://nominatim.openstreetmap.org/search?format=json"
		}, {
			"name": "google",
			"geocode_url": "https://maps.googleapis.com/maps/api/geocode/json?sensor=false&key=my_google_key"
		}, {
			"name": "opencage",
			"geocode_url": "https://api.opencagedata.com/geocode/v1/json?key=my_opencage_keyd&pretty=1&q="
		}]
	}
~~~

### Lucene

[Lucene Core](https://lucene.apache.org/) is a Java library providing powerful indexing and search features, as well as spellchecking, hit highlighting and advanced analysis/tokenization capabilities.
Grassroots comes with its own [Lucene-based Java library](https://github.com/TGAC/grassroots-lucene) along with the c-based code to access this.
The configuration for the this is part of the global configuration file and is stored using the ```lucene``` key.

 * **classpath**: This is the classpath for all of the Lucene jar files, along with other support libraries, that Grassroots requires to use its Lucene-based libraries.
 * **index**: This is the path to the directory where the Lucene index files will be stored.
 * **taxonomy**: This is the path to the directory where the Lucene taxonomy files will be stored.
 * **search_class**: This is the class that will be ran to perform searches. The current default is ```uk.ac.earlham.grassroots.app.lucene.Searcher```.
 * **index_class**: This is the class that will be ran to index data. The current default is ```uk.ac.earlham.grassroots.app.lucene.Indexer```.
 * **working_directory**: This is  the path to the directory which will be used as temporary folder when 
 running indexing and searching tasks.
 * **facet_key**: One of the features of Lucene is the ability to separate data into different types or facets. 
 This key specifies the iniernal key that Grasssroots uses to store its faceting data and should be left at its default of ```facet_type```.
 
~~~{json}
		"classpath": "/home/billy/Applications/lucene/analysis/common/lucene-analyzers-common-8.11.0.jar:/home/billy/Applications/lucene/core/lucene-core-8.11.0.jar:/home/billy/Applications/lucene/facet/lucene-facet-8.11.0.jar:/home/billy/Applications/lucene/queryparser/lucene-queryparser-8.11.0.jar:/home/billy/Applications/lucene/backward-codecs/lucene-backward-codecs-8.11.0.jar:/home/billy/Applications/lucene/highlighter/lucene-highlighter-8.11.0.jar:/home/billy/Applications/lucene/queries/lucene-queries-8.11.0.jar:/home/billy/Applications/lucene/memory/lucene-memory-8.11.0.jar:/home/billy/Applications/grassroots/lucene/lib/grassroots-search-core-0.1.jar:/home/billy/Applications/grassroots/lucene/lib/grassroots-search-lucene-app-0.1.jar:/home/billy/Applications/grassroots/lucene/lib/json-simple-1.1.1.jar",
		"index": "/home/billy/Applications/grassroots/lucene/index",
		"taxonomy": "/home/billy/Applications/grassroots/lucene/tax/",
		"search_class": "uk.ac.earlham.grassroots.app.lucene.Searcher",
		"index_class": "uk.ac.earlham.grassroots.app.lucene.Indexer",
		"working_directory": "/home/billy/Applications/grassroots/working_directory/lucene",
		"facet_key": "facet_type"
~~~

## Example configuration file

A full example configuration file is given below:

~~~{json}
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
			"geocode_url": "https://maps.googleapis.com/maps/api/geocode/json?sensor=false&key=my_google_key"
		}, {
			"name": "opencage",
			"geocode_url": "https://api.opencagedata.com/geocode/v1/json?key=my_opencage_keyd&pretty=1&q="
		}]
	},
	"lucene": {
		"classpath": "/home/billy/Applications/lucene/analysis/common/lucene-analyzers-common-8.11.0.jar:/home/billy/Applications/lucene/core/lucene-core-8.11.0.jar:/home/billy/Applications/lucene/facet/lucene-facet-8.11.0.jar:/home/billy/Applications/lucene/queryparser/lucene-queryparser-8.11.0.jar:/home/billy/Applications/lucene/backward-codecs/lucene-backward-codecs-8.11.0.jar:/home/billy/Applications/lucene/highlighter/lucene-highlighter-8.11.0.jar:/home/billy/Applications/lucene/queries/lucene-queries-8.11.0.jar:/home/billy/Applications/lucene/memory/lucene-memory-8.11.0.jar:/home/billy/Applications/grassroots/lucene/lib/grassroots-search-core-0.1.jar:/home/billy/Applications/grassroots/lucene/lib/grassroots-search-lucene-app-0.1.jar:/home/billy/Applications/grassroots/lucene/lib/json-simple-1.1.1.jar",
		"index": "/home/billy/Applications/grassroots/lucene/index",
		"taxonomy": "/home/billy/Applications/grassroots/lucene/tax/",
		"search_class": "uk.ac.earlham.grassroots.app.lucene.Searcher",
		"index_class": "uk.ac.earlham.grassroots.app.lucene.Indexer",
		"working_directory": "/home/billy/Applications/grassroots/working_directory/lucene",
		"facet_key": "facet_type"
	}
}

~~~
