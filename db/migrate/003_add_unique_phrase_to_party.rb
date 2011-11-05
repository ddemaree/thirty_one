class AddUniquePhraseToParty < ActiveRecord::Migration
  def change
    change_table :parties do |t|
      t.string :unique_phrase, :unique => true
    end
  end
end