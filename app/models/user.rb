class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :omniauthable, :omniauth_providers => [:facebook, :vkontakte]

  has_many :projects
  # has_one :location
  has_one :city
  has_one :country
  belongs_to :current_project, :class_name => "Project", :foreign_key => "current_project_id"
  belongs_to :pledge_transaction

  validates :name, presence: true, length: { minimum: 3 }

  mount_uploader :image, ImageUploader

  # accepts_nested_attributes_for :location
  accepts_nested_attributes_for :city
  accepts_nested_attributes_for :country

  #TODO
  def self.public_profiles
    where(:public => true)
  end

  #TODO
  def published_project
    nil
  end

  def city
    self.city_id ? City.select(:name).find(city_id) : nil
  end

  def country
    self.country_id ? Country.select(:name).find(country_id) : nil

    # self.location ? self.location.country : nil
  end
  
  #TODO
  def closed_projects
    self.projects.where state: :closed
  end

  def can_create_project?
    self.current_project_id == nil
  end

  def self.find_for_facebook_oauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = user.uid.to_s + '@facebook.com'
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
      # user.image = auth.info.image # assuming the user model has an image
    end
  end

  def self.find_for_vkontakte_oauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = user.uid.to_s + '@vk.com'
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
      # user.image = auth.info.image # assuming the user model has an image
    end
  end

=begin
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
=end
end
