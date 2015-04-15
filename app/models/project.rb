class Project < ActiveRecord::Base
  validates :title, presence: true
  validates :organization, presence: true
end
