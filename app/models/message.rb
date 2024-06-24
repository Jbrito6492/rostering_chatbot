class Message < ApplicationRecord
  belongs_to :conversation

  after_create :generate_response, if: -> { role == 'user' }

  def generate_response
    client = conversation.one_roster_integrated_client(llm: llm_provider)
    response = client.ask(question: content)
    conversation.messages.create!(content: response, role: 'bot', llm_provider: llm_provider)
  end
end
