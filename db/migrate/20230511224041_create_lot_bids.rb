class CreateLotBids < ActiveRecord::Migration[7.0]
  def change
    create_table :lot_bids do |t|
      t.references :lot, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :bid

      t.timestamps
    end
  end
end
