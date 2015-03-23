class Request < ActiveRecord::Base
  belongs_to :project
  belongs_to :location
  belongs_to :department
  belongs_to :group
  belongs_to :user
  has_many :skills, through: :needed_skills
end