class CreateLotDoubtAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :lot_doubt_answers do |t|
      t.references :lot_doubt, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :answer

      t.timestamps
    end
  end
end
