This is a Rails application that allow users to upload contact files in CSV format and process them in order to generate a unified contact file.

## Tools Version
- ruby 2.6.9
- rails 6.0.4

## Other important gems

- [credit_card_validations](https://github.com/didww/credit_card_validations): verifies that the contact credit card number provided is well-formed.
- [delayed_job_active_record](https://github.com/collectiveidea/delayed_job_active_record): manage the background jobs created when upload a contact CSV file, this jobs validate and import the contacts provided in the CSV file.
- [devise](https://github.com/heartcombo/devise): User authentication and register with email and password.
- [pagy](https://github.com/ddnexus/pagy): Paginate the contact files and contacts list.
- [phonelib](https://github.com/daddyz/phonelib): Validate contact phone number.
- [roo](https://github.com/roo-rb/roo): Used for read and process the CSV files uploaded.

## Important:
To save files locally [Active Storage](https://edgeguides.rubyonrails.org/active_storage_overview.html) is used in this project.

## Local installation

Assuming you've just cloned the repo, follow this steps to setup the project in your machine:

- Install gems:
    $ bundle
    
- Setup database (this will also create a test user):
    $ rails db:setup
    
- Run the rails server:
    $ rails s

## Usage

After complete the setup, you can login in the platform with the test user:
email: user_1@gmail.com
password: securepassword

We can navigate on the platform by 3 views:

- Contact List: /contacts
![Captura de pantalla 2022-01-24 a las 1 01 10](https://user-images.githubusercontent.com/35356671/150730044-59bbd140-0f5f-4117-9f54-2bcf4bf37030.png)

- Import Contacts: /contact_files/new
![Captura de pantalla 2022-01-24 a las 1 01 58](https://user-images.githubusercontent.com/35356671/150730120-ccf265e3-b4ee-479d-92d1-ea2b6a18f91e.png)

- Contact File Lists: /contact_files
![Captura de pantalla 2022-01-24 a las 1 02 37](https://user-images.githubusercontent.com/35356671/150730177-f967e95b-c1fa-42dc-8a45-c23dd1b63b59.png)

## Test files

You can find the test files in this project path:
  $ contact-app/spec/factories/files/
  
## Test files list
### Valid files

- with_two_valid_contacts.csv: two contacts with completely valid data.
- repeated_email_valid.csv: repeated email but in contact from another user.
- only_with_columns.csv: empty file without contacts, only columns.
- empty.csv: completely empty file.

### Invalid files

- incomplete_columns.csv: with incomplete columns (all the columns are required).
- incomplete_data.csv: complete columns but some incomplete data.
- invalid_date.csv: date that doesn't have the format %Y%m%d or (%F).
- invalid_email.csv: contact with invalid email.
- invalid_name.csv: name with invalid special characters (only minus or spaces are valid).
- invalid_phone.csv: contact with invalid format phone.
- repeated_email.csv: to test this file, you must have previously created a contact with the email: adrian@gmail.com
