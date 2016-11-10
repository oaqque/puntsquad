Maktoub.from = "contact@puntsquad.com" # the email the newsletter is sent from
Maktoub.twitter_url = "http://twitter.com/puntsquad" # your twitter page
Maktoub.facebook_url = "http://www.facebook.com/puntsquad/" # your facebook page
# Maktoub.linkedin_url = "http://www.linkedin.com/company/linkedin" # your linkedin page
# Maktoub.subscription_preferences_url = "http://example.com/manage_subscriptions" #subscribers management url
Maktoub.logo = "logo-text.png" # path to your logo asset
Maktoub.home_domain = "puntsquad.com" # your domain
Maktoub.app_name = "PuntSquad" # your app name
# Maktoub.unsubscribe_method = "unsubscribe" # method to call from unsubscribe link (doesn't include link by default)

# pass a block to subscribers_extractor that returns an object that  reponds to :name and :email
# (fields can be configured as shown below)

require "ostruct"
Maktoub.subscribers_extractor do
  User.all.map do |i|
    users << OpenStruct.new({name: i.email, email: i.email})
  end
end

# uncomment lines below to change subscriber fields that contain email and
# Maktoub.email_field = :address
# Maktoub.name_field = :nickname
