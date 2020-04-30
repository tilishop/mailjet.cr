require "../../spec_helper.cr"

describe Mailjet::Message do
  before_each do
    configure_global_api_credentials
  end

  describe ".find" do
    it "returns the found message in an array" do
      WebMock.stub(:get, "https://api.mailjet.com/v3/REST/message/123")
        .to_return(status: 200, body: read_fixture("message/find"))

      response = Mailjet::Message.find({message_id: 123})
      response.data.first.should be_a(Mailjet::Message::ResponseMessage)
    end

    it "finds a message for the given message id" do
      WebMock.stub(:get, "https://api.mailjet.com/v3/REST/message/456")
        .to_return(status: 200, body: read_fixture("message/find"))

      Mailjet::Message.find(456).should be_a(Mailjet::Message::ResponseMessage)
    end
  end

  describe ".all" do
    it "fetches all messages" do
      WebMock.stub(:get, "https://api.mailjet.com/v3/REST/message")
        .to_return(status: 200, body: read_fixture("message/all"))

      response = Mailjet::Message.all
      response.data.first.should be_a(Mailjet::Message::ResponseMessage)
      response.count.should eq(2)
      response.total.should eq(2)
    end

    it "filters messages with query parameters" do
      WebMock.stub(:get, "https://api.mailjet.com/v3/REST/message?ContactAlt=some%40one.com")
        .to_return(status: 200, body: read_fixture("message/all"))

      response = Mailjet::Message.all(query: {
        "ContactAlt": "some@one.com",
      })
      response.data.first.should be_a(Mailjet::Message::ResponseMessage)
      response.count.should eq(2)
      response.total.should eq(2)
    end
  end
end

describe Mailjet::Message::ResponseMessage do
  it "parses message details" do
    response = Mailjet::Message::FindResponse.from_json(
      read_fixture("message/find"))
    message = response.data.first
    message.arrived_at.should be_a(Time)
    message.attachment_count.should eq(0)
    message.attempt_count.should eq(0)
    message.contact_alt.should eq("")
    message.contact_id.should eq(52592753)
    message.delay.should eq(0)
    message.destination_id.should eq(11668846)
    message.filter_time.should eq(0)
    message.id.should eq(576460755655154659)
    message.click_tracked?.should eq(true)
    message.html_part_included?.should eq(true)
    message.open_tracked?.should eq(true)
    message.text_part_included?.should eq(true)
    message.unsub_tracked?.should eq(false)
    message.message_size.should eq(365)
    message.sender_id.should eq(26998)
    message.spamassassin_score.should eq(0)
    message.spamass_rules.should eq("")
    message.state_permanent.should eq(false)
    message.status.should eq("opened")
    message.subject.should eq("")
    message.uuid.should eq("a8774fb0-393a-45e1-ae9a-b0d7c1fe672b")
  end
end
