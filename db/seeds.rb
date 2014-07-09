def try_load_tools(dir)
  tools_def = Hash.from_xml File.read(File.join(dir, 'tool.xml'))

  for t in tools_def
    Tool.transaction do
      t = t[1]
      tool = Tool.new
      unless t.has_key? 'id'
        puts "ATTR id required for this tool: #{dir}"
        next
      end
      tool.id = t['id']
      tool.title = t['title']
      tool.contributor = t['contributor']
      tool.command = t['command'].strip

      tool.group = ToolGroup.find_or_create_by title: t['group_title']
      tool.usage = File.read(File.join dir, "usage.md")

      tool.dirname = File.basename dir

      params = []

      for p in t['params']
        param = {}
        param['type'] = p[0]
        param['name'] = p[1]['name']
        param['label'] = p[1]['label']
        param['value'] = p[1]['value']

        if param['type'] == 'select'
          param['options'] = p[1]['option']
        end

        params << param
      end

      tool.params = params

      tool.active!

      tool.save
    end

  end

end


Dir["#{Settings.home}/*"].map do |d|
  try_load_tools d
end
