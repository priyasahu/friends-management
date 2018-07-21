class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.belongs_to :user
      t.integer :user_id
      t.integer :target_id
      t.timestamps
    end
  end
end
