# == Schema Information
#
# Table name: accounts
#
#  id              :integer          not null, primary key
#  name            :string
#  email           :string
#  password_digest :string
#  account_type    :string
#  company_number  :string
#  date_of_birth   :date
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Account < ApplicationRecord
    has_secure_password
  
    validates :email, presence: true, uniqueness: true
    validates :name, presence: true
    validates :account_type, presence: true, inclusion: { in: %w[individual company] }  
end
