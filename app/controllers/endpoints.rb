require 'webhookmessages'

module EndPoints
  include WebHookMessages

  def event_webhook

      payload = Payload.new(request.body.read)
      data = Event.create(payload.process)

      web_response(*STATUS[data.valid?])

  rescue JSON::ParserError => e

      web_response(400, :invalid_payload)
  end

  def event_endpoint

    response['Content-Type'] = 'application/json'
    result_data = JSON.parse(Event.actions_and_records)

    JSON.pretty_generate result_data 

  end

end
