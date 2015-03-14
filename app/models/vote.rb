# == Schema Information
#
# Table name: votes
#
#  id           :integer          not null, primary key
#  value        :integer          not null
#  votable_id   :integer          not null
#  votable_type :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true

  validates :value, :votable_id, :votable_type, presence: true
  validates :value, inclusion: [-1, 1]

  def score
    votable.votes.pluck(:value).inject(&:+)
  end
end
