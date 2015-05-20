class AddLastUpdatedTimeToEpisodeInformations < ActiveRecord::Migration
  def change
    add_column :episode_informations, :lastupdatedtime, :datetime
  end
end
