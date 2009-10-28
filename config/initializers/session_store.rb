# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_classident_session',
  :secret      => 'fee9f3c28ee22303279e1c51a7ed133b0b6bd710f1cb8cfdd64dbc3ac7b83b236f556b4b15652b3c99dcbcfecd94d1ddc5e26561d1b7a4e7c9a6c97dc25db3e3'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
