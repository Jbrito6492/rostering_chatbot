specification_file = Langchain.root.join(Rails.root, 'lib', 'data', 'docs', 'one_roster_v11_final_spec.txt')
specification_text = File.read(specification_file)

def expensive_chunks(specification_text)
  anthropic = Langchain::LLM::Anthropic.new(api_key: ENV["ANTHROPIC_API_KEY"])
  Langchain::Chunker::Semantic.new(specification_text, llm: anthropic).chunks
end

def shitty_cheap_chunks(specification_text)
  Langchain::Chunker::RecursiveText.new(specification_text).chunks
end

def create_client(specification_text)
  llm = Langchain::LLM::OpenAI.new(api_key: ENV['OPENAI_KEY'], default_options: { chat_completion_model_name: 'gpt-4' })

  chunks = shitty_cheap_chunks(specification_text)
  client = Langchain::Vectorsearch::Weaviate.new(url: ENV["WEAVIATE_URL"],
                                                 api_key: ENV["WEAVIATE_API_KEY"],
                                                 index_name: "User",
                                                 llm:)
  client.add_texts(texts: chunks.map(&:text))
  client
end

ROSTERING_CHATBOT = create_client(specification_text)
