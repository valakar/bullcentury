class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception

  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { locale: I18n.locale }
  end

  def can_create_project?
    if user_signed_in?
      current_user.current_project.nil? || !current_user.current_project.in_action?
    else
      false
    end
  end

  def after_sign_up_path_for(resource)
    puts "after_sign_up_path_for"
    dashboard_path
  end

  def after_sign_in_path_for(resource)
=begin
    #sign_in_url = url_for(action: 'new', controller: 'sessions', only_path: false, protocol: 'http')
    puts stored_location_for(resource)
    puts "after_sign_in_path_for"
    puts resource.inspect
    #if request.referer == sign_in_url || request.referer == new_user_registration_url
    if request.referer == new_user_registration_url
      dashboard_path
    else
      stored_location_for(resource) || request.referer || dashboard_path
    end
=end
    dashboard_path
  end

  def after_sign_out_path_for(resource_or_scope)
    request.referrer
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end

  # Split up a data uri
  def split_base64(uri_str)
    if uri_str.match(%r{^data:(.*?);(.*?),(.*)$})
      uri = Hash.new
      uri[:type] = $1 # "image/gif"
      uri[:encoder] = $2 # "base64"
      uri[:data] = $3 # data string
      uri[:extension] = $1.split('/')[1] # "gif"
      return uri
    else
      return nil
    end
  end

  # Convert data uri to uploaded file. Expects object hash, eg: params[:post]
  def convert_data_uri_to_upload(obj_hash)
    if obj_hash[:remote_image_url].try(:match, %r{^data:(.*?);(.*?),(.*)$})
      image_data = split_base64(obj_hash[:remote_image_url])
      image_data_string = image_data[:data]
      image_data_binary = Base64.decode64(image_data_string)

      temp_img_file = Tempfile.new("data_uri-upload")
      temp_img_file.binmode
      temp_img_file << image_data_binary
      temp_img_file.rewind

      img_params = {:filename => "data-uri-img.#{image_data[:extension]}", :type => image_data[:type], :tempfile => temp_img_file}
      uploaded_file = ActionDispatch::Http::UploadedFile.new(img_params)

      obj_hash[:image] = uploaded_file
      obj_hash.delete(:remote_image_url)
    end

    return obj_hash    
  end

end
