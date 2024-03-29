﻿Service Configuration 
=======

Each Service upon a Grassroots Server can have a separate configuration file that allows the Server administrator to change certain features of a Service. 
These configuration files are placed in a separate directory where the names match the names of the Service.  
By default this is `config` directory within the Grassroots root directory though this can be changed using the `GrassrootsServicesConfigPath` directive in the Apache configuration file with more details available in the [Grassroots Apache module](servers/apache-server.md) documentation.  
For instance, for an example Service called *Foobar Search Service* the configuration file would be `config/Foobar Search service`. 
Any changes made within these files are set immediately and reflected by any subsequent requests to the Grassroots Server without any need to restart the application.
Each Service will have specific values that can be put in this configuration file. Alongside all of these, any Parameters and ParameterGroups can be adjusted too. 
The properties in these sections are described in the [schema guide](schema.md).

## Parameter Groups

The ParameterGroup structure is used to make logical groupings of Parameters to make more sense for users. 
Any Service can configure these by using the **groups** key.

### Visibility

The default visibility of a ParameterGroup can be toggled by a boolean key called **visible**. For example if a Service has two ParameterGroups, *Input/Output* and *Settings* and you wished to set the first group to be visible and the second to be hidden, then the configuration snippet would be:

~~~.json
{
	...
	"groups": {
		"Input/Output": {
			"visible": true		
		},
		"Settings": {
			"visible": false		
		}
	}
	...
}
~~~

## Parameters

Various settings for a Service's Parameters can be configured within our configuration file using the **parameters** key. Within this key, each Parameter can be configured by using its **param** value as a key. The following options will be demonstrated by using the [example Reference Service](services.md#reference-service) specified elsewhere which is

~~~{.json}
{
	"schema_version": 0.1,
	"provider": {
		"name": "Foobar",
 		"description": "A company specializing in wheat research",
 		"uri": "http://foobar.com"
	},
	"services": {
		"path": "Foobar Search service",
		"summary": "A service to data mine wheat articles",
		"description": "A service to search for wheat research articles.",
		"plugin": "web_search_service",
		"operations": [{
			"operation_id": "Foobar Search service",
			"summary": "An operation to search for matching articles",
			"description": "An operation to search for matching articles",
			"uri": "http://foobar.com/search",
			"method": "GET",
			"parameter_set": {
				"parameters": [{
					"param": "query",
					"name": "Query",
					"default_value": "",
					"current_value": "",
					"type": "string",
					"grassroots_type": "params:keyword",
					"description": "The search term"
				}, {
					"param": "size",
					"name": "Number of hits",
					"default_value": "20",
					"current_value": "20",
					"type": "number",
					"grassroots_type": "params:unsigned_integer",
					"description": "The number of hits to return"
				}]
			}
		}]		
	}
}
~~~

### Display name

The display name is the user-friendly name for the Parameter that the user will see and this can be changed using the **name** key. 
For example, taking the Parameters from our example Service listed above we can set the display name of the *query* Parameter to *search term* by having the following section in the configuration file:

~~~.json
{
	...
	"parameters": [{
		"query": {
			"name": "search term"
			}
		}
	}
	...
}
~~~

### Description

The description of the Parameter can be changed using the **description** key. 
Continuing the example started above, to change the description to *A keyword or phrase to search for*, snippet in the configuration file would become:

~~~.json
{
	...
	"parameters": [{
		"query": {
			"name": "search term",
			"description": "A keyword or phrase to search for"
			}
		}
	}
	...
}
~~~

### Default value

The default value for a Parameter can be changed using the **default\_value** key. 
So to change the default number of hits returned by the example Service, specified by the *size* Parameter to 10, the snippet would now look like:

~~~.json
{
	...
	"parameters": [{
		"query": {
			"name": "search term",
			"description": "A keyword or phrase to search for"
			}
		},
		"size": {
			"default_value": 10
		}
	}
	...
}
~~~

### Level

The level for a Parameter can be changed using the **level** key. If we wanted to set the level of the *size* Parameter in our example to *advanced* then the snippet becomes:

~~~.json
{
	...
	"parameters": [{
		"query": {
			"name": "search term",
			"description": "A keyword or phrase to search for"
			}
		},
		"size": {
			"default_value": 10,
			"level": "advanced"
		}
	}
	...
}
~~~
