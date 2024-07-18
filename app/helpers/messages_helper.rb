module MessagesHelper
  require 'json'

  def format_content_with_embedded_json(content)
    regex = /```(.*?)```|(\{.*?})/m

    content.gsub!(regex) do |match|
      json_string = match.strip
      json_string.gsub!(/```/, '')
      begin
        json_pretty = JSON.pretty_generate(JSON.parse(json_string))
        "<pre class='bg-gray-200 p-2 rounded'><code>#{json_pretty}</code></pre>"
      rescue JSON::ParserError, JSON::GeneratorError
        "<pre class='bg-gray-200 p-2 rounded'><code>#{json_string}</code></pre>"
      end
    end
    content.html_safe
  end
end
