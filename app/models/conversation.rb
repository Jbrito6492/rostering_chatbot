class Conversation < ApplicationRecord
  has_many :messages, dependent: :destroy

  def client(llm: 'bedrock')
    if llm == 'bedrock'
      Langchain::LLM::AwsBedrock.new(completion_model: 'anthropic.claude-3-sonnet-20240229-v1:0')
    elsif llm == 'openai'
      Langchain::LLM::OpenAI.new(api_key: Rails.application.credentials.open_ai[:api_key],
                                 default_options: { chat_completion_model_name: 'gpt-4' })
    else
      raise ArgumentError.new("Invalid LLM type: #{llm}")
    end
  end
end
