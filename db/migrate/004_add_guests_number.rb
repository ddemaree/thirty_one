class AddGuestsNumber < ActiveRecord::Migration
  def change
    change_table :parties do |t|
      t.integer :guests, :default => 1
    end
  end
end