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
  has_many :comments

  has_many :votes, as: :votable, dependent: :destroy

  def comments_by_parent_id
    comment_hash = Hash.new { |h, k| h[k] = [] }
    comments.includes(:author).each do |comment|
      comment_hash[comment.parent_comment_id] << comment
    end
    comment_hash
  end

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
