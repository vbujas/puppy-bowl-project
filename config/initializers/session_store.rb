# Be sure to restart your server when you modify this file.

# Rails.application.config.session_store :cookie_store, key: 'PuppyBowlSession'

if Rails.env.development?
  Rails.application.config.session_store :cookie_store, key: 'PuppyBowlStagingSession'
elsif Rails.env.production?
  Rails.application.config.session_store :cookie_store, key: 'PuppyBowlStagingSession', domain: ".puppy-bowl-staging.herokuapp.com"
end
