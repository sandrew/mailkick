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
  end
end
