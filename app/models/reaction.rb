# == Schema Information
#
# Table name: reactions
#
#  id         :integer          not null, primary key
#  account_id :integer          not null
#  post_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Reaction < ApplicationRecord
  belongs_to :account
  belongs_to :post

  validates :account_id, uniqueness: { 
    scope: :post_id,
    message: "You can only like a post once" 
  }
end
