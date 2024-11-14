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
  belongs_to :account, class_name: 'Account', foreign_key: 'account_id'

  validates :title, presence: true
  validates :content, presence: true
  validates :account_id, presence: true
end
