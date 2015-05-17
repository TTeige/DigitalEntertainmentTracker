class RenameFieldsOfSeriesInformationActual < ActiveRecord::Migration
  def change
    change_table :series_informations do |t|
      t.rename :description, :overview
    end
  end
end
