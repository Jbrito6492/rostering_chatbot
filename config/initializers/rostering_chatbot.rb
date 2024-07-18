llm = Langchain::LLM::OpenAI.new(api_key: ENV['OPENAI_KEY'], default_options: { chat_completion_model_name: 'gpt-4' })

client = Langchain::Vectorsearch::Weaviate.new(url: ENV["WEAVIATE_URL"], api_key: ENV["WEAVIATE_API_KEY"],
                                               index_name: "User", llm:)

ROSTERING_CHATBOT = client
