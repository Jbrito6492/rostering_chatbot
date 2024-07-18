class Message < ApplicationRecord
  belongs_to :conversation

  after_create :generate_rag_response, if: -> { role == 'user' }

  def generate_rag_response
    llm_response = ROSTERING_CHATBOT.ask(question: content)
    ai_response = llm_response.chat_completion
    ragas_score = generate_ragas_score(question: content, answer: ai_response, context: llm_response.context)
    conversation.messages.create!(content: ai_response, role: 'bot', llm_provider: 'openai', ragas_score:)
  end

  def generate_regular_response
    llm = Langchain::LLM::OpenAI.new(api_key: ENV['OPENAI_KEY'], default_options: { chat_completion_model_name: 'gpt-4' })
    response = llm.chat(messages: [{ role: "user", content: }]).completion
    conversation.messages.create!(content: response, role: 'bot', llm_provider: 'openai')
  end

  def generate_ragas_score(question:, answer:, context:)
    llm = Langchain::LLM::OpenAI.new(api_key: ENV['OPENAI_KEY'], default_options: { chat_completion_model_name: 'gpt-4' })
    ragas = Langchain::Evals::Ragas::Main.new(llm: llm)
    ragas.score(question:, answer:, context:)
  end
end
