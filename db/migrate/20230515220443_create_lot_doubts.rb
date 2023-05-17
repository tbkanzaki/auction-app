class CreateLotDoubts < ActiveRecord::Migration[7.0]
  def change
    create_table :lot_doubts do |t|
      t.references :lot, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :question
      t.string :answer
      t.integer :status, default: 2

      t.timestamps
    end
  end
end
