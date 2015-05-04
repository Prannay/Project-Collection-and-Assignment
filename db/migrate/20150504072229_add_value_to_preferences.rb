class AddValueToPreferences < ActiveRecord::Migration
  def change
    add_column :preferences, :value, :integer
  end
end
