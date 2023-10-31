# Federated servers

Grassroots servers can be federated together so that users logging into any of these will see the combined list of services from all of the different servers. 
This is configured within the `servers` object within in the Grassroots core configuration file. 
This is an array of entries, each of which specify a Grassroots server to federate with.
Each of these entries require the following keys:

  * **server_name**: The name of the Grassroots system to connect to. This should match the `so:name` value from its `Provider` object.
  * **server_uri**: The web address of the Grassroots system to connect to.
 
As well as these, individual services can be federated together. 
For example [Grassroots BLAST services](https://github.com/TGAC/grassroots-service-blast) can be paired
so that all of the available databases appear upon a single page so that from a user's point of view,
they are all available in a single place. 
These are specified in an array called `paired_services`. 
Each entry in this array require two bits of inormation, one to specify the service running on this Grassroots, using the `local` key and the other to specify the service running on the remote federated Grassroots server, specified using the `remote` key

For example to federate two servers; _https://grassroots.one_, our local server, and _https://grassroots.two_, the remote server, the configuration would be


~~~{json}
  "servers": [{
		"server_name": "Grassroots Two server",
		"server_url": "https://grassroots.two"
  }]
~~~

If you wished to pair a service called *Foo* running on https://grassroots.one and *Bar* running on https://grassroots.two, along with BlastN running on each server, then the configuration would become


~~~{json}
"servers": [{
	"server_name": "Grassroots Two server",
	"server_url": "https://grassroots.two",
	"paired_services": [{
		"local": "Foo",
		"remote": "Bar"
	}, {
		"local": "BlastN",
		"remote": "BlastN"	
	}]
}]
~~~
