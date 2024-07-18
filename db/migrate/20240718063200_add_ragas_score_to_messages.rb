class AddRagasScoreToMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :ragas_score, :json
  end
end
