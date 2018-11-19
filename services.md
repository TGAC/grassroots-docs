# Services {#services_guide}

A Service is the component that is used to add some scientific functionality, *i.e.* text mining, scientific analysis, *etc.* to a Grassroots Server. Each Service consists of a number of API entry points that the Grassroots Server hooks into. These are the ability to respond to particular JSON-based queries and entry points for a given programming language. The Services are completely self-describing, the Server has no prior knowledge or need any configuration changes when installing a Service. Simply copy the service module into the services directory and it will be available for use straight away. 

There are three types of Grassroots Services:
	
 * A standalone Service.
 * A reusable Service which use separate reference files.
 * A reference file that uses an already existing reusable Service.


## [Standalone Services](#standalone_services)

Standalone services are those which perform specific-tasks. They can be written in any language and just need to be loadable by the technology of whichever server application that they are running on. Many of the Services that come with the Grassroots system are written in C/C++ and are designed to be used by the Apache httpd server. Some of these Services are:

 * [BLAST Services](@ref blast_services_guide)
 * [Ensembl Service](@ref ensembl_service_guide)
 * [iRODS Search Service](@ref irods_search_service_guide)
 * [Pathogenomics Services](@ref pathogenomics_service_guide)
 * [Polymarker Services](@ref polymarker_service_guide)
 * [SamTools Service](@ref samtools_service_guide)

## Referred Services (#referred_services)

As opposed to the standalone services that are built using a programming language such as C, C++, Java, Python, *etc.*, it is possible to define a Service simply by creating a text file and these are called *Referred Servcies*.

These are Services that use generic modules for their functionality and only differ in their configuration. 
Each configuration is a JSON file that details the parameters and information about the Service. 
There is more information
The Grassroots Infrastructure has examples of these Referred Services that access various existing external web-based searches. The core functionality for this is contained in a Service called *web_search_service* 

