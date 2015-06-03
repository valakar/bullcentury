class ProjectMailer < ActionMailer::Base
  default from: "madmacj@gmail.com"

  def set_for_review(project)
    @project = project
    #@url  = 'http://example.com/login'
    mail(to: @project.author.email, subject: (project.name + ' notification'))
  end
end
