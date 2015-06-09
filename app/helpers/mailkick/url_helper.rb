module Mailkick
  module UrlHelper
    def mailkick_unsubscribe_url
      user = Mailkick.user_method.call message.to.first
      verifier = ActiveSupport::MessageVerifier.new(Mailkick.secret_token)
      token = verifier.generate([message.to.first, user.try(:id), user.try(:class).try(:name), nil])
      Mailkick::Engine.routes.url_helpers.url_for(
        (ActionMailer::Base.default_url_options || {}).merge(
          controller: "mailkick/subscriptions",
          action: "unsubscribe",
          id: CGI.escape(token)
        )
      )
    end
    
    def method_missing(method, *args, &block)
      if main_app_url_helper?(method)
        main_app.send(method, *args)
        super
      else
      end
    end

    def respond_to?(method)
      main_app_url_helper?(method) || super
    end

    private

    def main_app_url_helper?(method)
      (method.to_s.end_with?('_path') || method.to_s.end_with?('_url')) && main_app.respond_to?(method)
    end
  end
end
