module Qomo
  module HDFS

    @@client = WebHDFS::Client.new(Settings.hdfs.web.host, Settings.hdfs.web.port, Settings.hdfs.web.user)

    def hdfs
      Client.new @@client, Settings.hdfs.root, Settings.hdfs.url
    end


    class Client

      def initialize(c, root, url)
        @c = c
        @root = root
        @url = url
      end


      def ls(*args)
        @c.list rpath(args)
      end


      def create(local, *args)
        @c.create rpath(*args), local
      end


      def mkdir(*args)
        path = rpath args
        @c.mkdirs path
      end

      alias :mkdirs :mkdir


      def delete(*args)
        path = rpath args
        @c.delete path, recursive: true
      end


      def read(*args)
        path = rpath args
        file = Tempfile.new('hdfsfile')
        parts = nil
        if stat(args)['type'] == 'DIRECTORY'
          parts = []
          ls(args).each do |e|
            if e['pathSuffix'].start_with?('part-')
              parts << File.join(path, e['pathSuffix'])
            end
          end
        else
          parts = [path]
        end
        parts.each do |p|
          `wget -O - "http://#{Settings.hdfs.web.host}:#{Settings.hdfs.web.port}/webhdfs/v1#{p}?op=OPEN&user.name=#{Settings.hdfs.web.user}" >> "#{file.to_path}"`
        end

        file.to_path
      end


      def stat(*args)
        path = rpath args
        @c.stat path
      end


      def rpath(*args)
        args.prepend @root
        args.join '/'
      end


      def urpath(uid, *args)
        args.prepend uid, @uid
        args.prepend @root
        args.join '/'
      end


      def apath(*args)
        File.join @url, rpath(args)
      end

    end


  end
end
