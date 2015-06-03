class PledgeTransaction < ActiveRecord::Base
  has_one :project
  has_one :user
  has_one :currency

  before_save :generate_transaction_id

  private
  def generate_transaction_id
    require 'securerandom'
    self.transaction_id = SecureRandom.uuid
  end
end
