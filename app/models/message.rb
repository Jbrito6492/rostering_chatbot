class Message < ApplicationRecord
  belongs_to :conversation

  after_create :generate_regular_response, if: -> { role == 'user' }

  def generate_rag_response
    llm_response = ROSTERING_CHATBOT.ask(question: content)

    conversation.messages.create!(content: llm_response.chat_completion, role: 'bot', llm_provider: 'openai')
  end

  def generate_regular_response
    llm = Langchain::LLM::OpenAI.new(api_key: ENV["OPENAI_KEY"])
    response = llm.chat(messages: [{role: "user", content:}]).completion
    conversation.messages.create!(content: response, role: 'bot', llm_provider: 'openai')
  end
end
