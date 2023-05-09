class CreateLots < ActiveRecord::Migration[7.0]
  def change
    create_table :lots do |t|
      t.string :code
      t.datetime :start_date
      t.datetime :limit_date
      t.integer :minimum_bid
      t.integer :minimum_difference_bids
      t.integer :status, default: 0 
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
