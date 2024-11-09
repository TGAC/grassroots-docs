# Grasssroots Field Trials tutorial


## Introduction

The [Grassroots Infrastructure](https://grassroots.tools) is a project to allow the sharing of both data and web services to work upon them in a [FAIR](https://www.go-fair.org/fair-principles/) way.  These can be accessed from web browsers using our user portal, through our mobile app, desktop client, command line or using one of the Application Programming Interfaces (API) that we support/
The data varies from biological sequences through to individual phenotype measurements within field trial experiments.
The services range from wrapping industry standard tools such as BLAST through to custom services _e.g._ dealing with Parental Genotypes of SNP markers. The focus of this lesson though is the service used to store [Field Trial](https://grassroots.tools/fieldtrial/all) data. 
These are experiments that can happen in the field or in a glasshouse where one or more lines of crops are planted, treatments applied and phenotypic measurements taken.

The standards we have produced follow the same concepts as the [Breeding API (BrAPI)](https://brapi.org/) which is a set of community-driven standards to make genotyping, phenotyping and trial data interoperable and reusable.

The top level of the BrAPI hierarchy is a _Programme_ which, initially for us, is the DSW programme. We also store non-DSW data have other Programmes in the system, however our initial focus is on DSW data.

Each Programme can contain one or more _Trials_, which BrAPI defines as the equivalent of an _investigation_ in the [Minimal Information about a Plant Phenotyping Experiment (MIAPPE)](https://www.miappe.org/) standard.

Trials can consist of one or more experiments where seeds are sown and phenotypic information is gathered and each of these is called a _Study_. These contain a wide variety of data, such as weather information, experimental design notes, GPS data, _etc._ and each Study takes place at a _Location_. To add a Study to the system you need to define both the Field Trial that it is part of and the Location where it took place.

For each Study, you can specify the set of phenotypes that will be measured and these are called Measured Phenotype Variables. Each of these consist of unique triples (three distinct pieces of information) that define:

 * A phenotype
 * How it has been measured
 * Which units have been used

When you have specified the phenotypes to use, these are submitted as Plots, along with the details of how the experiment has been laid out in the field. Plots contain various details such as width, length, position in field, phenotypic data, etc.

All of the uploaded data is available in our field trial search portal which allows you to search across all Studies and view individual Studies in more detail.

For further information please take a look at the [Field Trials user guide](https://grassroots.tools/documentation/field_trial/).


# Submitting a Study

In this tutorial we are going to create a Study and upload it into a Grassroots demo server. 
We have various Programmes, Trials, Studies , Locations, _etc._ already in the system so we can use  existing Programmes, Trials and Locations and focus instead on creating a new Study. 
This is done in two parts: Creating a Study and then uploading the Plots information.










