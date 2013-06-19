class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale
  helper_method :clear_flash

  def change_locale
    lang = params[:new_locale]
    lang = ["ar", "en"].include?(lang) ? lang : I18n.default_locale
    cookies.permanent[:lang] = lang
    redirect_to root_path(l:lang)
  end
  
  private
  def clear_flash
    flash.each {|k, v| flash[k] = nil }
  end
  def render_404
    render file: "#{Rails.root}/public/404", status: 404, layout: false, formats: [:html]
  end
  def render_flash(status=200)
    render partial:'shared/flash_messages', status: status; clear_flash
  end
  def render_form_errors(target)
    render partial: 'shared/form_messages', locals: {target:target}
  end
  def set_locale
    I18n.locale = case
      when params[:l] && ["en", "ar"].include?(params[:l]) then params[:l]
      when cookies[:lang] then cookies[:lang]
      else cookies.permanent[:lang] = I18n.locale
    end
  end
  def after_sign_in_path_for(current_user)
    clients_path
  end
  # def default_url_options(options={})
  #   { l: I18n.locale }
  # end
end
