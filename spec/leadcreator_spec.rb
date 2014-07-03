require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Leadcreator' do

  context 'when initializing' do
    let(:attributes) do
      {
          instance_url: Faker::Internet.url,
          client_id: Faker::Lorem.characters(45),
          client_secret: Faker::Number.number(10),
          oauth_token: Faker::Lorem.characters(10)
      }
    end

    it 'should not accept missing parameters' do
      expect { Lead.new }.to raise_error
      expect { Lead.new(attributes.delete(:instance_url)) }.to raise_error
    end

    it 'should accept when all parameters are present' do
      expect { Lead.new(attributes) }.to_not raise_error
    end
  end

  context 'when creating lead' do
    let(:lead) { Lead.new(instance_url: 'https://naX.salesforce.com', client_id: Faker::Lorem.characters(45), client_secret: Faker::Number.number(10), oauth_token: Faker::Lorem.characters(10)) }
    let(:attributes) do
      {
          name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: Faker::Internet.email,
          company: Faker::Company.name,
          job_title: Faker::Lorem.sentence(3),
          phone: Faker::PhoneNumber.phone_number,
          website: Faker::Internet.url
      }
    end
    it 'should not accept missing parameters' do
      expect { lead.create(attributes.delete(:first_name)).to raise_error }
    end

    it 'should not accept empty last_name nor company' do
      attributes[:lastname] = ''
      expect { lead.create(attributes) }.to raise_error
      attributes[:lastname] = Faker::Name.last_name
      attributes[:company] = ''
      expect { lead.create(attributes) }.to raise_error
    end

    it 'should accept all parameters' do
      stub_request(:post, 'https://nax.salesforce.com/services/data/v26.0/sobjects/Lead').
          with(:body => attributes.to_json,
               headers: {'Content-Type' => 'application/json'}).to_return(status: 200, body: '', headers: {})
      response = lead.create(attributes)
      response.should eq('id')
    end
  end

end