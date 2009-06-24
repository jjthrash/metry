module Rack
  module Metrics
    class Tracking
      def initialize(app, storage)
        @app = app
        @storage = storage
      end
      
      def call(env)
        if ::File.exist?(@storage)
          hash = Marshal.load(::File.read(@storage))
        else
          hash = {}
        end
        hash[hash.size] = {
          "path" => env["PATH_INFO"],
          "time" => Time.now.to_i}
        ::File.open(@storage, 'w'){|f| f.write Marshal.dump(hash)}
        @app.call(env)
      end
    end
  end
end