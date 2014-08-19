ENV['RACK_ENV'] = ENV['RAILS_ENV'] = 'test'
require 'test/unit'

require 'action_mailer'
ActionMailer::Base.delivery_method = :test

require 'sidekiq'
require 'sidekiq/testing'

require 'sidekiq_mailer'


class BasicMailer < ActionMailer::Base
  include Sidekiq::Mailer

  default :from => "from@example.org", :subject => "Subject"

  def welcome(to)
    mail(to: to) do |format|
      format.text { render :text => "Hello Mikel!" }
      format.html { render :text => "<h1>Hello Mikel!</h1>" }
    end
  end

  def hi(to, name)
    mail(to: to) do |format|
      format.text { render :text => "Hello Mikel!" }
      format.html { render :text => "<h1>Hello Mikel!</h1>" }
    end
  end
end

class MailerInAnotherQueue < ActionMailer::Base
  include Sidekiq::Mailer
  sidekiq_options queue: 'priority', retry: 'false'

  default :from => "from@example.org", :subject => "Subject"

  def bye(to)
    mail(to: to)
  end
end


class PreventSomeEmails
  def self.delivering_email(message)
    if message.to.include?("foo@example.com")
      message.perform_deliveries = false
    end
  end
end

ActionMailer::Base.register_interceptor(PreventSomeEmails)