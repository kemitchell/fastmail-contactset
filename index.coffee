# TODO: Argument checking
# TODO: Help message
# TODO: Remove functionality to a module
# TODO: Delete multiple pages of contacts

Nightmare = require 'nightmare'

EMAIL = process.argv[2]
PASSWORD = process.argv[3]
FILE = process.argv[4]

LONG_PAUSE = 1000
SHORT_PAUSE = 200

# Log in to Fastmail
login = (email, password) ->
  (nightmare) ->
    console.log "Logging in"
    nightmare
    .goto 'https://www.fastmail.fm/'
    .wait()
    .type '#username', email
    .type '#password', password
    # Access the simplified HTML interface
    .click '#use_html'
    .click '#loginSubmit'
    .wait()

# Delete all contacts in the Address Book
deleteContacts = ->
  (nightmare) ->
    console.log 'Deleting existing contacts'
    nightmare
    .click '#navContacts a'
    .wait LONG_PAUSE
    .click '.itemsToDisplay a:last-child'
    .wait LONG_PAUSE
    .click '#checkAll'
    .wait SHORT_PAUSE
    .click 'button[name="MSignal_AD-DA*"]'
    .wait()

uploadContacts = (file) ->
  (nightmare) ->
    console.log "Uploading contacts from #{file}"
    nightmare
    .click '.actionImportExport'
    .wait LONG_PAUSE
    .upload 'input[type=file]', file
    .wait SHORT_PAUSE
    .click 'form#memail *[name="MSignal_UA-Upload*"]'
    .wait()

new Nightmare()
# Fastmail doesn't display a "select all" contacts checkbox for all user
# agent strings.
.useragent 'Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) " +
  "AppleWebKit/528.8 (KHTML, like Gecko) Chrome/1.0.156.0 Safari/528.8'
.use login EMAIL, PASSWORD
.use deleteContacts()
.use uploadContacts FILE
.run()
