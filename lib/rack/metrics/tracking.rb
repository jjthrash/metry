module Rack
  module Metrics
    class Tracking
      EXTRA = "metrics.extra"

      def initialize(app, storage)
        @app = app
        @storage = storage
      end
      
      def call(env)
        track(env) do
          @app.call(env)
        end
      end
      
      def track(env)
        request = Request.new(env)
        visitor = find_visitor(env)
        env[EXTRA] = {}
        status, headers, body = yield
        response = Response.new(body, status, headers)
        entry = {
          "metrics.path" => request.fullpath,
          "metrics.time" => Time.now.to_f,
          "metrics.visitor" => visitor,
          "metrics.ip" => request.ip,
          "metrics.host" => request.host,
          "metrics.status" => status.to_s,
          "metrics.method" => request.request_method}
        entry.update(env[EXTRA])
        @storage.add_entry(entry)
        save_visitor(response, visitor)
        response.to_a
      end
      
      def find_visitor(env)
        (Request.new(env).cookies["_rack_tracking"] || @storage.next_visitor.to_s)
      end
      
      def save_visitor(response, visitor)
        response.set_cookie("_rack_tracking", visitor)
      end
    end
  end
end