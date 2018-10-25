class ApplicationController < ActionController::Base
  def hello
    render html: "welcome in the sample app."
  end
end
