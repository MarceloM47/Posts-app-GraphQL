# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  title      :string
#  content    :text
#  account_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Post < ApplicationRecord
  belongs_to :account
  has_many :reactions, dependent: :destroy
  has_many :liking_accounts, through: :reactions, source: :account

  validates :title, presence: true
  validates :content, presence: true
  validates :account_id, presence: true
end
