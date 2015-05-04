class Project < ActiveRecord::Base
  has_many :relationships, dependent: :destroy
  has_many :bidders, through: :relationships, source: :team

  validates :title, presence: true
  validates :organization, presence: true
  validates :contact, presence: true
  validates :description, presence: true
  default_scope -> { order(created_at: :desc) }
end

