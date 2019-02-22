# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_widgets_session',
  :secret      => 'd72cd2eb3c4bd4d67b8f23992e648e0329a52d1b08c3a6fae213d17ff558be1fceadf0c9e0bf91c9f6ac6fc7cff653c6aa3684b4289c3d9d3e87f11f4b621269'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
