class CreateBookmarks < ActiveRecord::Migration[7.0]
  def change
    create_table :bookmarks do |t|
      t.references :member, null: false, foreign_key: true
      t.references :bookmarked, null: false,foreign_key: { to_table: :members }

      t.timestamps
    end
    add_index :bookmarks, [:member_id, :bookmarked_id], unique: true
  end
end
