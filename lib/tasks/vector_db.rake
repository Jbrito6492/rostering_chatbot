require 'weaviate'

namespace :vector_db do
  desc "Create a schema for the user"
  task create_user_schema: :environment do
    client = Weaviate::Client.new(
      url: ENV["WEAVIATE_URL"],
      api_key: ENV["WEAVIATE_API_KEY"],
      model_service: :openai,
      model_service_api_key: ENV['OPENAI_KEY'] # Either OpenAI, Azure OpenAI, Cohere, Hugging Face or Google PaLM api key
    )

    puts "creating user schema..."
    client.schema.create(
      class_name: 'User',
      description: 'a user adhering to OneRoster 1.1 standard',
      properties: [
        {
          "dataType": ["uuid"],
          "description": "The user's sourcedId",
          "name": "sourcedId"
        }, {
          "dataType": ["text"],
          "description": "The user's status, e.g. active, inactive, tobedeleted",
          "name": "status"
        }, {
          "dataType": ["date"],
          "description": "Timestamp of when the user was last modified",
          "name": "dateLastModified"
        }, {
          "dataType": ["text"],
          "description": "Information about the user",
          "name": "metadata",
        }, {
          "dataType": ["text"],
          "description": "The user's username",
          "name": "username"
        }, {
          "dataType": ["object[]"],
          "description": "A list of the user's ids",
          "name": "userIds",
          "nestedProperties": [
            {
              "dataType": ["text"],
              "name": "type"
            },
            {
              "dataType": ["text"],
              "name": "identifier"
            }
          ]
        }, {
          "dataType": ["text"],
          "description": "Whether the user is enabled",
          "name": "enabledUser"
        }, {
          "dataType": ["text"],
          "description": "The user's given name",
          "name": "givenName"
        }, {
          "dataType": ["text"],
          "description": "The user's family name",
          "name": "familyName"
        }, {
          "dataType": ["text"],
          "description": "The user's middle name",
          "name": "middleName"
        }, {
          "dataType": ["text"],
          "description": "The user's role, e.g. student, teacher, parent, administrator, aide, guardian, proctor, relative",
          "name": "role"
        }, {
          "dataType": ["text"],
          "description": "The user's identifier",
          "name": "identifier"
        }, {
          "dataType": ["text"],
          "description": "The user's email",
          "name": "email"
        }, {
          "dataType": ["text"],
          "description": "The user's phone number",
          "name": "phone"
        }, {
          "dataType": ["text"],
          "description": "The user's mobile phone number",
          "name": "sms"
        }, {
          "dataType": ["object[]"],
          "description": "The user's agents",
          "name": "agents",
          "nestedProperties": [
            {
              "dataType": ["text"],
              "description": "The agent's sourcedId",
              "name": "sourcedId"
            }, {
              "dataType": ["text"],
              "description": "The reference link to the agent",
              "name": "href"
            }, {
              "dataType": ["text"],
              "description": "The type of agent",
              "name": "type"
            }
          ]
        }, {
          "dataType": ["object[]"],
          "description": "The user's organizations",
          "name": "orgs",
          "nestedProperties": [
            {
              "dataType": ["text"],
              "description": "The organization's sourcedId",
              "name": "sourcedId"
            }, {
              "dataType": ["text"],
              "description": "The reference link to the organization",
              "name": "href"
            }, {
              "dataType": ["text"],
              "description": "The type of organization",
              "name": "type"
            }
          ]
        }, {
          "dataType": ["text[]"],
          "description": "The user's grades",
          "name": "grades"
        }, {
          "dataType": ["text"],
          "description": "The user's password",
          "name": "password"
        }
      ],
      vectorizer: "text2vec-openai"
    )
  end
end
