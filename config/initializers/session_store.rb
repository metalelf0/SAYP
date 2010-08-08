# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_activeSoseNG_session',
  :secret      => 'b680e2c541ffbcda2c8d9f9e3b8ad38f704264fe363eea59bd8b4e9c89478be0edf7de31df1842da93300e290d872fe2706c44fabe7d45724a36214a37b00bae'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
