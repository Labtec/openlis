# frozen_string_literal: true

module WebauthnConcern
  extend ActiveSupport::Concern

  included do
    prepend_before_action :authenticate_with_webauthn, if: :webauthn_enabled?, only: [:create]
  end

  def webauthn_enabled?
    find_user&.webauthn_enabled?
  end

  def valid_webauthn_credential?(user, webauthn_credential)
    user_credential = user.webauthn_credentials.find_by!(external_id: webauthn_credential.id)

    begin
      webauthn_credential.verify(
        session[:webauthn_challenge],
        public_key: user_credential.public_key,
        sign_count: user_credential.sign_count
      )

      user_credential.update!(sign_count: webauthn_credential.sign_count)
    rescue WebAuthn::Error
      false
    end
  end

  def authenticate_with_webauthn
    user = self.resource = find_user

    if user.present? && session[:attempt_user_id].present? && session[:attempt_user_updated_at] != user.updated_at.to_s
      restart_session
    elsif user.webauthn_enabled? && user_params.key?(:credential) && session[:attempt_user_id]
      authenticate_via_webauthn(user)
    elsif user.present? && user.valid_password?(user_params[:password])
      prompt_for_webauthn(user)
    end
  end

  def authenticate_via_webauthn(user)
    webauthn_credential = WebAuthn::Credential.from_get(user_params[:credential])

    if valid_webauthn_credential?(user, webauthn_credential)
      clear_attempt_from_session
      sign_in(user)
      set_user_language
      flash[:notice] = t('flash.login.hello') +
                       "#{current_user.first_name}!" +
                       t('flash.login.last_login_at') +
                       view_context.time_ago_in_words(current_user.last_sign_in_at)
      render json: { redirect_path: after_sign_in_path_for(user) }, status: :ok
    else
      render json: { error: t('webauthn_credentials.invalid_credential') }, status: :unprocessable_entity
    end
  end

  def prompt_for_webauthn(user)
    set_attempt_session(user)
    set_user_language
    render :webauthn, status: :see_other
  end
end
