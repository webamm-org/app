require 'json'
require 'gemini-ai'

class GenerateWebammWithGemini
  def self.call(prompt)
    client = ::Gemini.new(
      credentials: {
        service: 'generative-language-api',
        api_key: ENV['GEMINI_API_KEY']
      },
      options: { model: 'gemini-pro', server_sent_events: false }
    )

    system_prompt = <<~SYSTEM_PROMPT
      You are a helpful assistant that based on provided application description generates JSON representation of the application. Example of the JSON representation:

      {
        "authentication": [
          {
            "table": "users",
            "features": ["two_factor_authentication", "invitations", "allow_sign_up", "online_indication"]
          }
        ],
        "database": {
          "engine": "postgresql",
          "relationships": [
            {
              "type": "has_many",
              "source": "projects",
              "destination": "tasks",
              "required": false
            }
          ]
          "schema": [
            {
              "table": "projects",
              "columns": [
                {
                  "name": "title",
                  "null": false,
                  "default": "",
                  "type": "string"
                }
              ]
            },
            {
              "table": "tasks",
              "indices": [
                {
                  "name": "title_idx",
                  "columns": ["title"],
                  "unique": false
                }
              ],
              "columns": [
                {
                  "name": "title",
                  "null": false,
                  "default": "",
                  "type": "string"
                },
                {
                  "name": "completed",
                  "null": false,
                  "default": false,
                  "type": "boolean"
                }
              ]
            }
          ]
        }
      }

      When generating JSON representation of the application, use following rules:

      - Relationship type column value is one of: has_many, has_one, has_many_and_belongs_to_many
      - Relationship required column value is one of: true, false - it means if the relationship is required when creating a new record
      - Schema column null is one of: true, false - it means if the column can be null
      - Schema column type is one of: string, integer, boolean, text, date, datetime, float
      - Schema column default value is a default value for the column, can be string, integer, or boolean. It's required but leave it empty if it's not provided
      - Do not generate any columns for relationships or authentication, they will be detected later based on the types of relationships so do not generate keys like *_id
      - Do not include created_at and updated_at columns
      - Authentication features are one of: two_factor_authentication, invitations, allow_sign_up, online_indication

      Based on the provided application description, generate JSON representation of the application. Assume the most popular database architecture for the application. Remember about foreign keys and indexes. Reply only with JSON representation of the application.
    SYSTEM_PROMPT

    result = client.generate_content({
      contents: { role: 'user', parts: { text: system_prompt } }
    })

    JSON.parse(result['candidates'].first['content']['parts'].first['text'])
  end
end
