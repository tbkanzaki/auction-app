class RemoveAnswerFromLotDoubts < ActiveRecord::Migration[7.0]
  def change
    remove_column :lot_doubts, :answer, :string
  end
end
