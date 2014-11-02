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
        (@c.list rpath(args)).reject { |e| e['pathSuffix'] == '.tmp' }
      end


      def uls(uid, *args)
        ls(upath uid, args)
      end


      def create(local, *args)
        pp rpath(*args)
        @c.create rpath(*args), local
      end

      def ucreate(uid, local, *args)
        create(local, upath(uid, args))
      end


      def mkdir(*args)
        path = rpath args
        @c.mkdirs path
      end


      def umkdir(uid, *args)
        mkdir(upath uid, args)
      end


      def delete(*args)
        path = rpath args
        @c.delete path, recursive: true
      end


      def udelete(uid, *args)
        delete(upath uid, args)
      end


      def ln(f, t)
        c = "curl -i -X PUT \"http://#{Settings.hdfs.web.host}:#{Settings.hdfs.web.port}/#{f}?op=CREATESYMLINK&destination=#{t}&createParent=true&user.name=#{Settings.hdfs.web.user}\""
        pp c
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


      def uread(uid, *args)
        read(upath uid, args)
      end


      def stat(*args)
        path = rpath args
        @c.stat path
      end


      def ustat(uid, *args)
        stat(upath uid, args)
      end


      def rpath(*args)
        args.unshift @root
        args.join '/'
      end


      def upath(uid, *args)
        File.join 'users', ppath(uid, *args)
      end


      def urpath(uid, *args)
        File.join @root, upath(uid, args)
      end


      def ppath(uid, *args)
        File.join uid, args
      end


      def apath(*args)
        File.join @url, rpath(args)
      end


      def uapath(uid, *args)
        File.join @url, urpath(uid, args)
      end

    end


  end
end
