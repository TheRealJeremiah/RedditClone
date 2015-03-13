# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  url        :string
#  content    :text
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Post < ActiveRecord::Base
  validates :title, :user_id, presence: true
  validate :post_has_at_one_sub

  belongs_to :author, foreign_key: :user_id, class_name: 'User'
  has_many :post_subs, dependent: :destroy
  has_many :subs, through: :post_subs, source: :sub

  private

  def post_has_at_one_sub
    unless sub_ids.count >= 1
      errors[:post] ||= []
      errors[:post] = 'must be associated with at least one sub'
      return false
    end

    true
  end
end
