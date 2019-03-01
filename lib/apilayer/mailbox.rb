##
# Ruby wrapper for mailboxlayer. See https://mailboxlayer.com/documentation for more info
module Apilayer
  module Mailbox
    extend ConnectionHelper

    DEFAULT_OPTIONS = { smtp: 1, catch_all: 0 }
    INVALID_OPTIONS_MSG = "You have provided an invalid option. Only :smtp and :catch_all are allowed"

    ## Validations
    #
    def self.validate_options(options)
      options.keys.each do |key|
        unless DEFAULT_OPTIONS.keys.include? key
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
    #   Apilayer::Mailbox.check('support@apilayer.com', {catch_all: true}) # If you want to perform catch_all detection
    def self.check(email, opts={})
      validate_options(opts)
      opts = assign_options_values(opts)
      params = { email: email }.merge(opts)
      get_and_parse("check", params)
    end

    def self.assign_options_values(opts)
      DEFAULT_OPTIONS.merge Hash[opts.map{ |k,v| [k, (v ? 1 : 0)] }]
    end
  end
end
