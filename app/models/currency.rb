class Currency < ActiveRecord::Base
  has_many :projects
  belongs_to :pledge_transaction
  validates :name, presence: true, length: { minimum: 3 }
end
