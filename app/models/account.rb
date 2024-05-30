class Account < ApplicationRecord
  validates :name, presence: true
  validates :vat, presence: true, format: { with: /\AEL\d{9}\z/, message: "must be in the format EL and 9 digits" }
  validates :city, presence: true
  validates :zipcode, presence: true, format: { with: /\A\d{9}\z/, message: "must be 5 digits"}
  validates :address, presence: true
end
