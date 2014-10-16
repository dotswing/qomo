module Qomo
  module HDFS

    @@client = WebHDFS::Client.new(Settings.hdfs.host, Settings.hdfs.port, Settings.hdfs.user)

    def hdfs
      Client.new @@client, Settings.hdfs.root
    end


    class Client

      def initialize(c, root)
        @c = c
        @root = root
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


      def rpath(*args)
        args.prepend @root
        args.join '/'
      end


      def urpath(uid, *args)
        args.prepend uid, @uid
        args.prepend @root
        args.join '/'
      end

    end


  end
end
