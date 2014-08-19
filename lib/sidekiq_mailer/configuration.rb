module Sidekiq
  module Mailer
    class Configuration
      attr_accessor :queue, :retry

      def initialize
        @queue = 'mailer'
        @retry = true
      end
    end
  end
end
