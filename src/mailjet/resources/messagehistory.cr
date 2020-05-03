struct Mailjet
  struct Messagehistory < Resource
    alias ResponseData = Array(Event)

    # Fetches the history of a message
    #
    # ```crystal
    # response = Mailjet::Messagehistory.all(params: {id: 576460754655154659})
    # response.data.first.event_type
    # # => "opened"
    # ```
    #
    can_list("REST/messagehistory/:id", ResponseData)

    # Convenience method allowing to pass the message id and returning the array
    # of events directly
    #
    # ```crystal
    # events = Mailjet::Messagehistory.all(576460754655154659)
    # events.first.event_type
    # # => "opened"
    # ```
    #
    def self.all(
      id : Int64 | String,
      client : Client = Client.new
    )
      all(params: {id: id}, client: client).data
    end

    struct Event
      include Json::Fields

      json_fields({
        "Comment":     String,
        "EventAt":     {type: Time, converter: Time::EpochConverter},
        "EventType":   String,
        "State":       String,
        "Useragent":   String,
        "UseragentID": Int32,
      })
    end
  end
end