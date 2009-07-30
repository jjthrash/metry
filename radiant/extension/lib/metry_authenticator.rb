class MetryAuthenticator
  include ActionController::UrlWriter

  def initialize(env)
    extend LoginSystem
    @env = env
    @request = Rack::Request.new(env)
    def @request.format
      nil
    end
  end
  
  attr_reader :request
  
  def cookies
    request.cookies
  end
  
  def session
    @env["rack.session"]
  end
      
  def authorized?
    (current_user && current_user.admin?)
  end
  
  def redirect
    [302, {"Location" => login_path}, ""]
  end
end
