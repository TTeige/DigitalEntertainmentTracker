class RenameEpisodeAirInformation < ActiveRecord::Migration
  def change
    rename_table :episode_air_informations, :episode_informations
  end
end
