class Message < ApplicationRecord
  belongs_to :conversation

  after_create :generate_response, if: -> { role == 'user' }

  def generate_response
    llm_response = ROSTERING_CHATBOT.ask(question: content)

    conversation.messages.create!(content: llm_response.chat_completion, role: 'bot', llm_provider:)
  end
end
