class CreateEpisodeAirInformations < ActiveRecord::Migration
  def change
    create_table :episode_air_informations do |t|
      t.integer :seriesid
      t.integer :episodeid
      t.string :episodename
      t.datetime :airdate

      t.timestamps null: false
    end
  end
end
