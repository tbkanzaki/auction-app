class AddNomeToBlockedCpf < ActiveRecord::Migration[7.0]
  def change
    add_column :blocked_cpfs, :name, :string
  end
end
