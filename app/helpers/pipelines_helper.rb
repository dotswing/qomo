module PipelinesHelper

  def pipeline_ref(pipeline)
    <<REF
#{pipeline.owner.full_name} (#{pipeline.created_at.strftime '%Y'}) Pipeline: "#{pipeline.title}" in Qomo paltform,
  available at
  <em>#{pipeline_url(pipeline)}</em>
  (Last update: #{pipeline.updated_at.strftime '%b %d, %Y'}).
REF
  end

end
