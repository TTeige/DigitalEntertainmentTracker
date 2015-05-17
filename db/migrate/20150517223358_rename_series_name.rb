class RenameSeriesName < ActiveRecord::Migration
  def change
    rename_table :series_names, :series_informations
  end
end
