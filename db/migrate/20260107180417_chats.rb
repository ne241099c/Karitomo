class Chats < ActiveRecord::Migration[7.0]
    def change
        create_table :chats do |t|
            t.references :reservation, null: false, foreign_key: true
            t.references :member, null: false, foreign_key: true # 送信者
            t.text :content, null: false

            t.timestamps
        end
    end
end
