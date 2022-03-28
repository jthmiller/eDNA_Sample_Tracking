

server <- function(input, output){

    sample_lookup_server(input, output)

    sample_collection_server(input, output)

    sample_extraction_server(input, output)

    sample_amp_server(input, output)

    sample_sequencing_server(input, output)
}