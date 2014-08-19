require 'test_helper'

class SidekiqMailerConfigureTest < Test::Unit::TestCase
  def setup
    Sidekiq::Mailer.reset
    Sidekiq::Mailer.excluded_environments = []
    ActionMailer::Base.deliveries.clear
    Sidekiq::Mailer::Worker.jobs.clear
  end
  
  def text_last_default_configuration_values
    assert_equal 'mailer', Sidekiq::Mailer.configuration.queue
    assert_equal 'true', Sidekiq::Mailer.configuration.retry
  end

  def test_last_ability_to_set_configuration
    Sidekiq::Mailer.configure do |config|
      config.queue = 'default'
    end
    BasicMailer.welcome('test@example.com').deliver
    assert_equal 'default', Sidekiq::Mailer::Worker.jobs.first['queue']
  end

  def test_last_enables_sidekiq_options_overriding
    Sidekiq::Mailer.configure do |config|
      config.queue = 'default'
    end
    MailerInAnotherQueue.bye('test@example.com').deliver
    assert_equal 'priority', Sidekiq::Mailer::Worker.jobs.first['queue']
    assert_equal 'false', Sidekiq::Mailer::Worker.jobs.first['retry']
  end
end