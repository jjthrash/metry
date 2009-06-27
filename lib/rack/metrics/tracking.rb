module Rack
  module Metrics
    class Tracking
      EXTRA = "METRICS_EXTRA"
      PAGEVIEW = "PAGEVIEW"
      COOKIE = "_rack_metrics"

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
        @storage << build_event(env, visitor, request, status)
        save_visitor(response, visitor)
        response.to_a
      end
      
      def build_event(env, visitor, request, status)
        event = {
          "metrics.event" => PAGEVIEW,
          "metrics.path" => request.fullpath,
          "metrics.time" => Time.now.to_f,
          "metrics.visitor" => visitor,
          "metrics.ip" => request.ip,
          "metrics.host" => request.host,
          "metrics.status" => status.to_s,
          "metrics.method" => request.request_method}
        event.update(env[EXTRA])
        event
      end
      
      def find_visitor(env)
        (Request.new(env).cookies[COOKIE] || @storage.next_visitor.to_s)
      end
      
      def save_visitor(response, visitor)
        response.set_cookie(COOKIE, visitor)
      end
    end
  end
end