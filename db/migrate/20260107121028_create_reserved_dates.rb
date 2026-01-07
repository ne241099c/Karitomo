class CreateReservedDates < ActiveRecord::Migration[7.0]
  def change
    create_table :reserved_dates do |t|
      t.references :reservation, null: false, foreign_key: true
      t.references :target_member, null: false, foreign_key: { to_table: :members }
      t.datetime :date

      t.timestamps
    end
  end
end
