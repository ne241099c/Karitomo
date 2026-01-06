class CreateMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :members do |t|
      t.string :name, null: false
      t.integer :sex, null: false
      t.string :email, null: false, index: { unique: true }
      t.string :password_digest, null: false
      t.text :comment
      t.date :birthday, null: false
      t.integer :price_per_hour
      t.boolean :special_member, default: false
      t.boolean :is_banned, default: false

      t.timestamps
    end
  end
end
