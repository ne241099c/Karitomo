class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.references :member, null: false, foreign_key: true  # 予約した人
      t.references :target_member, null: false, foreign_key: { to_table: :members }  # 予約された人
      t.datetime :start_at, null: false  # 予約開始日時
      t.integer :hours, null: false  # 何時間借りるか
      t.string :place, null: false
      t.integer :status, null: false, default: 0
      t.text :comment

      t.timestamps
    end
  end
end
