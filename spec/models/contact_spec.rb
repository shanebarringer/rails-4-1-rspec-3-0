require 'rails_helper'

describe "Contact" do
  it 'has a valid factory' do
    expect(build(:contact)).to be_valid
  end

  it 'has 3 phone numbers' do
    expect(create(:contact).phones.count).to eq(3)
  end

  it 'is valid with a firstname, lastname and email' do
    contact = build(:contact)

    expect(contact).to be_valid
  end

  it 'is invalid without firstname' do
    contact = build(:contact, firstname: nil)
    contact.valid?
    expect(contact.errors[:firstname]).to include("can't be blank")
  end

  it 'is invalid without lastname' do
    contact = build(:contact, lastname: nil)
    contact.valid?
    expect(contact.errors[:lastname]).to include("can't be blank")
  end

  it 'is invalid without email' do
    contact = build(:contact, email: nil)
    contact.valid?
    expect(contact.errors[:email]).to include("can't be blank")
  end

  it 'is invalid with a duplicate email' do
      create(:contact, email: 'shane@example.com')

      contact = build(:contact, firstname: 'foo', lastname: 'bar', email: 'shane@example.com')

      contact.valid?

      expect(contact.errors[:email]).to include('has already been taken')
  end


  it 'returns full name as a string' do
    contact = build(:contact,
      firstname: 'foo',
      lastname: 'bar')

    expect(contact.name).to eq('foo bar')
  end

  describe 'filter last name by letter' do

    before :each do
      @smith = create(:contact,
        firstname: 'John',
        lastname: 'Smith',
        email: 'jsmith@example.com'
      )
      @jones = create(:contact,
        firstname: 'Tim',
        lastname: 'Jones',
        email: 'tjones@example.com'
      )
      @johnson = create(:contact,
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
