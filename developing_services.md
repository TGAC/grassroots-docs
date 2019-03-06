# Developing Services {#developing_services_guide}


## Developing C/C++-based services within httpd

Services built in C/C++-based are shared libraries that only require 2 exported functions; one to get the available Services and one to release them. 

~~~{.c}
/* For standalone services ... */
ServicesArray *GetServices (UserDetails *user_p);

/* ... or for referred services */
ServicesArray *GetReferenceServices (UserDetails *user_p, const json_t *referred_service_config_p);

/* For all services */
void ReleaseServices (ServicesArray *services_p);
~~~

```GetServices()```/```GetReferenceServices()```, gets an array detailing all of the operations that this Service can perform. Most commonly the ServicesArray will contain a single Service, though it can have more if appropriate. The second function, ```ReleaseServices()``` is used when these operations go out of scope. 
Effectively these 2 functions are a constructor/destructor pair for a given ServicesArray. 

So depending upon whether you are developing a specific Service or a reusable one for use by Referred Services you would choose the appropriate pair of functions.


## Examples

So there are three ways of developing Services:
	
 * A standalone Service.
 * A reusable Service which use separate reference files.
 * A reference file that uses an already existing reusable Service.

We will now go through an example for each of these scenarios.


### Standalone Service


### Reusable Service

For a reusable Service the two entry points that are required are:

~~~{.c}
/* Get referred services */
ServicesArray *GetServices (UserDetails *user_p, const json_t *referred_service_config_p);

/* For all services */
void ReleaseServices (ServicesArray *services_p);
~~~ 


