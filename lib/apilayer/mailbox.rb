##
# Ruby wrapper for mailboxlayer. See https://mailboxlayer.com/documentation for more info
module Apilayer
  module Mailbox
    extend ConnectionHelper

    INVALID_OPTIONS_MSG = 'You have provided an invalid option. Only :smtp is allowed'

    ## Validations
    #
    def self.validate_options(options)
      options.keys.each do |key|
        unless [:smtp].include? key
          raise Apilayer::Error.new(INVALID_OPTIONS_MSG)
        end
      end
    end

    ##
    # Api-Method: Calls the /check endpoint to verify the existence of an email address
    #
    # Examples:
    #   Apilayer::Mailbox.check('support@apilayer.com')
    #   Apilayer::Mailbox.check('support@apilayer.com', {smtp: false}) # If you don't want to perform smtp checks
    def self.check(email, opts={})
      validate_options(opts)
      opts = assign_smtp_value(opts)
      params = { email: email }.merge(opts)
      get_and_parse("check", params)
    end

    private
    def self.assign_smtp_value(opts)
      if opts[:smtp] == false
        { smtp: 0 }
      else
        { smtp: 1 }
      end
    end
  end
end
