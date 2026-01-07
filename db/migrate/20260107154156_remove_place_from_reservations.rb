class RemovePlaceFromReservations < ActiveRecord::Migration[7.0]
  def change
    remove_column :reservations, :place, :string
  end
end
