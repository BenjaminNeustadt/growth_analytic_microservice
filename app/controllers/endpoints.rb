require 'webhookmessages'

module EndPoints
  include WebHookMessageHelper

  def process_webhook_payload

      payload = Payload.new(request.body.read).process
      record = payload.include?(:name) ? Event.create(payload) : PageView.create(payload)

      web_response(*STATUS[record.valid?])

  rescue JSON::ParserError => e
      web_response(400, :invalid_payload)
      
  end

  def event_endpoint

    response['Content-Type'] = 'application/json'
    result_data = JSON.parse(Event.actions_and_records)

    JSON.pretty_generate result_data 

  end

end
