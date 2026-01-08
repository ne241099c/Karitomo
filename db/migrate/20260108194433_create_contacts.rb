class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.references :member, null: false, foreign_key: true
      t.text :message, null: false

      t.timestamps
    end
  end
end
