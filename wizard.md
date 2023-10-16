# How to set up a Grassroots server {#how_to_set_up_server_guide}

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


where *YOUR USER NAME* will depend on your set up.


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

Grassroots supports various databases such as sqld and MongoDB. The default one is MongoDB so we 
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

We need to change this to match the versions we installed which means that
the file should become something similar to

```
# The version of lucene installed
lucene.version=9.8.0

# The version of solr installed
solr.version=9.4.0

# The directory where lucene is installed 
lucene.dir=/home/<YOUR USER NAME>/Applications/grassroots/extras/lucene

# The directory where solr is installed
solr.dir=/home/<YOUR USER NAME>/Applications/grassroots/extras/solr

# The directory where the grassroots lucene jars, index and taxonomy are installed
install.dir=/home/<YOUR USER NAME>/Applications/grassroots/lucene
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

with this in place, the field trials service can be built correctly.


### Building the core

Although each individual component of the Grassroots infrastructure can be built separately, it 
is often easier to build all of the components in one go. Within the `build-config` folder 
are the tools to do this. 

```
cd build-config
make -C unix/linux all
make -C unix/linux install
```

