module ToolsHelper

  def tool_ref(tool)
    <<REF
  #{tool.contributor} (#{tool.created_at.strftime '%Y'}) Tool: "#{tool.title}" in Qomo paltform,
  available at
  <em>#{tool_url(tool)}</em>
  (Last update: #{tool.updated_at.strftime '%b %d, %Y'}).
REF
  end

end
