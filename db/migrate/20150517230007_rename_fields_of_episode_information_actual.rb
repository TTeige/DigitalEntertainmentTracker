class RenameFieldsOfEpisodeInformationActual < ActiveRecord::Migration
  def change
    change_table :episode_informations do |t|
      t.rename :episodeid, :id
      t.rename :airdate, :firstaired
      t.rename :episodenum, :episodenumber
      t.rename :seasonnum, :seasonnumber
      t.rename :description, :overview
      t.rename :banner, :imagepath_full
    end
  end
end
