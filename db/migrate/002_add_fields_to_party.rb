class AddFieldsToParty < ActiveRecord::Migration
  def change
    change_table :parties do |t|
      t.string :name
      t.string :invitation_code
    end
  end
end