require "test_helper"

class ContactMailerTest < ActionMailer::TestCase
  test "inquiry_received" do
    mail = ContactMailer.inquiry_received
    assert_equal "Inquiry received", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
