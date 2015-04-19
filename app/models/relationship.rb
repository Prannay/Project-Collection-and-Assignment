class Relationship < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  validates :user_id, presence: true
  validates :team_id, presence: true
end
