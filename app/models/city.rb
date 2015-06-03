class City < ActiveRecord::Base
	has_one :country
	belongs_to :project
	belongs_to :user
end
