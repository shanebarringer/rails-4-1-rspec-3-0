require 'rails_helper'

describe "Contact" do
  it 'is valid with a firstname, lastname and email' do
    contact = Contact.new(
      firstname: 'Shane',
      lastname: 'Barringer',
      email: 'shane@example.com'
    )

    expect(contact).to be_valid
  end

  it 'is invalid without firstname' do
    contact = Contact.new(firstname: nil)
    contact.valid?
    expect(contact.errors[:firstname]).to include("can't be blank")
  end

  it 'is invalid without lastname' do
    contact = Contact.new(lastname: nil)
    contact.valid?
    expect(contact.errors[:lastname]).to include("can't be blank")
  end

  it 'is invalid without email' do
    contact = Contact.new(email: nil)
    contact.valid?
    expect(contact.errors[:email]).to include("can't be blank")
  end

  it 'is invalid with a duplicate email' do
      Contact.create(firstname: 'shane', lastname: 'barringer', email: 'shane@example.com')

      contact = Contact.new(firstname: 'foo', lastname: 'bar', email: 'shane@example.com')

      contact.valid?

      expect(contact.errors[:email]).to include('has already been taken')
  end


  it 'returns full name as a string' do
    contact = Contact.new(firstname: 'shane', lastname: 'barringer', email: 'shane@example.com')

    expect(contact.name).to eq('shane barringer')
  end

  describe 'filter last name by letter' do

    before :each do
      @smith = Contact.create(
        firstname: 'John',
        lastname: 'Smith',
        email: 'jsmith@example.com'
      )
      @jones = Contact.create(
        firstname: 'Tim',
        lastname: 'Jones',
        email: 'tjones@example.com'
      )
      @johnson = Contact.create(
        firstname: 'John',
        lastname: 'Johnson',
        email: 'jjohnson@example.com'
      )
    end

    context 'matching letters' do
      it 'returns a sorted array of results that match' do
        expect(Contact.by_letter("J")).to eq([@johnson, @jones])
      end
    end

    context "non-matching letters" do

      it 'omits results that do not match' do
        expect(Contact.by_letter("J")).not_to include(@smith)
      end
    end
  end
end
