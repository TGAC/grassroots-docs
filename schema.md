# The Grassroots Schema {#schema_guide}

## Schema Introduction 

All of the messages between Servers and Clients use a JSON-based schema. A full example of this is shown below and then each part will get described in turn. There are [Examples](examples.md)

Any message can have a header, much like the \<head\> tag in a web page and although this is optional it is recommended that all messages have one of these. The information contained in it are items such as the version of the Grassroots schema and the incoming request.

Where possible existing standardised ontologies and their terms are used, trying to keep the number of Grassroots-specific terms to a minimum. Various ontologies are currently used and these are shown below:

 Schema | Prefix | Description  
--- | --- | ---
[schema.org](http://schema.org) | so | Schema.org is a collaborative, community activity with a mission to create, maintain, and promote schemas for structured data on the Internet. 
[EDAM Ontology](http://edamontology.org) | eo | EDAM is a comprehensive ontology of well-established, familiar concepts that are prevalent within bioinformatics and computational biology, including types of data and data identifiers, data formats, operations and topics
[Experimental Factor Ontology](http://www.ebi.ac.uk/efo/) | efo |The Experimental Factor Ontology (EFO) provides a systematic description of many experimental variables available in EBI databases, and for external projects such as the NHGRI GWAS catalog 
[Software Ontology](https://www.ebi.ac.uk/ols/ontologies/swo/) | swo  | The Software Ontology (SWO) is a resource for describing software tools, their types, tasks, versions, provenance and data associated.


## Header

Each message can contain a **header** section that stores the details about various features that are not 
necessarily related to running services such as the version of the schema that is being used, datestamps, *etc.* It can currently contain the following elements 

 * **schema**: This specifies the details about the Grassroots schema being used and currently contains
the following keys:
    * **major**: The major revision of the Grassroots schema being used.
    * **minor**: The major revision of the Grassroots schema being used.

So an example specifying that version 0.10 of the Grassroots schema is being used would be:

~~~.json
{
  "header": {
    "schema": {
      "major": 0,
      "minor": 10
    }
  }
}
~~~


##Operations 

The Operations tag is used to make an API call to a Grassroots Server. It contains a single key-value pair.

* **operation** (required): A string which equates to a particular API call for the Operation.

 Value | C variable | Description  
--- | --- | ---
<em>get_all_services</em> | OP_LIST_ALL_SERVICES | Get a list of all of the Services that the Server can offer. 
<em>get_schema_version</em> | OP_GET_SCHEMA_VERSION | Get the SchemaVersion that the Server is using. 
<em>get_interested_services</em> | OP_LIST_INTERESTED_SERVICES | Get a list of the Services that are able to run on a given Resource. 
<em>run_keyword_services</em> | OP_RUN_KEYWORD_SERVICES | Run all of the Services that have Keyword Parameters. 
<em>get_named_service</em> | OP_GET_NAMED_SERVICES | Get list of services matching the given names.
<em>get_service_results</em> | OP_GET_SERVICE_RESULTS | Get results or the status of jobs.
<em>get_resource</em> | OP_GET_RESOURCE | Get a requested Resource from the Server. 
<em>get_server_status</em> | OP_SERVER_STATUS | Get the status of the Grassroots server.
 
 So, for example, the JSON-based request to get a list of all available Services would be:

 ~~~.json
{
	  "header": {
		"schema": {
	      "major": 0,
	      "minor": 10
	    }
	  },
	  "operations": {
	    "operation": "get_all_services"
	  }
}
 ~~~
 


## Example {#schema_example}

~~~{.json}
{
  "@type": "grassroots_service",
  "so:name": "BlastN",
  "so:description": "Search nucleotide databases with nucleotide queries",
  "so:alternateName": "blast-blastn",
  "provider": {
    "@type": "so:Organization",
    "so:name": "EI public",
    "so:description": "EI's public grassroots",
    "so:url": "localhost:8080/info",
    "so:logo": "localhost:8080/grassroots/images/ei_logo.png"
  },
  "category": {
    "application_category": {
      "so:sameAs": "eo:operation_0491",
      "so:name": "Pairwise sequence alignment",
      "so:description": "Methods might perform one-to-one, one-to-many or many-to-many comparisons. Align exactly two molecular sequences."
    },
    "input": [
      {
        "so:sameAs": "eo:data_2977",
        "so:name": "Nucleic acid sequence",
        "so:description": "One or more nucleic acid sequences, possibly with associated annotation."
      }
    ],
    "output": [
      {
        "so:sameAs": "eo:format_1333",
        "so:name": "BLAST results",
        "so:description": "Format of results of a sequence database search using some variant of BLAST. This includes score data, alignment data and summary table."
      }
    ]
  },
  "operation": {
    "parameter_set": {
      "level": "all",
      "parameters": [
        {
          "param": "job_id",
          "current_value": null,
          "default_value": null,
          "min": null,
          "max": null,
          "group": "Query Sequence Parameters",
          "type": "string",
          "grassroots_type": "xsd:string",
          "level": "advanced",
          "so:description": "The UUIDs for Blast jobs that have previously been run",
          "so:name": "Job IDs"
        },
        {
          "param": "query",
          "current_value": null,
          "default_value": null,
          "min": null,
          "max": null,
          "group": "Query Sequence Parameters",
          "type": "string",
          "grassroots_type": "params:fasta",
          "level": "all",
          "so:description": "Query sequence(s) to be used for a BLAST search should be pasted in the 'Search' text area. It accepts a number of different types of input and automatically determines the format or the input. To allow this feature there are certain conventions required with regard to the input of identifiers (e.g., accessions or gi's)",
          "so:name": "Query Sequence(s)",
          "required": true
        },
        {
          "param": "subrange_from",
          "current_value": null,
          "default_value": null,
          "min": null,
          "max": null,
          "group": "Query Sequence Parameters",
          "type": "integer",
          "grassroots_type": "params:unsigned_integer",
          "level": "advanced",
          "so:description": "Coordinates for a subrange of the query sequence. The BLAST search will apply only to the residues in the range. Valid sequence coordinates are from 1 to the sequence length. Set either From or To to 0 to ignore the range. The range includes the residue at the To coordinate.",
          "so:name": "From"
        },
        {
          "param": "subrange_to",
          "current_value": null,
          "default_value": null,
          "min": null,
          "max": null,
          "group": "Query Sequence Parameters",
          "type": "integer",
          "grassroots_type": "params:unsigned_integer",
          "level": "advanced",
          "so:description": "Coordinates for a subrange of the query sequence. The BLAST search will apply only to the residues in the range. Valid sequence coordinates are from 1 to the sequence length. Set either From or To to 0 to ignore the range. The range includes the residue at the To coordinate.",
          "so:name": "To"
        },
        {
          "param": "Available Databases provided by EI public -> Chinese Spring",
          "current_value": true,
          "default_value": true,
          "group": "Available Databases provided by EI public",
          "type": "boolean",
          "grassroots_type": "xsd:boolean",
          "level": "all",
          "so:description": "Chinese Spring",
          "so:name": "Chinese Spring"
        },
        {
          "param": "Available Databases provided by EI public -> Cadenza",
          "current_value": false,
          "default_value": false,
          "group": "Available Databases provided by EI public",
          "type": "boolean",
          "grassroots_type": "xsd:boolean",
          "level": "all",
          "so:description": "620,766 sequences; 13,119,450,886 total bases; Longest sequence: 1,068,450 bases",
          "so:name": "Cadenza"
        },
        {
          "param": "max_target_seqs",
          "current_value": 5,
          "default_value": 5,
          "min": null,
          "max": null,
          "group": "General Algorithm Parameters",
          "type": "integer",
          "grassroots_type": "params:unsigned_integer",
          "level": "advanced",
          "so:description": "Select the maximum number of aligned sequences to display (the actual number of alignments may be greater than this).",
          "so:name": "Max target sequences"
        },
        {
          "param": "evalue",
          "current_value": 10.0,
          "default_value": 10.0,
          "min": null,
          "max": null,
          "group": "General Algorithm Parameters",
          "type": "number",
          "grassroots_type": "params:unsigned_number",
          "level": "advanced",
          "so:description": "Expected number of chance matches in a random model",
          "so:name": "Expect threshold"
        },
        {
          "param": "outfmt",
          "current_value": 19,
          "default_value": 19,
          "min": null,
          "max": null,
          "enum": [
            {
              "so:description": "query-anchored showing identities",
              "value": 1
            },
            {
              "so:description": "query-anchored no identities",
              "value": 2
            },
            {
              "so:description": "flat query-anchored, show identities",
              "value": 3
            },
            {
              "so:description": "flat query-anchored, no identities",
              "value": 4
            },
            {
              "so:description": "XML Blast output",
              "value": 5
            },
            {
              "so:description": "tabular",
              "value": 6
            },
            {
              "so:description": "tabular with comment lines",
              "value": 7
            },
            {
              "so:description": "Text ASN.1",
              "value": 8
            },
            {
              "so:description": "Binary ASN.1",
              "value": 9
            },
            {
              "so:description": "Comma-separated values",
              "value": 10
            },
            {
              "so:description": "BLAST archive format (ASN.1)",
              "value": 11
            },
            {
              "so:description": "JSON Seqalign output",
              "value": 12
            },
            {
              "so:description": "Multiple file JSON Blast output",
              "value": 13
            },
            {
              "so:description": "Multiple file XML2 Blast output",
              "value": 14
            },
            {
              "so:description": "Single file JSON Blast output",
              "value": 15
            },
            {
              "so:description": "Single file XML2 Blast output",
              "value": 16
            },
            {
              "so:description": "Sequence Alignment/Map (SAM)",
              "value": 17
            },
            {
              "so:description": "Organism report",
              "value": 18
            },
            {
              "so:description": "Grassroots markup",
              "value": 19
            },
            {
              "so:description": "paired",
              "value": 20
            }
          ],
          "group": "General Algorithm Parameters",
          "type": "integer",
          "grassroots_type": "params:unsigned_integer",
          "level": "advanced",
          "so:description": "The output format for the results",
          "so:name": "Output format"
        },
        {
          "param": "word_size",
          "current_value": 11,
          "default_value": 11,
          "min": null,
          "max": null,
          "group": "General Algorithm Parameters",
          "type": "integer",
          "grassroots_type": "params:unsigned_integer",
          "level": "advanced",
          "so:description": "Expected number of chance matches in a random model",
          "so:name": "Word size"
        },
        {
          "param": "task",
          "current_value": "megablast",
          "default_value": "megablast",
          "min": null,
          "max": null,
          "enum": [
            {
              "so:description": "megablast: Traditional megablast used to find very similar (e.g., intraspecies or closely related species) sequences",
              "value": "megablast"
            },
            {
              "so:description": "dc-megablast: Discontiguous megablast used to find more distant (e.g., interspecies) sequences",
              "value": "dc-megablast"
            },
            {
              "so:description": "blastn: Traditional BLASTN requiring an exact match of 11",
              "value": "blastn"
            },
            {
              "so:description": "blastn-short: BLASTN program optimized for sequences shorter than 50 bases",
              "value": "blastn-short"
            },
            {
              "so:description": "rmblastn: BLASTN with complexity adjusted scoring and masklevel",
              "value": "rmblastn"
            }
          ],
          "group": "Program Selection Parameters",
          "type": "string",
          "grassroots_type": "xsd:string",
          "level": "advanced",
          "so:description": "The program to use to run the search.",
          "so:name": "Program Selection"
        },
        {
          "param": "reward",
          "current_value": 2,
          "default_value": 2,
          "min": null,
          "max": null,
          "group": "Scoring Parameters",
          "type": "integer",
          "grassroots_type": "params:unsigned_integer",
          "level": "advanced",
          "so:description": "The reward for matching bases",
          "so:name": "Reward"
        },
        {
          "param": "penalty",
          "current_value": -3,
          "default_value": -3,
          "min": null,
          "max": null,
          "group": "Scoring Parameters",
          "type": "integer",
          "grassroots_type": "params:negative_integer",
          "level": "advanced",
          "so:description": "The penalty for mismatching bases",
          "so:name": "Penalty"
        }
      ],
      "groups": [
        {
          "so:name": "Query Sequence Parameters",
          "visible": true,
          "repeatable": false
        },
        {
          "so:name": "Available Databases provided by EI public",
          "visible": true,
          "repeatable": false,
          "level": "all"
        },
        {
          "so:name": "General Algorithm Parameters",
          "visible": false,
          "repeatable": false,
          "level": "advanced"
        },
        {
          "so:name": "Program Selection Parameters",
          "visible": true,
          "repeatable": false,
          "level": "advanced"
        },
        {
          "so:name": "Scoring Parameters",
          "visible": false,
          "repeatable": false,
          "level": "advanced"
        }
      ]
    },
    "synchronous": false,
    "so:image": "http://localhost:8080/grassroots/images/BlastN%20service"
  }
}
~~~

##Operations 

The Operations tag is used to call an API on the Server.

* **operation** (required): A string which equates to a particular API call for the Operation.

 Value | C variable | Description  
--- | --- | ---
<em>get_all_services</em> | OP_LIST_ALL_SERVICES | Get a list of all of the Services that the Server can offer. 
<em>get_schema_version</em> | OP_GET_SCHEMA_VERSION | Get the SchemaVersion that the Server is using. 
<em>get_interested_services</em> | OP_LIST_INTERESTED_SERVICES | Get a list of the Services that are able to run on a given Resource. 
<em>run_keyword_services</em> | OP_RUN_KEYWORD_SERVICES | Run all of the Services that have Keyword Parameters. 
<em>get_named_service</em> | OP_GET_NAMED_SERVICES | Get list of services matching the given names.
<em>get_service_results</em> | OP_GET_SERVICE_RESULTS | Get results or the status of jobs.
<em>get_resource</em> | OP_GET_RESOURCE | Get a requested Resource from the Server. 
<em>get_server_status</em> | OP_SERVER_STATUS | Get the status of the Grassroots server.
 
 So, for example, the JSON-based request to get a list of all available Services is:

 ~~~.json
{
	  "operations": {
	    "operation": "get_all_services"
	  }
}
 ~~~
 
## Service

* **so:name** (required):
The user-friendly name of the Service which will be displayed to the user.

* **so:url**: 
A web address for more information about the Service.

* **so:description** (required): 
A user-friendly description of the Service.

* **synchronous**: 
When an Operation is run, if it is able to execute rapidly it will run to completion before sending the results back. However some Operations can take longer and rather than the block the rest of the system from running, they start running and return straight away. The system can then periodically check these running jobs to determine if they have finished successfully. Setting this variable to false, will declare that the Operation runs in this way. If this value is not set, then it will be assumed to be true and the Operation runs synchronously.

* **operations**:
An array of [Operation](#Operation) objects that the Service can perform.


## [Operation](#operation)

* **operation\_id** (required): The name for the Operation.

* **summary** (required):
 
* **so:description** (required):

* **parameter\_set** (required): The [ParameterSet](#ParameterSet).


## [ParameterSet](#parameterset)

The list of [Parameters](#Parameter) is contained within a **ParameterSet** along with hints on how to group them together to display to the user.

* **parameters**:
This is an array of [Parameter](#Parameter) objects.

* **groups**: 
This is an array of strings listing all of the available groups for this set of Parameters.

## [Parameter](#parameter)

* **so:name**:
The user-friendly name of the parameter for displaying to a user. If this is not set, then the value for the *param* key will be used.

* **param** (required): 
The programmatic name of the parameter. If the *name* is not set, then this value will be used for displaying to the user.

* **so:description** (required): 
The description of the parameter to display to the user.

* **default_value**:
The default value of the parameter.

* **current_value** (required):
The current value of the parameter.

* **type**  (required): This can take one of:
 1. string
 2. number
 3. integer
 4. boolean
 5. array 
     
* **grassroots\_type** (required): 
A number to describe the type of the Parameter. The values, along with their C definition, are shown below:

| C definition | JSON value | Description |
|-------------------|-------------------|-------------------| 
| *PT_BOOLEAN* | xsd:boolean | The variable can be true or false. |
| *PT_SIGNED_INT* | params:signed_integer |The variable is a non-negative integer. |
| *PT_UNSIGNED_INT* | params:unsigned_integer |The variable is an integer. |
| *PT_NEGATIVE_INT* | params:negative_integer | The variable is a negative integer. |
| *PT_SIGNED_REAL* | xsd:double |The variable is a number. |
| *PT_UNSIGNED_REAL* | params:unsigned_number |  The variable is a non-negative number |
| *PT_STRING* | xsd:string | The parameter is a general string. |
| *PT_FILE_TO_WRITE* | params:output_filename | The parameter is the name of an output file. |
| *PT_FILE_TO_READ* | params:input_filename | The parameter is the name of an input file. |
| *PT_DIRECTORY* | params:directory | The parameter is the name of a directory. |
| *PT_CHAR* | params:character |The parameter is a single ASCII character. |
| *PT_PASSWORD* | params:password | The parameter is a password. |
| *PT_KEYWORD* | params:keyword |The parameter is a keyword meaning it will be set of the user chooses to run a keyword search. |
| *PT_LARGE_STRING* | params:large_string |The parameter is a string that can potentially get large in size. This is a hint to the Client to use a multi-line text box as opposed to a single one. |
| *PT_JSON* | params:json |The parameter is a JSON fragment. |
| *PT_TABLE* | params:tabular |The parameter holds tabular data with configurable row and column delimiters. These default to a newline and a comma respectively. |
| *PT_FASTA* | params:fasta |The parameter holds a string of FASTA sequence data. |


* **enum**: 
If the Parameter can take only take one of set of restricted values, these can be specified as an array here.
The elements in this array have two fields:
 * *value*: The programmatic value that the Parameter will be set to.
 * *so:description*: The user-friendly name of the parameter for displaying to a user. If this is not set, then the value for the *value* will be used instead.

 An example of this is: 
 ~~~.json
 "enum": [
      { "so:description": "Use Raw", "value": "z" },
      { "so:description": "Use Zip", "value": "zip" },
      { "so:description": "Use GZip", "value": "gz" }
 ]
 ~~~
 which indicate that the Parameter can take 1 of 3 possible values, "z", "zip" or "gz", and the values to show 
to the user are "Use Raw", "Use Zip" and "Use GZip". 

* **level**:
This is a number used to determine whether to show a Parameter to a user. The system defines 3 levels of Parameter; beginner, intermediate and advanced. The user can then choose which level of variables that they want displayed in their interface of choice. 
The values for the 3 levels are:
 * *beginner*
 * *intermediate*
 * *advanced*
 
If a Parameter is to displayed for all levels, then the level value can be set to **all**.

 These values can be mixed together. For example if you wanted a parameter to be displayed in just the beginner level then you would set this value to "beginner". If you wanted it displayed at the intermediate and advanced level, the value would be "intermediate advanced"
 
* **group**:
If set, this specifies which of the groups listed in the [ParameterSet](#ParameterSet)'s groups that this Parameter belongs to and is detailed in the [ParameterGroup](#ParameterGroup) section below.


## [ParameterGroup](#parametergroup)

A ParameterGroup is a way of classing parameters together in a logical set. For example, a ParameterGroup called *Address* could contain Parameters for a house number, road name and town. 
It is used to give a hint to the user interface to display these parameters together to be more user-friendly.

## Credentials

The Credentials object is used if there is access to some form of restricted content or Services needed.

* **name**:
The name of the handler or authentication provider .

* **url**:
The web address of the authentication provider.

* **key**:
If using OAuth2, this is the client key token.

* **secret**:
If using OAuth2, this is the client secret token.

* **username**:
The encrypted username to use.

* **password**:
The encrypted password to use.

## Provider {#provider_guide}

This is the object that describes the entity or entities that are providing a given Service. Each Service will specify one of of these. Each one of these is an institution hosting a Grassroots server and used the [SchemaOrg Organization](http://schema.org/Organization) type.
If there is a single provider for the given Service then the key used will be **provider** containing the keys listed below. 
If the Service has been [federated] (@ref linked_services_guide) then the key will be **providers** whose value will be an array of objects with the keys listed below.

* **so:name** (required):
The name of the Provider which will be displayed to the user.

* **so:url**: 
A web address for more information about the Provider.

* **so:description** (required): 
A description of the Provider.
 
* **so:logo**:
An image to represent the Provider that will be displayed to users and other federated Servers.

So an example of specifying a single Provider for a Service is:

~~~.json
"provider": {
	"@type": "so:Organization",
	"so:name": "grassroots.tools",
	"so:description": "Grassroots 2.1 running the Grassroots Infrastructure",
	"so:url": "https://grassroots.tools",
	"so:logo": "https://grassroots.tools/images/ei_logo.png"
}
~~~

Whereas multiple providers would be specified using the **providers** key such as:

~~~.json
"providers": [{
	"@type": "so:Organization",
	"so:name": "grassroots.tools",
	"so:description": "Grassroots.tools running the Grassroots Infrastructure",
	"so:url": "https://grassroots.tools",
	"so:logo": "https://grassroots.tools/images/ei_logo.png"
}, {
	"@type": "so:Organization",
	"so:name": "An example Server",
	"so:description": "Grassroots running at another organisation",
	"so:url": "https://another.grassroots.server",
	"so:logo": "https://another.grassroots.server/logo.png"
}]
~~~



## WebService

* **url** (required):
The url to call for this webservice.

* **format**:
How the webservice parameters will be set. This can be one of:
 * *get*: The webservice will be called using a GET request.
 * *post*: The webservice will be called using a POST request.
 * *json*: The webservice will be called using a POST request where the content of the request body is a json fragment.

## [Resource](#resource)

A Resource object describes a location and a piece of data such as a file, url, *etc.*

* **protocol** (required): The class for this Resource which will determine how to access this Resource. These use the Handlers available within the system and the currently available options are:

 * *file*: The Resource is a file or directory.
 * *http*: The Resource is an http-based web address.
 * *https*: The Resource is a secure https-based web address.
 * *irods*: The Resource is an iRODS data object, collection or zone.
 * *dropbox*: The Resource is a path to a Dropbox object. 
 * *inline*: The Resource is the raw data specified in the value field.
 
* **value** (required): The protocol-dependent value of how to access the object.

