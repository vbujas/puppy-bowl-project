class SessionsController < Devise::SessionsController
  # clear_respond_to
  respond_to :json
  # respond_to :js

  def create
    resource = warden.authenticate!(scope: resource_name, recall: "#{controller_path}#failure")

    sql = "SELECT begin_date, end_date FROM `settings`"
    @settings  = ActiveRecord::Base.connection.execute(sql);
    beginend = @settings.first

    if beginend
      session['begin_datetime'] = beginend[0].to_s
      session['end_datetime'] =  beginend[1].to_s

      # time.in_time_zone("Pacific Time (US & Canada)")
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

    sign_in(resource_name, resource)

    return render json: { success: true }
    # render js: "window.location = '#{root_path}'"
    # redirect_to :draft_path
    # todo: redirect to admin panel if admin
    # if current_user.admin?
    #  # redirect_to admin_path
    #   if request.xhr?
    #     render js: "window.location = '#{admin_path}'"
    #   else
    #     redirect_to admin_path
    #   end
    # else
    #   # redirect_to to root_path
    #   return render js: "window.location = '#{draft_path}'"
    # end
  end

  def failure
    return render json: { success: false, errors: ['Login or password incorrect, please try again'] }, status: :unprocessable_entity
  end
end
