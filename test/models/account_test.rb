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
require "test_helper"

class AccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
