# Grassroots {#contents_guide}

The Grassroots Infrastructure project aims to create an easily-deployable suite of computing middleware tools to help users and developers gain access to scientific data infrastructure that can easily be interconnected.

With the data-generative approaches that are increasingly common in modern life science research, it is vital that the data and metadata produced by these efforts can be shared and reused. The Grassroots Infrastructure project wraps up industry-standard software tools with a consistent API that can be federated on a number of levels. This means institutions and groups can deploy a simple lightweight virtual machine, expose local data, connect up any existing data services, and federate their instance of the Grassroots with others out-of-the-box.

The Grassroots Infrastructure uses a controlled vocabulary of JSON messages to communicate, so any server or client that can understand JSON can be used to access and connect to the platform. We provide infrastructure to ensure that the scientific data remains the important factor, and not the worry about how to build a system to expose your data.


## Introduction

* @ref introduction_guide

## Administrators

* @ref installation_guide
* @ref admin_guide
* @ref server_configuration_guide
* @ref service_configuration_guide

### Services

* @ref services_guide
 * @ref blast_services_guide
 * @ref ensembl_service_guide
 * @ref example_service_guide
 * @ref irods_search_service_guide
 * @ref polymarker_service_guide
 * @ref samtools_service_guide
 * @ref pathogenomics_service_guide 

### Servers

* @ref apache_server_guide
* @ref mongodb_jobs_manager_guide

## Users 

* @ref user_guide

## Developers

* @ref dev_guide

* Core libraries
 * @ref parameters_guide
 * @ref task_library_guide
 * @ref irods_library_guide
 * @ref server_library_guide
 * @ref mongodb_library_guide
 * @ref clients_guide
* Extra libraries
 * @ref geocoder_guide

### Service development

* @ref linked_services_guide
* @ref async_services_guide
* @ref service_response_guide
* @ref schema_guide

### Handlers

* @ref handlers_guide
 * @ref dropbox_handler_guide
 * @ref file_handler_guide
 * @ref http_handler_guide
 * @ref irods_handler_guide
