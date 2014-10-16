namespace :qomo do
  namespace :tools do

    desc 'QOMO | Load tools from $QOMO_HOME/tools'
    task load: :environment do
      def try_load_tools(dir)
        tools_def = Hash.from_xml File.read(File.join(dir, 'tools.xml'))

        for t in tools_def['tools']
          Tool.transaction do
            t = t[1]
            tool = Tool.new
            unless t.has_key? 'id'
              puts "ATTR id required for this tool: #{dir}"
              next
            end

            tool.title = t['title']
            tool.contributor = t['contributor']
            tool.command = t['command'].strip

            tool.group = ToolGroup.find_or_create_by title: t['group']
            tool.usage = File.read(File.join dir, "#{t['id']}.md")

            tool.dirname = File.basename dir

            tool.owner = User.find_by_username Settings.admin.username

            params = []

            for p in t['params']
              param = {}
              param['type'] = p[0]
              param['name'] = p[1]['name']
              param['label'] = p[1]['label']
              param['value'] = p[1]['value']

              if param['type'] == 'select'
                param['options'] = p[1]['option']

                for o in param['options']
                  if o['selected'] == 'true'
                    o['selected'] = true
                  else
                    o['selected'] = false
                  end
                end

                if p[1]['multiple'] == 'true'
                  param['multiple'] = true
                  param['separator'] = p[1]['separator'] || ''
                else
                  param['multiple'] = false
                end
              end

              params << param
            end

            tool.params = params

            tool.active!

            tool.save
          end

        end

      end


      Dir["#{Settings.home}/tools/*"].map do |d|
        try_load_tools d
      end

    end

  end
end
