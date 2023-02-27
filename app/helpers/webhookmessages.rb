module WebHookMessageHelper

  STATUS = { 
    true => [200, :valid],
    false => [400, :invalid],
  }

  MESSAGE = {
    valid: 'Webhook data stored successfully',
    invalid: 'Error: invalid event data',
    invalid_payload: 'Error: invalid JSON payload',
    absent_data: "No data available"
  }

  def web_response(code, message)
    status code 
    MESSAGE[message]
  end

end
