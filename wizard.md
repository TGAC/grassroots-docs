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
sudo apt install gcc wget automake unzip flex make git cmake zlib1g-dev g++ libzstd-dev libssl-dev
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


## Lucene and Solr

Throughout Grassroots, we try to make as much data and as many of the services as searchable as 
possible to ensure that we follow the FAIR data principles. At the time of writing the latest 
version of Lucene is 9.8.0 and for Solr is 9.4.0 so the following instructions use these 
versions. If you wish to use other versions, that should be ok though.


```
wget https://dlcdn.apache.org/lucene/java/9.8.0/lucene-9.8.0.tgz
wget https://www.apache.org/dyn/closer.lua/solr/solr/9.4.0/solr-9.4.0.tgz?action=download -O solr-9.4.0.tgz
```

Since these are pre-built java applications, we don't need to build these and can simply install
them using the following commands

```
tar zxf lucene-9.8.0.tgz 
mv lucene-9.8.0 ~/Applications/lucene
tar zxf solr-9.4.0.tgz 
mv solr-9.4.0 ~/Applications/solr
``` 

which gives us both of these installed within the `~/Applications` folder


```
$ ls ~/Applications/lucene/
CHANGES.txt               README.md               modules
JRE_VERSION_MIGRATION.md  SYSTEM_REQUIREMENTS.md  modules-test-framework
LICENSE.txt               bin                     modules-thirdparty
MIGRATE.md                docs
NOTICE.txt                licenses

$ ls ~/Applications/solr
CHANGES.txt  NOTICE.txt  bin     docs     lib       modules              server
LICENSE.txt  README.txt  docker  example  licenses  prometheus-exporter
```


