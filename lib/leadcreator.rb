require 'restforce'

class Lead

  def initialize(instance_url:, client_id:, client_secret:, oauth_token:)
    credential = {:instance_url => instance_url,
                  :client_id => client_id,
                  :client_secret => client_secret,
                  :oauth_token => oauth_token
    }
    @client = Restforce.new(credential)
  end


  def create(name:, last_name:, email:, company:, job_title:, phone:, website:)
    raise ArgumentError.new 'last_name and company are required' if company.empty? || last_name.empty?
    attributes =
        {
            FirstName: name,
            LastName: last_name,
            Email: email,
            Company: company,
            Title: job_title,
            Phone: phone,
            Website: website
        }
    @client.create!('Lead', attributes)
  end
end
