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
        env["metry.visitor"] = visitor
        env["metry.event"] = event = build_event(visitor, request, env)

        status, headers, body = @app.call(env)

        event["status"] = status.to_s
        @storage << event

        response = ::Rack::Response.new(body, status, headers)
        save_visitor(response, visitor)

        response.to_a
      end
    
      def build_event(visitor, request, env)
        { "event" => "pageview",
          "path" => request.fullpath,
          "time" => Time.now.to_f,
          "visitor" => visitor['_id'],
          "ip" => request.ip,
          "host" => request.host,
          "method" => request.request_method,
          "referrer" => env["HTTP_REFERER"],
          "user_agent" => env["HTTP_USER_AGENT"] }
      end
    
      def find_visitor(request)
        @storage.visitor(request.cookies[COOKIE]) || @storage.new_visitor
      end
    
      def save_visitor(response, visitor)
        @storage.save_visitor(visitor)
        response.set_cookie(COOKIE,
          :value => visitor['_id'],
          :expires => (Time.now+(60*60*24*365*20)),
          :path => '/')
      end
    end
  end
end