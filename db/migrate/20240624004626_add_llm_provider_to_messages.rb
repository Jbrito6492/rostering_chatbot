class AddLlmProviderToMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :llm_provider, :string
  end
end
