﻿# Server Configuration {#server_configuration_guide}


The global Server configuration is specified by a JSON file called *grassroots.config* at the top level of the Grassroots directory.
Unlike the individual [Service configuration](@ref service_configuration_guide) files, any changes in this file require a restart of the Grassroots Server to take effect.

## Options

There are various keys that can be placed in this file described below.

 * **provider**: This key is used to describe this Grassroots system.
  * **name**: The name to use for this Grassroots system.
  * **description**: A description of this Grassroots system to display to the user. 
  * **uri**: The web address of this Grassroots system.
 * **servers**: This is an array of objects that describe other Grassroots Servers to connect to this system.
  * **server_name**: The name of the Grassroots system to connect to.
  * **server_uri**: The web address of the Grassroots system to connect to.
  * **paired_services**: This is an array of objects that describe any Services that are to be amalgamated between the remote Server and this Server.
  		* **local**: The name of the Service on this Grassroots system to amalgamate.
  		* **remote**: The name of the Service on the remote Grassroots system to amalgamate.
 * **mongodb**: This key has the details for any MongoDB server for this Grassroots Server to access. 
  * **uri**:  This specifies the uri of the MongoDB server to access.

~~~{json}
{
	"services": {
		"status": {
			"default": true
		}
	},
	"mongodb": {
		"uri": "mongodb://localhost:27017"
	},
	"provider": {
		"name": "billy home 0",
		"description": "Billy's desktop 0 running the wheatis instance",
		"uri": "localhost:8080/info"
	},
	"servers": [{
		"server_name": "grassroots 1",
		"server_url": "localhost:18080/grassroots",
		"paired_services": [{
			"local": "Blast service",
			"remote": "Blast service"
		}]
	}],
	"jobs_manager": "mongodb_jobs_manager",
	"mongodb_jobs_manager": {
		"database": "grassroots",
		"collection": "jobs"
	},	
	"admin": {
		"jobs": {
			"uri": "https://wheatis.tgac.ac.uk/grassroots-test/job_tracker/rest/update_job/billy%20home%200"
		}
	}
}
~~~
