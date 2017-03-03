class SendgridEventProcessor
  def call(event)
    begin
      SendgridEvent.create!(
        notification_id: event.attributes['notification_id'].to_i,
        notification_user: event.attributes['notification_user'].to_i,
        notification_type: event.attributes['notification_type'],
        template_name: event.attributes['template_name'],
        event: event.attributes['event'],
        email: event.attributes['email'],
        useragent: event.attributes['useragent'],
        sendgrid_data: event.attributes.to_json
      ) if event.attributes['notification_type'].present?
    rescue Exception => e
      Raven.extra_context(sengrid_event: event.attributes)
      Raven.capture_exception(e)
      Raven.extra_context({})
    end
  end
end
