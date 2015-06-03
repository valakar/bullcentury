class Feedback < MailForm::Base
  attribute :name
  attribute :subject,   :validate => true
  attribute :type,      :validate => true
  # attribute :email,     :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :email,     :validate => true
  attribute :message
  attribute :nickname,  :captcha  => true

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      :subject => "#{type}: #{subject}",
      :to => "bullcentury@gmail.com",
      :from => %("#{name}" <#{email}>)
    }
  end
end