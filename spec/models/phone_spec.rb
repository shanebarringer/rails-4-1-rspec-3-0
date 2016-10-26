require 'rails_helper'

describe "Phone" do
  it 'does not allow duplicate phone numbers per contact' do
    contact = Contact.create(
      firstname: "shane",
      lastname: "barringer",
      email: "shane@example.com"
    )
    contact.phones.create(
      phone_type: 'home',
      phone: '555-555-5555'
    )
    mobile_phone = contact.phones.build(
      phone_type: 'mobile',
      phone: '555-555-5555'
    )

    mobile_phone.valid?

    expect(mobile_phone.errors[:phone]).to include('has already been taken')
  end

  it 'allows to contacts to share a phone number' do
    contact = Contact.create(
      firstname: 'shane',
      lastname: 'barringer',
      email: 'shane@example.com'
    )
    contact.phones.create(
      phone_type: 'home',
      phone: '555-555-5555'
    )

    other_contact = Contact.new()
    other_phone = other_contact.phones.build(
      phone_type: 'home',
      phone: '555-555-5555'
    )

    expect(other_phone).to be_valid
  end
end
