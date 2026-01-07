class CreateFreeDates < ActiveRecord::Migration[7.0]
  def change
    create_table :free_dates do |t|
      t.references :member, null: false, foreign_key: true
      t.datetime :free_hour, null: false
      t.string :day, null: false

      t.timestamps
    end
  end
end
