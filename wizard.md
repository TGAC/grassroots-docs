# How to set up a Grassroots server 


This is a guide to building and setting up a Grassroots server from first principles. This is on
a Ubuntu 22.04 system but the principles should reamin the same for any Unix-based system. We 
are going to set up a system with a demo field trials database.
There are various components that we need to set up, these are:

 * An Apache httpd server
 * A MongoDB server 
 * The 3rd party libraries that Grassroots uses
 * Grassroots core backend components
 * The Grassroots field trials service
 * The Django-based Grassroots frontend
 
Our planned layout will be 

 * /home/\<YOUR USER NAME\>/Projects/grassroots: where we will checkout the source for the Grassroots components
 * /home/\<YOUR USER NAME\>/Applications/grassroots: where the Grassroots components will be installed to
 * /home/\<YOUR USER NAME\>/Applications/apache: where the Apache server will be installed
 * /home/\<YOUR USER NAME\>/Applications/mongodb: where MongoDB will be installed

where *YOUR USER NAME* will depend on your set up. This set up is used for 
our demo server with the [list of services](https://grassroots.tools/demo/service/)
and [field trials](https://grassroots.tools/demo/fieldtrial/all). 

If you wish to, you can download all of the 
[code](https://grassroots.tools/demo/downloads/grassroots_source.tar.gz) 
and [programs](https://grassroots.tools/demo/downloads/grassroots_demo_files.tar.gz).



To begin with, we need to install some required development tools and libraries.

```
sudo apt install default-jdk libcurl4-openssl-dev gcc wget automake unzip bzip2 flex make git cmake zlib1g-dev g++ libzstd-dev libssl-dev
```

With these installed we can now proceed to install each of the components in turn


## Apache httpd


The httpd server requires [pcre](https://downloads.sourceforge.net/project/pcre/pcre/8.45/pcre-8.45.tar.gz) 
which you can download and install using the following instructions

```
wget https://downloads.sourceforge.net/project/pcre/pcre/8.45/pcre-8.45.tar.gz
tar zxf pcre-8.45.tar.gz
cd pcre-8.45
./configure --prefix=/home/<YOUR USER NAME>/Applications/pcre
make
make install
```

Once completed, pcre should be installed and can be checked by listing the contents of 
`~/Applications/pcre`

```
$ ls ~/Applications/pcre

bin  include  lib  share
```


Now that pcre is installed we can proceed to install the httpd server. At the time of writing, the latest version of Apache is 2.4.57 but the instructions should 
remain valid for other 2.4.x versions. You could use the os packages to install Apache but for 
this example and keeping everything self-contained, we will build Apache ourselves.
 
We need to install an additional package that httpd uses called ```libexpat1-dev``` which 
can be done with the following command

```
sudo apt-get install libexpat1-dev
```

Now we are going to need the required Apache components

 * [httpd](https://dlcdn.apache.org/httpd/httpd-2.4.57.tar.gz) 
 * [apr](https://dlcdn.apache.org//apr/apr-1.7.4.tar.gz)
 * [apr-util](https://dlcdn.apache.org//apr/apr-util-1.6.3.tar.gz)

These can be downloaded and unpacked using the following commands

```
cd Downloads/
wget https://dlcdn.apache.org/httpd/httpd-2.4.57.tar.gz
wget https://dlcdn.apache.org//apr/apr-1.7.4.tar.gz
wget https://dlcdn.apache.org//apr/apr-util-1.6.3.tar.gz
tar zxf apr-util-1.6.3.tar.gz 
tar zxf apr-1.7.4.tar.gz 
tar zxf httpd-2.4.57.tar.gz 
```

We now need to put the apr libraries into the correct place within the httpd source tree, which 
is done with the next commands

```
mv apr-1.7.4 httpd-2.4.57/srclib/apr
mv apr-util-1.6.3 httpd-2.4.57/srclib/apr-util
```

So we should now have the following httpd directory

```
$ ls httpd-2.4.57
ABOUT_APACHE     InstallBin.dsp  README.CHANGES    build            httpd.dep     modules
Apache-apr2.dsw  LAYOUT          README.cmake      buildconf        httpd.dsp     os
Apache.dsw       LICENSE         README.platforms  changes-entries  httpd.mak     server
BuildAll.dsp     Makefile.in     ROADMAP           config.layout    httpd.spec    srclib
BuildBin.dsp     Makefile.win    VERSIONING        configure        include       support
CHANGES          NOTICE          acinclude.m4      configure.in     libhttpd.dep  test
CMakeLists.txt   NWGNUmakefile   ap.d              docs             libhttpd.dsp
INSTALL          README          apache_probes.d   emacs-style      libhttpd.mak

$ ls httpd-2.4.57/srclib/
Makefile.in  apr  apr-util
```

We can now proceed to build httpd

```
cd httpd-2.4.57
./configure --prefix=/home/<YOUR USER NAME>/Applications/apache --with-included-apr --with-pcre=/home/<YOUR USER NAME>/Applications/pcre/bin/pcre-config
make
make install
```

This should now give us a basic httpd installation within our `~/Applications` folder

```
$ ls ~/Applications/apache
bin  build  cgi-bin  conf  error  htdocs  icons  include  lib  logs  man  manual  modules
```

## MongoDB

Grassroots supports various databases such as sqlite and MongoDB. The default one is MongoDB so we 
will now install that into `~/Applications/mongodb`. 
At the time of writing the current version is 7.0.2 so the following instructions to download 
and install MongoDB use that.


```
wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu2204-7.0.2.tgz
tar zxf mongodb-linux-x86_64-ubuntu2204-7.0.2.tgz 
wget https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu2204-x86_64-100.8.0.tgz
tar zxf mongodb-database-tools-ubuntu2204-x86_64-100.8.0.tgz 
cp -r mongodb-database-tools-ubuntu2204-x86_64-100.8.0/* ~/Applications/mongodb/
cp -r mongodb-linux-x86_64-ubuntu2204-7.0.2/* ~/Applications/mongodb/
mkdir ~/Applications/mongodb/dbs
```

which will install MongoDB 

```
$ ls ~/Applications/mongodb/
LICENSE-Community.txt  MPL-2   README.md            bin
LICENSE.md             README  THIRD-PARTY-NOTICES  dbs
```

We then need to start the MongoDB server 

```
cd ~/Applications/mongodb
bin/mongod -dbpath dbs
```


## Grassroots

We can now proceed to build the Grassroots code. We will do this inside a folder
within a `~/Projects/grassroots` folder 

```
mkdir ~/Projects/grassroots
cd ~/Projects/grassroots
git clone https://github.com/TGAC/grassroots-build-tools.git build-config
git clone https://github.com/TGAC/grassroots-core.git core
git clone https://github.com/TGAC/grassroots-lucene.git lucene
mkdir clients
mkdir handlers
mkdir libs
git clone https://github.com/TGAC/grassroots-geocoder.git geocoder
git clone https://github.com/TGAC/grassroots-frictionless-data.git frictionless-data
mkdir servers
mkdir services
git clone https://github.com/TGAC/grassroots-service-field-trial.git field-trials
cd servers
git clone https://github.com/TGAC/grassroots-server-apache-httpd.git httpd-server
git clone https://github.com/TGAC/grassroots-jobs-manager-mongodb.git mongodb-jobs-manager
git clone https://github.com/TGAC/grassroots-simple-servers-manager.git simple-servers-manager
``` 

### Extra dependencies

We have a final set of dependencies to install which we can do via an automated script
 which is `install_dependencies` which is located in the `build-config/unix/linux` folder 

The first few lines of this file are 

```
#!/bin/bash

# Edit this to specify where we will install these libraries
GRASSROOTS_EXTRAS_INSTALL_PATH=/opt/grassroots/extras
```

and we need to change this to install all of the files in `~/Applications/grassroots/extras`
instead. To do this we need to edit this file and edit the line specifying
the `GRASSROOTS_EXTRAS_INSTALL_PATH` to point to our desired location. So using
your editor of choice, edit this line so it becomes

```
GRASSROOTS_EXTRAS_INSTALL_PATH=/home/<YOUR USER NAME>/Applications/grassroots/extras
```


### Configuring the build of the Grassroots Lucene code

Throughout Grassroots, we try to make as much data and as many of the services as searchable as 
possible to ensure that we follow the FAIR data principles. This is done by using 
[Lucene](https://lucene.apache.org/). Both Lucene and [Solr](https://solr.apache.org/)
were installed by the `install_dependencies` script that we ran earlier so 
now we need to configure our source to use these. This is done within the 
`~/Projects/grassroots/lucene/` folder. We need to create and edit a file 
called `grassroots-lucene.properties` to do this. We can start by making a 
copy of the example file.


```
cp example-grassroots-lucene.properties grassroots-lucene.properties
```

and the content of this is shown below

```
# The version of lucene installed
lucene.version=8.1.1

# The version of solr installed
solr.version=8.1.1

# The directory where lucene is installed 
lucene.dir=/home/billy/Applications/lucene

# The directory where solr is installed
solr.dir=/home/billy/Applications/solr

# The directory where the grassroots lucene jars, index and taxonomy are installed
install.dir=/home/billy/Applications/grassroots/grassroots/lucene
```
+-
We need to change this to match the versions we installed which means that
the file should become something similar to

```
# The version of lucene installed
lucene.version=9.8.0
cp ~/Projects/grassroots/lucene/lib/*.jar ~/Applications/grassroots/extras/lucene/lib/
# The version of solr installed
solr.version=9.4.0

# The directory where lucene is installed 
lucene.dir=/home/<YOUR USER NAME>/Applications/grassroots/extras/lucene

# The directory where solr is installed
solr.dir=/home/<YOUR USER NAME>/Applications/grassroots/extras/solr

# The directory where the grassroots lucene jars, index and taxonomy are installed
install.dir=/home/<YOUR USER NAME>/Applications/grassroots/lucene
```


The final things we need to do are copy the required dependencies for our Lucene code

```
cp ~/Projects/grassroots/lucene/lib/*.jar ~/Applications/grassroots/lucene/lib/
```

and make the index and taxonomy directories specified in the main core configuration

```
mkdir ~/Applications/grassroots/lucene/index
chmod a+wx ~/Applications/grassroots/lucene/index
mkdir ~/Applications/grassroots/lucene/tax
chmod a+wx ~/Applications/grassroots/lucene/tax
```

### Configuring the build of the field trials service

The field trials service uses the [libexif](https://github.com/libexif/libexif) library which
we previously installed with the `install_dependencies` script that we ran previously. We need
to let this service know the folder where we installed libexif. This is done by creating a 
properties file which specifies this. An example file is part of the field trials directory 
structure `build/unix/linux/example_user.prefs`. We copy this to a file called `linux/user.prefs` 
which we will then edit to specify the location of libexif.


```
cp build/unix/example_user.prefs build/unix/linux/user.prefs
```

The content of this file is shown below

```
#
# field trial dependencies
#
# Set this to where you have the libexif directory 
# containing "include" and "lib" subdirectories.
export LIBEXIF_HOME := /opt/libexif
```

and we need to change this to point where libexif is installed which is 
`~/Applications/grassroots/extras/linexif` by changing the variable to 

```
export LIBEXIF_HOME := /home/<YOUR NAME>/Applications/grassroots/extras/libexif
```

with this in place, the field trials service can be built correctly. We also need to make sure 
that the libexif libraries are in the library path when we run httpd, so we need to amend the
`~/Applications/apache/bin/envvars_grassroots` file and add the appropriate line

```
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/<YOUR USER NAME>/Applications/grassroots/extras/libexif/lib
```

prior to the 
```
export LD_LIBRARY_PATH
```

which is at the bottom of the file.


### Building the core

Although each individual component of the Grassroots infrastructure can be built separately, it 
is often easier to build all of the components in one go. Within the `build-config` folder 
are the tools to do this. 

```
cd build-config
make -C unix/linux all
make -C unix/linux install
```


## Configuring Apache httpd for Grassroots

The next step is to configure httpd to use Grassroots for processing 
requests. This is done by editing 
`~/Applications/apache/conf/extra/grassroots.conf`. For our example here
let's say that we want incoming requests to */grassroots/controller* to be
dealt with Grassroots. The way that is is done is to use the standard 
httpd `<LocationMatch>` configuration directive along with the standard
`SetHandler` directive which tells httpd to let Grassroots process the 
request. Along with these there are a number of Grassroots-specific 
directives which are documented in the 
[Grassroots httpd](https://github.com/TGAC/grassroots-server-apache-httpd)
module. For our example set up here though, the only one we need to
set is the `GrassrootsRoot` directive which tells httpd where Grassoots
is installed. 

So the relevant section in the 
`~/Applications/apache/conf/extra/grassroots.conf`
file is

```
#
# Set the uri for the Grassroots infrastructure requests
#
<LocationMatch "/grassroots/controller">
	
	# Let Grassroots handle these requests
	SetHandler grassroots-handler
	
	# The path to the Grassroots root directory 
	GrassrootsRoot /home/billy/Applications/grassroots-0/grassroots
</LocationMatch>
```

and we need to change the `GrassrootsRoot` directive to match where we have
installed Grassroots

```
#
# Set the uri for the Grassroots infrastructure requests
#
<LocationMatch "/grassroots/controller">
	
	# Let Grassroots handle these requests
	SetHandler grassroots-handler
	
	# The path to the Grassroots root directory 
	GrassrootsRoot /home/<YOUR USER NAME>/Applications/grassroots
</LocationMatch>
```

The other httpd configuration change that we need is make the `grassroots.conf.`
loaded when httpd is started. We do this by adding an entry into the 
`~/Applications/apache/conf/httpd.conf` file. If you edit this file and addd


```
# Grassroots
Include conf/extra/grassroots.conf
```

at the bottom then our required configuration file will get loaded.


When running httpd from a folder inside our home directory on Ubuntu 22.04, 
you can get an error message

```
access to / denied (filesystem path '/home/<YOUR USER NAME>/Applications') because search permissions are missing on a component of the path
```

due to insufficient permissions since user's home directories are not 
publically readable as described 
[here](https://askubuntu.com/questions/451922/apache-access-denied-because-search-permissions-are-missing). 
If this happens, then running

```
chmod 755 /home/<YOUR USER NAME>
``` 

should fix the problem.


## Configuring Grassroots

There are two sets of configuration files for Grassroots; a global configuration file and ones
for each of the individual services.

### Global configuration

The global configuration file contains various configuration details that are used by the
core. By default this file is called *grassroots.config* within the Grassroots 
application directory. This can be altered by using the `GrassrootsConfig` 
directive within the httpd configuration file. For our demo, the sample configuration file 
shown below is used. For more information on each of the individual 
parts, please see the configuration guide.

```
{
	"so:url": "https://grassroots.tools/demo",
	"mongodb": {
		"uri": "mongodb://localhost:27017"
	},
	"provider": {
		"@type": "so:Organization",
		"so:name": "EI Grasssroots demo server",
		"so:description": "Earlham Institute's Demonstration Grassroots instance",
		"so:url": "https://grassroots.tools",
		"so:logo": "https://grassroots.tools/images/ei_logo.png"
	},
	"jobs_manager": "mongodb_jobs_manager",
	"servers_manager": "simple_external_servers_manager",
	"mongodb_jobs_manager": {
		"database": "grassroots",
		"collection": "jobs"
	},
	"geocoder": {
		"default_geocoder": "nominatim",
		"geocoders": [{
			"name": "nominatim",
			"reverse_geocode_url": "https://nominatim.openstreetmap.org/reverse",
			"geocode_url": "https://nominatim.openstreetmap.org/search?format=json"
		}]
	},
	"lucene": {
		"classpath": "/home/<YOUR USER NAME>/Applications/grassroots/lucene/lib/json-simple-1.1.1.jar:/home/<YOUR USER NAME>/Applications/grassroots/lucene/lib/grassroots-search-core-0.1.jar:/home/<YOUR USER NAME>/Applications/grassroots/lucene/lib/grassroots-search-lucene-app-0.1.jar:/home/<YOUR USER NAME>/Applications/grassroots/extras/lucene/modules/lucene-analysis-common-9.8.0.jar:/home/<YOUR USER NAME>/Applications/grassroots/extras/lucene/modules/lucene-core-9.8.0.jar:/home/<YOUR USER NAME>/Applications/grassroots/extras/lucene/modules/lucene-queryparser-9.8.0.jar:/home/<YOUR USER NAME>/Applications/grassroots/extras/lucene/modules/lucene-facet-9.8.0.jar:/home/<YOUR USER NAME>/Applications/grassroots/extras/lucene/modules/lucene-queries-9.8.0.jar:/home/<YOUR USER NAME>/Applications/grassroots/extras/lucene/modules/lucene-memory-9.8.0.jar:/home/<YOUR USER NAME>/Applications/grassroots/extras/lucene/modules/lucene-highlighter-9.8.0.jar",
		"index": "/home/<YOUR USER NAME>/Applications/grassroots/lucene/index",
		"taxonomy": "/home/<YOUR USER NAME>/Applications/grassroots/lucene/tax",
		"search_class": "uk.ac.earlham.grassroots.app.lucene.Searcher",
		"index_class": "uk.ac.earlham.grassroots.app.lucene.Indexer",
		"delete_class": "uk.ac.earlham.grassroots.app.lucene.Deleter",
		"working_directory": "/home/<YOUR USER NAME>/Applications/grassroots/working_directory/lucene",
		"facet_key": "facet_type"
	}
}
```

Any changes that are made to this file require the httpd server to 
be restarted to take effect.


### Services configuration

All of the service configuration files are contained within a subfolder of
the main Grassroots installation. By default, this subfolder is called *config*
but as with the global configuration file above, this can be altered using
the httpd `GrassrootsServicesConfigPath` directive. 

Each Service's configuation is contained within a JSON file that has the same name
as the Service. So, for example, in our example the *Search Field Trials* configuration
file will be at `~/Applications/grassroots/config/Search Field Trials`.

Unlike for the global configuration file, any changes to any of the service 
configuration files will automatically be active without the need to 
restart anything.


### Importing demo data

To allow a basic working example, we have created a small database of field trial data that can
be imported into this Grassroots instance. This is available to download from 
`https://grassroots.tools/documentation/dummy_test.zip` and can be installed using the following
commands

```
wget https://grassroots.tools/documentation/dummy_test.zip
unzip dummy_test.zip
~/Applications/mongodb/bin/mongorestore --db demo_field_trials dummy_test
```


## Django frontend


Grassroots also has a [Django](https://www.djangoproject.com/)-based frontend server. To install
it you run the following commands

```
cd ~/Applications/
git clone https://github.com/TGAC/grassroots_services_django_web.git django
cd django
sudo apt install python3-virtualenv
virtualenv -p python3 venv
source venv/bin/activate
pip install -r requirements.txt
```

This has set up the needed Python environment, we now need to configure the variables so 
that this Django installation connects to our Grassroots and httpd installations. These
customisations take place in a separate file which we can set up and edit with

```
cd grassroots_services_django_web
cp example_custom_settings.py custom_settings.py
vim custom_settings.py
```

So the initial configuration variables are 

```
# The filesystem path to where the static files
# that Django uses will be installed
STATIC_ROOT = "/home/billy/Applications/apache/htdocs/static/"

# The web address to access the static files
STATIC_URL = 'http://localhost:2000/static/'

# The web address for the grassroots server to connect to
SERVER_URL = "http://localhost:2000/grassroots/public_backend"

```

for running Django and httpd locally on your machine you may want 
something like

```
# The filesystem path to where the static files
# that Django uses will be installed
STATIC_ROOT = "/home/<YOUR USER NAME>/Applications/apache/htdocs/static/"

# The web address to access the static files
STATIC_URL = 'http://localhost/static/'

# The web address for the grassroots server to connect to
SERVER_URL = "http://localhost/grassroots/controller"

```

The next stage is to edit the `/service/static/scripts/config.js` file.
This contains a single variable such as

```
var root_dir = "/";
```

which specifies the base web address to access the httpd server. The 
default value of */* is correct when running everything on a local machine
or where the grassroots instance is set up to run from the root of the 
httpd htdocs folder. For other set-ups, such as proxied servers, this value 
can be adjusted to match the environemnt. For instance for our demo server
at https://grassroots.tools/demo, this variable has been altered to become

```
var root_dir = "/demo/";
```


Once these variables are set, the next stage is to copy all of the static assets over 
to our httpd server. This is done by activating our virtual environment 

```
source venv/bin/activate
```

and using the *collectstatic* option for the `manage.py` program.

```
python3 manage.py collectstatic
```


To run Django we use the *runserver* option along with which port we would like to use

```
python3 manage.py runserver 8000
```

So if you are running this on your local machine, you can now browse to the 
[services](http://localhost:8000/service) or 
[field trials](http://localhost:8000/fieldtrial/all) parts of the Django interface.

Alternatively you can proxy to these from your httpd server if you wish to keep
the Django server effectively hidden by adding something like

```
LoadModule proxy_module modules/mod_proxy.so
LoadModule proxy_http_module modules/mod_proxy_http.so

# Django proxies
ProxyPass /service http://localhost:8000/service
ProxyPassReverse /service http://localhost:8000/service
ProxyPass /fieldtrial http://localhost:8000/fieldtrial
ProxyPassReverse /fieldtrial http://localhost:8000/fieldtrial
```

to your `~/Applications/apache/conf/extra/grassroots/conf` and restarting 
your httpd server.





 

