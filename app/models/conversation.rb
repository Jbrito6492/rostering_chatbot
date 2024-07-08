class Conversation < ApplicationRecord
  has_many :messages, dependent: :destroy
  accepts_nested_attributes_for :messages

  def llm(llm_provider: 'bedrock')
    if llm_provider == 'bedrock'
      Langchain::LLM::AwsBedrock.new(completion_model: 'anthropic.claude-3-sonnet-20240229-v1:0')
    elsif llm_provider == 'openai'
      Langchain::LLM::OpenAI.new(api_key: ENV['OPENAI_KEY'],
                                 default_options: { chat_completion_model_name: 'gpt-4' })
    else
      raise ArgumentError.new("Invalid LLM type: #{llm_provider}")
    end
  end

  def one_roster_integrated_client(llm_provider: 'bedrock')
    specification_file = Langchain.root.join(Rails.root, 'lib', 'data', 'docs', 'one_roster_v11_final_spec.txt')
    specification_text = File.read(specification_file)
    # anthropic = Langchain::LLM::Anthropic.new(api_key: ENV["ANTHROPIC_API_KEY"])
    # chunks = Langchain::Chunker::Semantic.new(specification_text, llm: anthropic).chunks
    chunks = Langchain::Chunker::RecursiveText.new(specification_text).chunks
    client = Langchain::Vectorsearch::Weaviate.new(
      url: ENV["WEAVIATE_URL"],
      api_key: ENV["WEAVIATE_API_KEY"],
      index_name: "Documents",
      llm:  llm(llm_provider:)
    )
    # client = Langchain::Vectorsearch::Pgvector.new(url: ENV['POSTGRES_URL'], index_name: 'messages', llm: llm(llm_provider:))
    client.add_texts(texts: chunks.map(&:text))
    client
  end
end
