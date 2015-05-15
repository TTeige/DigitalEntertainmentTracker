class CreateSeriesNames < ActiveRecord::Migration
  def change
    create_table :series_names do |t|
      t.integer :seriesid
      t.string :seriesname

      t.timestamps null: false
    end
  end
end
