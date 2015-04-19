class Project < ActiveRecord::Base
  validates :title, presence: true
  validates :organization, presence: true
  validates :contact, presence: true
  validates :description, presence: true
  default_scope -> { order(created_at: :desc) }
end

