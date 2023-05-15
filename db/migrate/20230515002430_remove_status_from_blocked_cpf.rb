class RemoveStatusFromBlockedCpf < ActiveRecord::Migration[7.0]
  def change
    remove_column :blocked_cpfs, :status, :integer
  end
end
