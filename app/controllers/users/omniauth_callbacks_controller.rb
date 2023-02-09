class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  skip_before_filter :authenticate_user!

  def all
    p env["omniauth.auth"]
    user = User.from_omniauth(request.env["omniauth.auth"])

    if user.persisted?
      set_flash_message(:notice, :success, :kind => user.provider) if is_navigational_format?

      sql = "SELECT begin_date, end_date FROM `settings`"
      @settings  = ActiveRecord::Base.connection.execute(sql);
      beginend = @settings.first

      if beginend
        session['begin_datetime'] = beginend[0].to_s
        session['end_datetime'] =  beginend[1].to_s

        time =  Time.now
        time = time.in_time_zone("Eastern Time (US & Canada)")
        timebegin = Time.parse(session['begin_datetime']) + 5.hours
        timebegin = timebegin.in_time_zone("Eastern Time (US & Canada)")
        timeend = Time.parse(session['end_datetime']) + 5.hours
        timeend =  timeend.in_time_zone("Eastern Time (US & Canada)")
        puts time
        puts timebegin
        puts timeend
        if time > timebegin
          #duriing or after the game - nothing
          if time < timeend
           #during the game - go to rankings
           puts 'during the game'
           session['status'] =  'during'

          else
           #after the game - go to  finalstats
           puts 'after the game'
           session['status'] = 'after'
          end
        else
          # before the game - nothing happens
          puts 'before the game'
          # return
        end
      end

      sign_in user, :event => :authentication #this will throw if user is not activated
      render 'shared/close_popup'
    else
      # session["devise.user_attributes"] = user.attributes
      # redirect_to new_user_registration_url
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      flash[:error] = "There was a problem with logging in. Please try again."
      render :text => "There was a problem with logging in. Please try again."
    end
  end

  # def failure
  #   super
  # end

  alias_method :facebook, :all
  alias_method :twitter, :all

  # private

  # def after_sign_up_path_for(resource)
  #   if current_user.admin?
  #     admin_path
  #   else
  #     root_path
  #   end
  # end

  def after_sign_in_path_for(resource)
    draft_path
  end
end
