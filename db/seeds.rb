User.create(email: 'user_1@gmail.com', password: 'securepassword')
second_user = User.create(email: 'user_2@gmail.com', password: 'securepassword')

second_user.contacts.create(
  name: 'Test Name',
  phone: '(+57) 320-432-05-09',
  address: 'Test Address',
  credit_card: '371449635398431',
  franchise: 'amex',
  email: 'adrian@gmail.com'
)
