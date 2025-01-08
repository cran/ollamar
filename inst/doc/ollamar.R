## ----eval=FALSE---------------------------------------------------------------
#  install.packages("ollamar")

## ----eval=FALSE---------------------------------------------------------------
#  # install.packages("remotes")  # run this line if you don't have the remotes library
#  remotes::install_github("hauselin/ollamar")

## ----eval=FALSE---------------------------------------------------------------
#  library(ollamar)
#  
#  test_connection()  # test connection to Ollama server
#  # if you see "Ollama local server not running or wrong server," Ollama app/server isn't running
#  
#  # generate a response/text based on a prompt; returns an httr2 response by default
#  resp <- generate("llama3.1", "tell me a 5-word story")
#  resp
#  
#  #' interpret httr2 response object
#  #' <httr2_response>
#  #' Status: 200 OK  # if successful, status code should be 200 OK
#  #' Content-Type: application/json
#  #' Body: In memory (414 bytes)
#  
#  # get just the text from the response object
#  resp_process(resp, "text")
#  # get the text as a tibble dataframe
#  resp_process(resp, "df")
#  
#  # alternatively, specify the output type when calling the function initially
#  txt <- generate("llama3.1", "tell me a 5-word story", output = "text")
#  
#  # list available models (models you've pulled/downloaded)
#  list_models()
#                          name    size parameter_size quantization_level            modified
#  1               codegemma:7b    5 GB             9B               Q4_0 2024-07-27T23:44:10
#  2            llama3.1:latest  4.7 GB           8.0B               Q4_0 2024-07-31T07:44:33

## ----eval=FALSE---------------------------------------------------------------
#  pull("llama3.1")  # download a model (equivalent bash code: ollama run llama3.1)
#  list_models()  # verify you've pulled/downloaded the model

## ----eval=FALSE---------------------------------------------------------------
#  list_models()  # see the models you've pulled/downloaded
#  delete("all-minilm:latest")  # returns a httr2 response object

## ----eval=FALSE---------------------------------------------------------------
#  resp <- generate("llama3.1", "Tomorrow is a...")  # return httr2 response object by default
#  resp
#  
#  resp_process(resp, "text")  # process the response to return text/vector output
#  
#  generate("llama3.1", "Tomorrow is a...", output = "text")  # directly return text/vector output
#  generate("llama3.1", "Tomorrow is a...", stream = TRUE)  # return httr2 response object and stream output
#  generate("llama3.1", "Tomorrow is a...", output = "df", stream = TRUE)
#  
#  # image prompt
#  # use a vision/multi-modal model
#  generate("benzie/llava-phi-3", "What is in the image?", images = "image.png", output = 'text')

## ----eval=FALSE---------------------------------------------------------------
#  messages <- create_message("what is the capital of australia")  # default role is user
#  resp <- chat("llama3.1", messages)  # default returns httr2 response object
#  resp  # <httr2_response>
#  resp_process(resp, "text")  # process the response to return text/vector output
#  
#  # specify output type when calling the function
#  chat("llama3.1", messages, output = "text")  # text vector
#  chat("llama3.1", messages, output = "df")  # data frame/tibble
#  chat("llama3.1", messages, output = "jsonlist")  # list
#  chat("llama3.1", messages, output = "raw")  # raw string
#  chat("llama3.1", messages, stream = TRUE)  # stream output and return httr2 response object
#  
#  # create chat history
#  messages <- create_messages(
#    create_message("end all your sentences with !!!", role = "system"),
#    create_message("Hello!"),  # default role is user
#    create_message("Hi, how can I help you?!!!", role = "assistant"),
#    create_message("What is the capital of Australia?"),
#    create_message("Canberra!!!", role = "assistant"),
#    create_message("what is your name?")
#  )
#  cat(chat("llama3.1", messages, output = "text"))  # print the formatted output
#  
#  # image prompt
#  messages <- create_message("What is in the image?", images = "image.png")
#  # use a vision/multi-modal model
#  chat("benzie/llava-phi-3", messages, output = "text")

## ----eval=FALSE---------------------------------------------------------------
#  messages <- create_message("Tell me a 1-paragraph story.")
#  
#  # use "llama3.1" model, provide list of messages, return text/vector output, and stream the output
#  chat("llama3.1", messages, output = "text", stream = TRUE)
#  # chat(model = "llama3.1", messages = messages, output = "text", stream = TRUE)  # same as above

## ----eval=FALSE---------------------------------------------------------------
#  list(  # main list containing all the messages
#      list(role = "user", content = "Hello!"),  # first message as a list
#      list(role = "assistant", content = "Hi! How are you?")  # second message as a list
#  )

