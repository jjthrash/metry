module Metry
  module Rack
    class Tracking
      COOKIE = "_metry"

      def initialize(app)
        @app = app
        @storage = Metry.current
      end
    
      def call(env)
        request = ::Rack::Request.new(env)
        visitor = find_visitor(request)
        env["metry.event"] = event = build_event(visitor, request)

        status, headers, body = @app.call(env)

        event["status"] = status.to_s
        @storage << event

        response = ::Rack::Response.new(body, status, headers)
        save_visitor(response, visitor)

        response.to_a
      end
    
      def build_event(visitor, request)
        { "event" => "pageview",
          "path" => request.fullpath,
          "time" => Time.now.to_f,
          "visitor" => visitor,
          "ip" => request.ip,
          "host" => request.host,
          "method" => request.request_method }
      end
    
      def find_visitor(request)
        (request.cookies[COOKIE] || @storage.next_visitor.to_s)
      end
    
      def save_visitor(response, visitor)
        response.set_cookie(COOKIE, visitor)
      end
    end
  end
end