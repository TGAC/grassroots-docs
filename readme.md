# Introduction 

Broadly speaking, the Grassroots infrastructure is a lightweight architecture to share both distributed data and services across multiple servers. 

Grassroots consists of a schema of how to access, query, and interact with other Grassroots servers and a set of computing tools to allow users and developers to perform many scientific tasks as easily as possible. 

The infrastructure is accessible via a standard web connection and all data interchange is represented through [JSON](http://json.org/) messages. Hence any server or client that can understand these JSON messages can be used to interact and integrate with Grassroots. For example, you can use a web browser or the included Qt-based desktop client to access all of the functionality of the system. The scientific data is what is important, not the user's choice of tool to access the system.

 Grassroots servers can be linked together, or *federated*, allowing the functionality of both to be made automatically available to users without having to perform any additional installation. 
This concept of federation and decentralisation is core to the Grassroots effort, making Grassroots instances "wrappers" or complementary infrastructure to existing data resources. 
Servers, Services and Clients are all interface specifications in that they declare an Application Programming Interface (API) that needs to be implemented. 
All JSON-based Server-Server and Server-Client communication specifications are described in the [Schema guide](@ref schema_guide). 
Grassroots currently runs on Linux, MacOS and Windows.


## Architecture

Grassroots consists of a set of interconnected components which are all available on Github.
Some of the highlights are:

* [Build tools](https://github.com/TGAC/grassroots-build-tools): This provides the tools and
scripts to make the building of all of the various components as easy as possible.

* [Core server module](https://github.com/TGAC/grassroots-core): The core package provides
the architectural implementation of the various datatypes of the Grassroots infrastructure,
such as services, parameters, *etc.* along with lots of code for dealing with common tasks
such as handling JSON, connecting to databases, networking, *etc.* amongst others.

* [Apache integration module](https://github.com/TGAC/grassroots-server-apache-httpd):
Instead of trying to deal with all of the low-level networking, Grassroots takes advantage
of the modular nature of the [Apache httpd server](http://httpd.apache.org) web server by having a module that acts as a bridge between the Apache web server and the Grassroots Infrastructure. 
This allows all of the security and configuration functionality of Apache to
be available for Grassroots.

* [Services](https://github.com/TGAC/?q=grassroots-service)
The scientific functionality of the Grassroots is provided by *services*. 
These can use the core functionality and are self-contained and fully self-describing libraries. 
The core system has no prior knowledge of what a particular service may do. 
Instead it uses standard API calls to query the service for its name, description, parameters, *etc.* 
The configuration for each service is loaded for each relevant incoming request, meaning that the Apache server does not need to be restarted 
for any changes in service configuration to take effect. 

* [Lucene-based searching](https://github.com/TGAC/grassroots-lucene): [Lucene](https://lucene.apache.org/) is a Java library which provides excellent indexing and search features allowing for functionality such as hit highlighting and faceting.
It is used to provide the functionality of the Grassroots search service and the indexing of all services and associated content.

* [Clients](https://github.com/TGAC/?q=grassroots-client): These are implementations that can interact with the service and core server modules to provide interfaces for end users. 
The most fully-featured of these is the [Django]()-based implementation which also features
customised interfaces for specific services which is 
available [here](https://github.com/TGAC/grassroots_services_django_web).
There is also a [Qt]()-based desktop application that runs on Windows, MacOS and Linux available
[here](https://github.com/TGAC/grassroots-client-qt-desktop). 

* [Filesystem handlers](https://github.com/TGAC/?q=grassroots-handler): These provide functionality to access local, remote, and data grid resources for data storage and interoperability by abstraction.

* [Job tracker](https://github.com/TGAC/grassroots-job-tracker): Any services that carry out analytical or processing tasks can be registered with a Django pipeline monitoring tool to let users keep track of running jobs or retrieve results from completed service processes


A list of all of the available components and their documentation is available [here](). 