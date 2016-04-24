class BaseCommand
  def process
  end

  def response_text=(text)
    @response_text = text
  end

  def response_text
    @response_text ||= nil
  end

  def response_attachments=(arr)
    @response_attachments = arr
  end

  def response_attachments
    @response_attachments ||= []
  end

  def in_channel=(val)
    @in_channel = val === true
  end

  def in_channel
    @in_channel ||= false
  end

  def slackbot_response
    response = {}
    response[:text] = response_text
    response[:attachments] = response_attachments.map{|t| {text: t}}
    response[:response_type] = 'in_channel' if in_channel
    response
  end
end
