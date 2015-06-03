class Project < ActiveRecord::Base
  has_many :categorizations, :dependent => :destroy
  has_many :categories, :through => :categorizations

  has_many :rewards
  belongs_to :author, :class_name => "User", :foreign_key => :user_id
  belongs_to :currency
  belongs_to :city
  belongs_to :country
  belongs_to :pledge_transaction

  accepts_nested_attributes_for :categories
  accepts_nested_attributes_for :rewards

  validates :name, presence: true, length: { minimum: 3 }
  mount_uploader :image, ImageUploader
  mount_uploader :video, VideoUploader

  scope :set_for_publish, -> { where(state: "set_for_publish")}

#created - значение по умолчанию, когда только создался проект;
#rejected - отклонён
#published - запаблишенный проект;
#closed - проект закрыт (либо удачно, либо нет), это состояние возможно только после состояния published;
#set_for_publish - проект на рассмотрении BC

  def as_json(options=nil)
    super(:include => [{:categories => {:only => [:id]}}, :rewards])
  end

  def set_success(format, opts)
    #self.success = true
    #puts 'VIDEO SUCCESS VIDEO SUCCESS VIDEO SUCCESS VIDEO SUCCESS'
  end

  def update_categories(category_ids)
    categorizations = self.categorizations.where :project_id => self.id    
    categorizations.each do |categorization|
      unless category_ids.include? categorization.category_id
        categorization.destroy
      end
    end

    categorizations = self.categorizations.where :project_id => self.id
    categorizations = categorizations.map {|item| item.id}
    category_ids.each do |category_id|
      unless categorizations.include? category_id
        categorization = Categorization.new({:category_id => category_id, :project_id => self.id})
        categorization.save
      end
    end
  end

  def valid_for_publish?
    valid_self_data()     and
    valid_author()        and
    valid_rewords_count() and
    valid_category_count()
  end

  def valid_self_data
    !self.name.blank? and
    !self.description.blank? and
    (self.funding_duration_in_days and self.funding_duration_in_days > 0) and
    self.funding_goal and
    (!self.image.to_s.blank? and !self.image.url(:project_profile).blank?) and
    !self.tweet.blank? and !self.currency_id.blank?
  end

  def valid_author
    author = User.includes(:location).find_by_id( self.user_id)
    if author
      !author.name.blank? and
      !author.image.to_s.blank? and
      !author.location.city.blank? and
      !author.location.country.blank?
    else
      false
    end
  end

  def valid_rewords_count
    rewords = Reward.where(:project_id => self.id).load
    rewords.count > 0
  end

  def valid_category_count
    categories = Categorization.where(:project_id => self.id).load
    categories.count > 0
  end

  def published?
    self.state == "published"
  end

  def on_review?
    self.state == "set_for_publish"
  end

  def closed?
    self.state == "closed"
  end

  def in_action?
    published? || on_review?
  end

  def is_published?
    # self.state == "closed" || self.state == "published" # Shoul be like this
    self.state == 'set_for_publish' # Temporary
    end

  def is_owner? user_id
    puts 'Test can_read? user_id: == ' + user_id.to_s
    puts 'Test can_read? self.user_id: == ' + self.user_id.to_s
    self.user_id == user_id # Temporary
  end

  def can_read? user_id
    self.user_id == user_id || (self.state == "closed" || self.state == "published")
  end

  def set_for_publish
    if self.valid_for_publish?
      self.state = "set_for_publish"
      self.save
      ProjectMailer.set_for_review(self).deliver
      #self.delay( { run_at: self.funding_duration_in_days.days.from_now} ).close
    else
      false
    end
  end

  def publish
    self.state = "published"
    self.save
    ProjectMailer.has_published(self).deliver
    self.delay( { run_at: self.funding_duration_in_days.days.from_now - 1.minute} ).close
  end

  def reject
    self.state = "rejected"
    self.save
    ProjectMailer.has_rejected(self).deliver
    self.delay( { run_at: 10.days.from_now - 1.minute} ).close_after_reject
  end

  def close
    if self.state == "published"
      self.state = "closed"
      self.current_project_id = nil
      #TODO make deсision about success 
      self.save
      ProjectMailer.has_finished(self).deliver
    else
      false
    end
  end

  def close_after_reject
    if self.state == "rejected"
      self.state = "closed"
      self.current_project_id = nil
      #TODO make deсision about success 
      self.save
      ProjectMailer.has_finished(self).deliver
    else
      false
    end
  end
  def get_currency
    cur = self.currency
    if cur
      {name: cur.name, key: cur.key, sign: cur.sign}
    else
      nil
    end
  end

  def calc_pledged
    pledged = 0;
    pledgedList = PledgeTransaction.where(project_id: self.id);
    pledgedList.each do |pledge|
      pledged += pledge.amount
    end
    pledged
  end

  def calc_pledged_percentage pledged
    (((pledged | 0) / funding_goal.to_f) * 100)
  end

  def get_categories
    categories = []
    self.categories.each { |c| categories.push(c.name)}
    categories.join(' ')
  end

  def get_validation_errors
    result = {}
    if !valid_self_data()
      result[:name] = !self.name.blank? ? nil : "Project name required"
      result[:description] = !self.description.blank? ? nil : "Project description required"
      result[:funding_duration_in_days] = (self.funding_duration_in_days and self.funding_duration_in_days > 0) ? nil : "Project funding duration required"
      result[:funding_goal] = self.funding_goal ? nil : "Project funding goal required"
      result[:image] = (!self.image.to_s.blank? and !self.image.url(:project_profile).blank?) ? nil : "Project image required"
      result[:tweet] = !self.tweet.blank? ? nil : "Project tweet required"
      result[:creator_biography] = !self.creator_biography.blank? ? nil : "Project creator biography required"
      result[:timeline1] = !self.timeline1.blank? ? nil : "Project timeline(if project funded) required"
      result[:timeline2] = !self.timeline2.blank? ? nil : "Project timeline(prototype created) required"
      result[:timeline3] = !self.timeline3.blank? ? nil : "Project timeline(delivery all rewards) required"
      result[:timeline_date1] = !self.timeline_date1.blank? ? nil : "Project timeline date(if project funded) required"
      result[:timeline_date2] = !self.timeline_date2.blank? ? nil : "Project timeline date(prototype created) required"
      result[:timeline_date3] = !self.timeline_date3.blank? ? nil : "Project timeline date(delivery all rewards) required"
      result[:country] = !self.country.blank? ? nil : "Project country required"
      result[:city] = !self.city.blank? ? nil : "Project city required"
      result[:zip] = !self.zip.blank? ? nil : "Project zip required"
      result[:currency_id] = !self.currency_id.blank? ? nil : "Project currency required"
    end
    if !valid_author() and self.author
      result[:author_name] = !author.name.blank? ? nil : "Project author name required"
      result[:author_image] = !author.image.to_s.blank? ? nil : "Project author image required"
      # if author.location.nil?
        # result[:author_city] = "Project author city required"
        # result[:author_country] = "Project author country required"
      # else
        # result[:author_city] = !author.location.city.blank? ? nil : "Project author city required"
        # result[:author_country] = !author.location.country.blank? ? nil : "Project author country required"
      # end
    elsif !self.author
      result[:author] = "Your project must have author"
    end
    if !valid_rewords_count()
      result[:rewords] = "Your project must have at least one reward"
    end
    if !valid_category_count()
      result[:categories] = "Your project must have at least one category"
    end
    result
  end
end
