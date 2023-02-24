class Events < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :name
      t.string :fingerprint 
      t.string :user_id
      t.string :created_at
    end
  end
end
