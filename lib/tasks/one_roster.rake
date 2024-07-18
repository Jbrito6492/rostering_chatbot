namespace :one_roster do
  desc "Populate User collection in Weaviate cluster with OneRoster data"
  task populate_users: :environment do
    client = Weaviate::Client.new(
      url: ENV["WEAVIATE_URL"],
      api_key: ENV["WEAVIATE_API_KEY"],
      model_service: :openai, # Service that will be used to generate vectors
      model_service_api_key: ENV['OPENAI_KEY']
    )

    users = JSON.parse(File.read(Rails.root.join('lib', 'data', 'fixtures', 'users.json')), symbolize_names: true)
                .dig(:users)

    users.each do |user|
      next unless is_uuid?(user[:sourcedId])

      user[:metadata] = user[:metadata].to_json
      output = client.objects.create(
        class_name: 'User',
        properties: user
      )
      p output
    end
  end
end

def is_uuid?(string)
  string.present? && string.match?(/\A[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}\z/i)
end

# client.objects.list(class_name: 'Users')
