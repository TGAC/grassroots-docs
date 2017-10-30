Schema Examples
===============

## [Requests and Responses](#requests-and-responses)

These are the Server-Server and Server-Client messages that are used to transmit data, job requests and results throughout the Grassroots system. All messages are sent as JSON-based messages and are described in depth in the [Schema gide](@ref schema_guide).

1. A Client queries the Operations that a Server can provide.
An *operation_id* with the value *get_all_services* is the one for asking for all of its possible Operations.
 
 ~~~{.json}
{
  "header": {
    "schema": {
      "major": 0,
      "minor": 10
    }
	}
	"operations": {
		"operation_id": "get_all_services"
	}
}
 ~~~

2. The Server sends its response. In this example, it has 2 Operations: "*Foobar Contig Search service*" and 
"*Foobar Keyword Search service*"
 ~~~.json
{
 "header": {
    "schema": {
      "major": 0,
      "minor": 10
    }
  },
  "services": [
    {
      "service_name": "SamTools service",
      "provider": {
        "name": "grassroots-2",
        "description": "Grassroots 2 running the Grassroots Infrastructure",
        "uri": "https://grassroots.tools"
      },
      "description": "A service using SamTools",
      "operations": {
        "operation_id": "SamTools service",
        "description": "A service using SamTools",
        "parameter_set": {
          "parameters": [
            {
              "param": "input_file",
              "current_value": "Chinese Spring",
              "type": "string",
              "grassroots_type": "xsd:string",
              "level": "all",
              "description": "The available databases",
              "name": "Indexes",
              "default_value": "Chinese Spring",
              "enum": [
                {
                  "description": "Chinese Spring",
                  "value": "/home/ubuntu/Applications/grassroots-0/grassroots/extras/blast/databases/Triticum_aestivum_CS42_TGACv1_all.fa"
                },
                {
                  "description": "Cadenza",
                  "value": "/home/ubuntu/Applications/grassroots-0/grassroots/extras/blast/databases/Triticum_aestivum_Cadenza_EIv1.1.fa"
                },
                {
                  "description": "Kronos",
                  "value": "/home/ubuntu/Applications/grassroots-0/grassroots/extras/blast/databases/Triticum_turgidum_Kronos_EIv1.1.fa"
                },
                {
                  "description": "Paragon",
                  "value": "/home/ubuntu/Applications/grassroots-0/grassroots/extras/blast/databases/Triticum_aestivum_Paragon_EIv1.1.fa"
                },
                {
                  "description": "Robigus",
                  "value": "/home/ubuntu/Applications/grassroots-0/grassroots/extras/blast/databases/Triticum_aestivum_Robigus_EIv1.1.fa"
                },
                {
                  "description": "Claire",
                  "value": "/home/ubuntu/Applications/grassroots-0/grassroots/extras/blast/databases/Triticum_aestivum_Claire_EIv1.1.fa"
                },
                {
                  "description": "CS42 cDna",
                  "value": "/home/ubuntu/Applications/grassroots-0/grassroots/extras/blast/databases/Triticum_aestivum_CS42_TGACv1_scaffold.annotation.gff3.cdna.fa"
                },
                {
                  "description": "CS42 cds",
                  "value": "/home/ubuntu/Applications/grassroots-0/grassroots/extras/blast/databases/Triticum_aestivum_CS42_TGACv1_scaffold.annotation.gff3.cds.fa"
                },
                {
                  "description": "Aegilops tauschii",
                  "value": "/mnt/ngs_data/references/assembly/aegilops_tauschii/GCA_000347335.1/Aegilops_tauschii.GCA_000347335.1.26.dna.genome.fa"
                },
                {
                  "description": "CS42 cDNA",
                  "value": "/mnt/ngs_data/databases/blast/triticum_aestivum/brenchley_CS42/allCdnaFinalAssemblyAllContigs_vs_TREPalle05_notHits_gt100bp"
                },
                {
                  "description": "CS42 5x Liverpool 454 assembly",
                  "value": "/mnt/ngs_data/databases/blast/triticum_aestivum/brenchley_CS42/CS_5xDNA_all"
                },
                {
                  "description": "CS42 orthologous group sub-assemblies",
                  "value": "/mnt/ngs_data/references/assembly/triticum_aestivum/brenchley_CS42/subassemblies_TEcleaned_Hv80Bd75Sb70Os70_30aa_firstBestHit_assembly_ml40_mi99.fa"
                },
                {
                  "description": "WGSCv2.0",
                  "value": "/mnt/ngs_data/references/assembly/triticum_aestivum/IWGSC/v2/IWGSCv2.0.fa"
                },
                {
                  "description": "A-genome progenitor Triticum urartu",
                  "value": "/mnt/ngs_data/references/assembly/triticum_urartu/GCA_000347455.1/Triticum_urartu.GCA_000347455.1.26.dna.genome.fa"
                },
                {
                  "description": "Synthetic W7984",
                  "value": "/mnt/ngs_data/references/assembly/triticum_aestivum/W7984/w7984.meraculous.scaffolds.Mar28_contamination_removed.fa"
                },
                {
                  "description": "Wild winter wheat G3116",
                  "value": "/mnt/ngs_data/references/assembly/triticum_monococcum/spp_aegilopoides/TmG3116_cDNA.fa"
                },
                {
                  "description": "Domesticated spring wheat",
                  "value": "/mnt/ngs_data/references/assembly/triticum_monococcum/spp_monococcum/TmDV92_cDNA.fa"
                },
                {
                  "description": "Barley Golden Promise",
                  "value": "/home/ubuntu/Applications/grassroots-0/grassroots/extras/blast/databases/Hordeum_vulgare_Golden_promise_EIv1.fa"
                }
              ]
            },
            {
              "param": "Scaffold",
              "current_value": "",
              "type": "string",
              "grassroots_type": "xsd:string",
              "level": "all",
              "description": "The name of the scaffold to find",
              "name": "Scaffold name",
              "default_value": ""
            },
            {
              "param": "Scaffold line break index",
              "current_value": 60,
              "type": "integer",
              "grassroots_type": "params:signed_integer",
              "level": "advanced",
              "description": "If this is greater than 0, then add a newline after each block of this many letters",
              "name": "Max Line Length",
              "default_value": 60
            }
          ],
          "groups": []
        },
        "synchronous": true,
        "icon_uri": "https://grassroots.tools/grassroots-test/2/images/Search%20service"
      }
    }
  ]
}
 ~~~
 

3. The user decides to run the "Foobar Contig Search service" with contig_name set to *BC000000100* but not to run the "Foobar Keyword Search service. The Client's request back to the Server would be:
~~~.json
{
	"services": [{
		"service_name": "Foobar Keyword Contig service",
		"start_service": true,
		"parameter_set": {
			"parameters": [{
				"param": "contig_name",
				"current_value": "BC000000100",
				"grassroots_type": "params:keyword"
			}]
		}
	}, {
		"service_name": "Foobar Keyword Search service",
		"start_service": false
	}]
}
~~~

4. The Server can run the requested Operations. In this case, the results are available straight away as the Operations run synchronously.
~~~.json
{
	"service_name": "Foobar Keyword Contig service",
	"status": 3,
	"description": "An operation to obtain contig information using SNP or Contig names",
	"uri": "http://foobar.com/search_by_contig",
	"results": [{
		"protocol": "inline",
		"title": "item title",
		"data": "item data"
	}, {
		"protocol": "http",
		"title": "item title",
		"data": "foobar.com/view_data_online/id1"
	}, {
		"protocol": "inline",
		"title": "item title",
		"data": {
		    "format": "SNP",
		    "custom key": "custom value"
		}
	}]
}
~~~