## ----eval=FALSE---------------------------------------------------------------
#  # create a chat history with one message
#  messages <- create_message(content = "Hi! How are you? (1ST MESSAGE)", role = "assistant")
#  # or simply, messages <- create_message("Hi! How are you?", "assistant")
#  messages[[1]]  # get 1st message
#  
#  # append (add to the end) a new message to the existing messages
#  messages <- append_message("I'm good. How are you? (2ND MESSAGE)", "user", messages)
#  messages[[1]]  # get 1st message
#  messages[[2]]  # get 2nd message (newly added message)
#  
#  # prepend (add to the beginning) a new message to the existing messages
#  messages <- prepend_message("I'm good. How are you? (0TH MESSAGE)", "user", messages)
#  messages[[1]]  # get 0th message (newly added message)
#  messages[[2]]  # get 1st message
#  messages[[3]]  # get 2nd message
#  
#  # insert a new message at a specific index/position (2nd position in the example below)
#  # by default, the message is inserted at the end of the existing messages (position -1 is the end/default)
#  messages <- insert_message("I'm good. How are you? (BETWEEN 0 and 1 MESSAGE)", "user", messages, 2)
#  messages[[1]]  # get 0th message
#  messages[[2]]  # get between 0 and 1 message (newly added message)
#  messages[[3]]  # get 1st message
#  messages[[4]]  # get 2nd message
#  
#  # delete a message at a specific index/position (2nd position in the example below)
#  messages <- delete_message(messages, 2)
#  
#  # create a chat history with multiple messages
#  messages <- create_messages(
#    create_message("You're a knowledgeable tour guide.", role = "system"),
#    create_message("What is the capital of Australia?")  # default role is user
#  )

## ----eval=FALSE---------------------------------------------------------------
#  # create a list of messages
#  messages <- create_messages(
#    create_message("You're a knowledgeable tour guide.", role = "system"),
#    create_message("What is the capital of Australia?")
#  )
#  
#  # convert to dataframe
#  df <- dplyr::bind_rows(messages)  # with dplyr library
#  df <- data.table::rbindlist(messages)  # with data.table library
#  
#  # convert dataframe to list with apply, purrr functions
#  apply(df, 1, as.list)  # convert each row to a list with base R apply
#  purrr::transpose(df)  # with purrr library

## ----eval=FALSE---------------------------------------------------------------
#  embed("llama3.1", "Hello, how are you?")
#  
#  # don't normalize embeddings
#  embed("llama3.1", "Hello, how are you?", normalize = FALSE)

## ----eval=FALSE---------------------------------------------------------------
#  # get embeddings for similar prompts
#  e1 <- embed("llama3.1", "Hello, how are you?")
#  e2 <- embed("llama3.1", "Hi, how are you?")
#  
#  # compute cosine similarity
#  sum(e1 * e2)  # not equals to 1
#  sum(e1 * e1)  # 1 (identical vectors/embeddings)
#  
#  # non-normalized embeddings
#  e3 <- embed("llama3.1", "Hello, how are you?", normalize = FALSE)
#  e4 <- embed("llama3.1", "Hi, how are you?", normalize = FALSE)

## ----eval=FALSE---------------------------------------------------------------
#  resp <- list_models(output = "resp")  # returns a httr2 response object
#  # <httr2_response>
#  # Status: 200 OK
#  # Content-Type: application/json
#  
#  # process the httr2 response object with the resp_process() function
#  resp_process(resp, "df")
#  # or list_models(output = "df")
#  resp_process(resp, "jsonlist")  # list
#  # or list_models(output = "jsonlist")
#  resp_process(resp, "raw")  # raw string
#  # or list_models(output = "raw")
#  resp_process(resp, "resp")  # returns the input httr2 response object
#  # or list_models() or list_models("resp")
#  resp_process(resp, "text")  # text vector
#  # or list_models("text")

## ----eval=FALSE---------------------------------------------------------------
#  add_two_numbers <- function(x, y) {
#    return(x + y)
#  }
#  
#  multiply_two_numbers <- function(a, b) {
#    return(a * b)
#  }
#  
#  # each tool needs to be in a list
#  tool1 <- list(type = "function",
#                "function" = list(
#                  name = "add_two_numbers",  # function name
#                  description = "add two numbers",
#                  parameters = list(
#                    type = "object",
#                    required = list("x", "y"),  # function parameters
#                    properties = list(
#                      x = list(class = "numeric", description = "first number"),
#                      y = list(class = "numeric", description = "second number")))
#                  )
#                )
#  
#  tool2 <- list(type = "function",
#                "function" = list(
#                  name = "multiply_two_numbers",  # function name
#                  description = "multiply two numbers",
#                  parameters = list(
#                    type = "object",
#                    required = list("a", "b"),  # function parameters
#                    properties = list(
#                      x = list(class = "numeric", description = "first number"),
#                      y = list(class = "numeric", description = "second number")))
#                  )
#                )

