module MessagesHelper
  def format_content_with_embedded_json(content)
    content.gsub!(/```(.*?)```/m) do
      json_string = $1.strip
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
