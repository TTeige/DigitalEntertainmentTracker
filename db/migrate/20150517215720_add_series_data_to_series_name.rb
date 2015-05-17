class AddSeriesDataToSeriesName < ActiveRecord::Migration
  def change
    add_column :series_names, :description, :text
    add_column :series_names, :genres, :string
  end
end
