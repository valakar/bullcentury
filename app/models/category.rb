class Category < ActiveRecord::Base
	has_many :categorizations, :dependent => :destroy
	has_many :projects, :through => :categorizations

  validates :name, presence: true, length: { minimum: 3 }
end
