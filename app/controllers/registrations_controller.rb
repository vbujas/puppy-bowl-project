class RegistrationsController < Devise::RegistrationsController
  # clear_respond_to
  # respond_to :js, :html

  # skip_before_action :verify_authenticity_token

  # POST /resource
  def create
    build_resource(sign_up_params)

    resource_saved = resource.save
    yield resource if block_given?
    respond_to do |format|
      if resource_saved
        if resource.active_for_authentication?
          set_flash_message :notice, :signed_up if is_flashing_format?
          sign_up(resource_name, resource)
          # respond_with resource, location: after_sign_up_path_for(resource)
          # return render json: { success: true }
          # if request.xhr?
          #   render js: "window.location = '#{draft_path}'"
          # else
          #   redirect_to draft_path
          # end
          # format.html { redirect_to root_path, notice: 'User was successfully created.' }
          format.json { render json: { success: true } }
          # format.js   { render json: { success: true } }
        else
          set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
          expire_data_after_sign_in!
          # respond_with resource, location: after_inactive_sign_up_path_for(resource)
          # return render json: { success: true }
          # format.html { redirect_to root_path, notice: 'User was successfully created.' }
          format.json { render json: { success: true } }
          # format.js   { render json: { success: true } }
        end
      else
        clean_up_passwords resource
        @validatable = devise_mapping.validatable?
        if @validatable
          @minimum_password_length = resource_class.password_length.min
        end
        logger.error('Can not create user')
        logger.error(resource.errors.full_messages.join("\n"))
        # respond_with resource
        # return render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
        # render :json => resource.errors, :status => :unprocessable_entity
        # return render json: { success: false, errors: resource.errors.full_messages }

        # respond_to do |format|
        #   format.html { render action: 'new' }
        #   format.json { render json: resource.errors.full_messages, status: :unprocessable_entity }
        #   format.js   { render json: resource.errors.full_messages, status: :unprocessable_entity }
        # end
        # format.html { render action: 'new' }
        format.json { render json: resource.errors, status: :unprocessable_entity }
        format.js   { render json: resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # def respond_with(resource, opts = {})
  #   render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
  # end

  private

    def sign_up_params
      params.require(:user).permit(:id, :first_name, :last_name, :email, :image_url, :video_provider, :password, :password_confirmation)
    end
end
