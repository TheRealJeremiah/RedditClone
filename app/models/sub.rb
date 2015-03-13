# == Schema Information
#
# Table name: subs
#
#  id          :integer          not null, primary key
#  title       :string           not null
#  description :text
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Sub < ActiveRecord::Base
  belongs_to :moderator, class_name: :User, foreign_key: :user_id

  has_many :post_subs, dependent: :destroy
  has_many :posts, through: :post_subs, source: :post
end
