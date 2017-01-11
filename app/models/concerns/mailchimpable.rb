module Mailchimpable
  def create_segment(segment_name)
    api_client.lists(mailchimp_list_id).segments.create(body: {
      name: segment_name,
      static_segment: []
    })
  end


  def subscribe_to_list(email, merge_vars, options = {})
    begin
      if options[:update_existing]
        api_client.lists(mailchimp_list_id).members(Digest::MD5.hexdigest(email)).upsert(body: create_body(email, merge_vars: merge_vars, options: options))
      else
        api_client.lists(mailchimp_list_id).members.create(body: create_body(email, merge_vars: merge_vars, options: options))
      end
    rescue StandardError => e
      logger.error(e)
    end
  end


  def subscribe_to_segment(segment_id, email)
    begin
      api_client.lists(mailchimp_list_id).segments(segment_id).members.create(body: {
        email_address: email
      })
    rescue StandardError => e
      logger.error(e)
    end
  end


  def update_member(email, options)
    begin
      api_client.lists(mailchimp_list_id).members(Digest::MD5.hexdigest(email)).update(body: create_body(email, options: options))
    rescue StandardError => e
      logger.error(e)
    end
  end

  def groupings
    (
      (
        activist.activist_pressures.map{|ap| ap.community.mailchimp_group_id if ap.community } | 
        activist.activist_matches.map{|am| am.community.mailchimp_group_id if am.community} | 
        activist.form_entries.map{|en| en.community.mailchimp_group_id if en.community}
      ) - [nil]
    ).map {|key| [key, true]}.to_h
  end

  private

  def mailchimp_list_id
    community.try(:mailchimp_list_id) || ENV['MAILCHIMP_LIST_ID']
  end

  def mailchimp_group_id
    community.try(:mailchimp_group_id) || ENV['MAILCHIMP_GROUP_ID']
  end

  def mailchimp_api_key
    community.try(:mailchimp_api_key) || ENV['MAILCHIMP_API_KEY']
  end

  def api_client
    Gibbon::Request.new(api_key: mailchimp_api_key)
  end

  def create_body email, merge_vars: nil, options: {}    
    body = { }
    if merge_vars
      body = {
        email_address: email,
        status: :subscribed,
      }
      body[:merge_fields] = merge_vars if merge_vars
    end
    body[:interests] = options[:groupings] if options[:groupings]
    body
  end
end
