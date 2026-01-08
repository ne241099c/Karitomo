class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :reports do |t|
      t.references :reservation, null: false, foreign_key: true
      t.references :member, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
