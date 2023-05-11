class CreateLotApprovers < ActiveRecord::Migration[7.0]
  def change
    create_table :lot_approvers do |t|
      t.references :lot, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
