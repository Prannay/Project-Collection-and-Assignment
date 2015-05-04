class Preference < ActiveRecord::Base
  belongs_to :team
  belongs_to :project
  validates :team_id, presence: true
  validates :project_id, presence: true
end
