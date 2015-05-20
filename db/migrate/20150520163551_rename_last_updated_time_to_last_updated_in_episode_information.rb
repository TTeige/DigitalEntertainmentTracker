class RenameLastUpdatedTimeToLastUpdatedInEpisodeInformation < ActiveRecord::Migration
  def change
    change_table :episode_informations do |t|
      t.rename :lastupdatedtime, :lastupdated
    end
  end
end
