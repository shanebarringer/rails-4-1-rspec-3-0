require 'rails_helper'

describe "Phone" do
  it 'does not allow duplicate phone numbers per contact' do
    contact = create(:contact)

    create(:home_phone,
            contact: contact,
            phone: '555-555-5555')

    mobile_phone = build(:mobile_phone,
                          contact: contact,
                          phone: '555-555-5555')

    mobile_phone.valid?

    expect(mobile_phone.errors[:phone]).to include('has already been taken')
  end

  it 'allows to contacts to share a phone number' do
    create(:home_phone, phone: '555-555-5555')

    expect(build(:home_phone, phone: '555-555-5555')).to be_valid
  end
end
