class Conversation < ApplicationRecord
  has_many :messages, dependent: :destroy
  accepts_nested_attributes_for :messages

  def llm(llm_provider: 'bedrock')
    if llm_provider == 'bedrock'
               Langchain::LLM::AwsBedrock.new(completion_model: 'anthropic.claude-3-sonnet-20240229-v1:0')
    elsif llm_provider == 'openai'
               Langchain::LLM::OpenAI.new(api_key: Rails.application.credentials.open_ai[:api_key],
                                          default_options: { chat_completion_model_name: 'gpt-4' })
    else
               raise ArgumentError.new("Invalid LLM type: #{llm_provider}")
    end
  end

  def one_roster_integrated_client(llm_provider: 'bedrock')
    specification_pdf = Langchain.root.join(Rails.root, 'lib', 'data', 'docs', 'oneroster_v11_final_specification.pdf')
    client = Langchain::Vectorsearch::Pgvector.new(url: ENV['POSTGRES_URL'], index_name: 'messages', llm: llm(llm_provider: llm_provider))
    client.add_data(paths: [specification_pdf])
  end
end
