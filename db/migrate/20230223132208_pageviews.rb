class Pageviews < ActiveRecord::Migration[7.0]

  def change
    create_table :page_view do |t|
      t.string :fingerprint
      t.string :user_id
      t.string :url
      t.string :referrer_url
      t.string :created_at
    end
  end

end