specification_file = Langchain.root.join(Rails.root, 'lib', 'data', 'docs', 'one_roster_v11_final_spec.txt')
specification_text = File.read(specification_file)

llm = Langchain::LLM::OpenAI.new(api_key: ENV['OPENAI_KEY'], default_options: {
  chat_completion_model_name: 'gpt-4' })

# anthropic = Langchain::LLM::Anthropic.new(api_key: ENV["ANTHROPIC_API_KEY"])
# chunks = Langchain::Chunker::Semantic.new(specification_text, llm: anthropic).chunks
chunks = Langchain::Chunker::RecursiveText.new(specification_text).chunks
client = Langchain::Vectorsearch::Weaviate.new(url: ENV["WEAVIATE_URL"],
                                               api_key: ENV["WEAVIATE_API_KEY"],
                                               index_name: "Documents",
                                               llm:)
client.add_texts(texts: chunks.map(&:text))

ROSTERING_CHATBOT = client
