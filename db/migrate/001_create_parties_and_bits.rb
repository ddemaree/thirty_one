class CreatePartiesAndBits < ActiveRecord::Migration
  def change
    create_table :parties do |t|
      t.string :email, :unique => true
      t.text :notes
    end

    create_table :party_bits do |t|
      t.integer :party_id
      t.string :bit_path
    end

    add_index :party_bits, [:bit_path]
    add_index :party_bits, [:party_id, :bit_path], :unique => true
  end
end