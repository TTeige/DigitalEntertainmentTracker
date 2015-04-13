class CreateSeriesSubscriptions < ActiveRecord::Migration
  def change
    create_table :series_subscriptions do |t|
      t.references :user, index: true
      t.integer :seriesid

      t.timestamps null: false
    end
    add_foreign_key :series_subscriptions, :users
  end
end
