class AddUsersSubscribedToSeriesInformations < ActiveRecord::Migration
  def change
    add_column :series_informations, :userssubscribed, :integer
  end
end
