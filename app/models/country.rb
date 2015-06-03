class Country < ActiveRecord::Base
	has_many :city
	has_many :project
end
