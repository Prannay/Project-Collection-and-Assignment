class Project < ActiveRecord::Base
  has_many :preferences, dependent: :destroy
  has_many :bidders, through: :preferences, source: :team

  validates :title, presence: true
  validates :organization, presence: true
  validates :contact, presence: true
  validates :description, presence: true
  default_scope -> { order(created_at: :desc) }
end

