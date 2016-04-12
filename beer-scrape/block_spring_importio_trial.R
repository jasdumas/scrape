devtools::install_github("blockspring/blockspring.R")
library('blockspring')

r_beeradvocate_data <- blockspringRunParsed("extract-data-from-url-importio", 
                       list( url = c("http://www.beeradvocate.com/place/list/?start=0&c_id=US&s_id=CT&brewery=Y&sort=name", 
                       "http://www.beeradvocate.com/place/list/?start=20&c_id=US&s_id=CT&brewery=Y&sort=name", 
                       "http://www.beeradvocate.com/place/list/?start=40&c_id=US&s_id=CT&brewery=Y&sort=name") , 
                       include_js = FALSE, text = NULL, maximum_results = 10, 
                       connector_version = "eef0c9b3373c4006bb77b8cf3d4b0a064174395455ebc4c00b8898f53f7599a3b1e5d7b0d80b9feb40f415b204241f8ae1f269ca0da3cbd0eafd917a50b44bde7a237c4cc650b8f6552af37afc9c47df" ), 
                       list("api_key" = "52bb8a43573fced2458ade133a1cc27f"))$params head(r_bloggers_data)