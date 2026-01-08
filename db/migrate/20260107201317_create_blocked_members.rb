class CreateBlockedMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :blocked_members do |t|
      t.references :member, null: false, foreign_key: true
      t.references :blocked, null: false, foreign_key: { to_table: :members }

      t.timestamps
    end
    add_index :blocked_members, [:member_id, :blocked_id], unique: true
  end
end
