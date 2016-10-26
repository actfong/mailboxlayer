require "spec_helper"

describe Apilayer::Mailbox do
  before do
    Apilayer::Mailbox.configure do |configs|
      configs.access_key = 'foobar123'
    end
  end

  describe :check do
    subject { Apilayer::Mailbox.check(email) }
    let(:email) { 'support@apilayer.com' }

    it 'returns a Hash with Email validation data' do
      VCR.use_cassette("mailbox/check_without_options") do
        expect(subject).to include(
          'email' => email,
          'did_you_mean' => kind_of(String),
          'user' => "support",
          'domain' => "apilayer.com",
          'format_valid' => boolean,
          'mx_found' => boolean,
          'smtp_check' => boolean,
          'catch_all' => anything,
          'role' => boolean,
          'disposable' => boolean,
          'free' => boolean,
          'score' => kind_of(Float)
        )
      end
    end

    context 'with smtp: false' do
      subject { Apilayer::Mailbox.check(email, smtp: false) }
      specify do
        expect(Apilayer::Mailbox).to receive(:get_and_parse).with(
          'check', hash_including( smtp: 0, email: email)
        )
        subject
      end
    end

    context 'with smtp: true' do
      subject { Apilayer::Mailbox.check(email, smtp: true) }
      specify do
        expect(Apilayer::Mailbox).to receive(:get_and_parse).with(
          'check', hash_including( smtp: 1, email: email)
        )
        subject
      end
    end
  end
end
