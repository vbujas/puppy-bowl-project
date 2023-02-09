class SettingsController < ApplicationController
  layout 'admin_panel'
  
  before_action :authenticate_user!
  before_action :set_setting, only: [:edit, :update]
  respond_to :html

 
 def setstatus
  puts "setstatus "
    if current_user != nil

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
       
      if time >= timebegin
        #duriing or after the game - nothing
        if time <= timeend
         #during the game - go to rankings
           puts 'during the game'
           session['status'] = 'during'
         
         return
        else
         #after the game - go to  finalstats
         puts 'after the game'
         session['status'] ='after'
          
         return
        end
      else
        # before the game - nothing happens
        session['status'] = 'before or undefined dates'
        puts 'before the game'
        # return
      end
      end
    end
 end



  def index
    setstatus
    if Setting.first
      @setting = Setting.first
    else
      @setting = Setting.new
    end
  end

  def edit
  end

  def create
    @setting = Setting.new(setting_params)

    if @setting.save
      redirect_to settings_path, notice: 'Settings was successfully created.'
    else
     render :index
    end
  end


  def update
    if @setting.update(setting_params)
      redirect_to settings_path, notice: 'Settings was successfully updated.'
    else
      render :edit
    end
  end

  private
  def set_setting
    @setting = Setting.first
  end

  def setting_params
    params.require(:setting).permit(:begin_date, :end_date)
  end
end
