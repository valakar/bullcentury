class Reward < ActiveRecord::Base
  belongs_to :project

  validates :per_amount, presence: true
  validates :description, presence: true
  validates :project_id, presence: true
  mount_uploader :image, ImageUploader

end
