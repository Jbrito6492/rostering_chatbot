namespace :one_roster do
  desc "Populate Users collection in Weaviate cluster with OneRoster data"
  task populate_users: :environment do
    client = Weaviate::Client.new(
      url: ENV["WEAVIATE_URL"],
      api_key: ENV["WEAVIATE_API_KEY"],
      model_service: :openai,
      model_service_api_key: ENV['OPENAI_KEY']
    )

    users = JSON.parse(File.read(Rails.root.join('lib', 'data', 'fixtures', 'users.json')), symbolize_names: true)
                .dig(:users)

    users.each do |user|
      user[:metadata] = user[:metadata].to_json
      output = client.objects.create(
        class_name: 'User',
        properties: user
      )
      p output
    end
  end
end

# client.objects.list(class_name: 'User')
