class ChangeColumnDefaultStatusFromLotDoubt < ActiveRecord::Migration[7.0]
  def change
    change_column_default :lot_doubts, :status, from: 2, to: 0
  end
end
