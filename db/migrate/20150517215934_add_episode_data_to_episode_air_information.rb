class AddEpisodeDataToEpisodeAirInformation < ActiveRecord::Migration
  def change
    add_column :episode_air_informations, :episodenum, :integer
    add_column :episode_air_informations, :seasonnum, :integer
    add_column :episode_air_informations, :description, :text
    add_column :episode_air_informations, :banner, :string
  end
end
