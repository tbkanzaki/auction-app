class ChangeDateTimeToDateInInLots < ActiveRecord::Migration[7.0]
  def change
    change_column :lots, :start_date, :date
    change_column :lots, :limit_date, :date
  end
end
