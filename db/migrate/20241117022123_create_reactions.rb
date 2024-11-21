class CreateReactions < ActiveRecord::Migration[7.2]
  def change
    create_table :reactions do |t|
      t.references :account, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true

      t.timestamps
      
      
      t.index [:account_id, :post_id], unique: true
    end
  end
end
