class AddUniqueConstraintToAccountsVat < ActiveRecord::Migration[7.1]
  def change
    add_index :accounts, :vat, unique: true
  end
end
