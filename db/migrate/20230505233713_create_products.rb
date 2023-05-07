class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :code
      t.string :name
      t.string :description
      t.integer :weight
      t.integer :width
      t.integer :height
      t.integer :depth
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