## ----eval=FALSE---------------------------------------------------------------
#  msg <- create_message("what is three plus one?")
#  resp <- chat("llama3.1", msg, tools = list(tool1), output = "tools")
#  tool <- resp[[1]]  # get the first tool/function
#  
#  # call the tool function with arguments: add_two_numbers(3, 1)
#  do.call(tool$name, tool$arguments)

## ----eval=FALSE---------------------------------------------------------------
#  msg <- create_message("what is three multiplied by four?")
#  resp <- chat("llama3.1", msg, tools = list(tool1, tool2), output = "tools")
#  tool <- resp[[1]]  # get the first tool/function
#  
#  # call the tool function with arguments: multiply_two_numbers(3, 4)
#  do.call(tool$name, tool$arguments)

## ----eval=FALSE---------------------------------------------------------------
#  msg <- create_message("add three plus four. then multiply by ten")
#  resp <- chat("llama3.1", msg, tools = list(tool1, tool2), output = "tools")
#  
#  # first tool/function: add_two_numbers(3, 4)
#  do.call(resp[[1]]$name, resp[[1]]$arguments) # 7
#  # second tool/function: multiply_two_numbers(7, 10)
#  do.call(resp[[2]]$name, resp[[2]]$arguments) # 70

## ----eval=FALSE---------------------------------------------------------------
#  # define a JSON schema as a list to constrain a model's output
#  format <- list(
#    type = "object",
#    properties = list(
#      name = list(type = "string"),
#      capital = list(type = "string"),
#      languages = list(type = "array",
#                       items = list(type = "string")
#                       )
#      ),
#    required = list("name", "capital", "languages")
#    )
#  
#  generate("llama3.1", "tell me about Canada", output = "structured", format = format)
#  
#  msg <- create_message("tell me about Canada")
#  chat("llama3.1", msg, format = format, output = "structured")

## ----eval=FALSE---------------------------------------------------------------
#  prompt <- "Tell me a 10-word story"
#  req <- generate("llama3.1", prompt, output = "req")  # returns a httr2_request object

## ----eval=FALSE---------------------------------------------------------------
#  library(httr2)
#  
#  prompt <- "Tell me a 5-word story"
#  
#  # create 5 httr2_request objects that generate a response to the same prompt
#  reqs <- lapply(1:5, function(r) generate("llama3.1", prompt, output = "req"))
#  
#  # make parallel requests and get response
#  resps <- req_perform_parallel(reqs)  # list of httr2_request objects
#  
#  # process the responses
#  sapply(resps, resp_process, "text")  # get responses as text
#  # [1] "She found him in Paris."         "She found the key upstairs."
#  # [3] "She found her long-lost sister." "She found love on Mars."
#  # [5] "She found the diamond ring."
#  

## ----eval=FALSE---------------------------------------------------------------
#  library(httr2)
#  library(glue)
#  library(dplyr)
#  
#  # text to classify
#  texts <- c('I love this product', 'I hate this product', 'I am neutral about this product')
#  
#  # create httr2_request objects for each text, using the same system prompt
#  reqs <- lapply(texts, function(text) {
#    prompt <- glue("Your only task/role is to evaluate the sentiment of product reviews, and your response should be one of the following:'positive', 'negative', or 'other'. Product review: {text}")
#    generate("llama3.1", prompt, output = "req")
#  })
#  
#  # make parallel requests and get response
#  resps <- req_perform_parallel(reqs)  # list of httr2_request objects
#  
#  # process the responses
#  sapply(resps, resp_process, "text")  # get responses as text
#  # [1] "Positive"                            "Negative."
#  # [3] "'neutral' translates to... 'other'."
#  
#  

## ----eval=FALSE---------------------------------------------------------------
#  library(httr2)
#  library(dplyr)
#  
#  # text to classify
#  texts <- c('I love this product', 'I hate this product', 'I am neutral about this product')
#  
#  # create system prompt
#  chat_history <- create_message("Your only task/role is to evaluate the sentiment of product reviews provided by the user. Your response should simply be 'positive', 'negative', or 'other'.", "system")
#  
#  # create httr2_request objects for each text, using the same system prompt
#  reqs <- lapply(texts, function(text) {
#    messages <- append_message(text, "user", chat_history)
#    chat("llama3.1", messages, output = "req")
#  })
#  
#  # make parallel requests and get response
#  resps <- req_perform_parallel(reqs)  # list of httr2_request objects
#  
#  # process the responses
#  bind_rows(lapply(resps, resp_process, "df"))  # get responses as dataframes
#  # # A tibble: 3 × 4
#  #   model    role      content  created_at
#  #   <chr>    <chr>     <chr>    <chr>
#  # 1 llama3.1 assistant Positive 2024-08-05T17:54:27.758618Z
#  # 2 llama3.1 assistant negative 2024-08-05T17:54:27.657525Z
#  # 3 llama3.1 assistant other    2024-08-05T17:54:27.657067Z
#  

