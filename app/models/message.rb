class Message < ApplicationRecord
  belongs_to :conversation

  after_create :generate_response, if: -> { role == 'user' }

  def generate_response
    client = conversation.one_roster_integrated_client(llm_provider:)
    llm_response = client.ask(question: content)

    conversation.messages.create!(content: llm_response.chat_completion, role: 'bot', llm_provider:)
  end
end
