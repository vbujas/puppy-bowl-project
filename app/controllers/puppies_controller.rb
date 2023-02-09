class PuppiesController < ApplicationController
  before_filter :set_access_control_headers 
  before_action :set_puppy, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :verify_admin
  respond_to :html, :json
  layout 'admin_panel'


def verify_admin
 if current_user.role != 'admin' then
      redirect_to  :controller => "home", :action => "index" 
  end
end

  def puppiesall
      @puppies = Puppy.all
      respond_with(@puppies)
  end

  def index
    @puppies = Puppy.all
    respond_with(@puppies)
  end

  def draft
    @puppies = Puppy.all
    respond_with(@puppies)
  end

  def show
    redirect_to action: "index" 
  end

  def new
     
    @puppy = Puppy.new
    respond_with(@puppy)
      
  end

  def edit

 
  end

  def create
     
    @puppy = Puppy.new(puppy_params)
    @puppy.save
   # respond_with(@puppy)
    redirect_to action: "index" 
    
  end

  def update
 if @puppy.update(puppy_params)

  respond_to do |format|
  format.html  { redirect_to :action => "index" } 
  format.json  { render :status=>200, :json=>{:id=>@puppy.id,
                                              :score_touchdowns=>@puppy.score_touchdowns,
                                              :score_takeaways=>@puppy.score_takeaways,
                                              :score_tackles=>@puppy.score_tackles,
                                              :score_penalties=>@puppy.score_penalties,
                                              :score_field_goals=>@puppy.score_field_goals } }
  end  

 end
  end

  def destroy
     
    @puppy.destroy
    respond_with(@puppy)
       
  end

  def add
  end

  private
    def set_puppy
      @puppy = Puppy.find(params[:id])
    end

    def puppy_params
      params.require(:puppy).permit(:id, :name, :team_name, :breed, :sex, :age, :fun_fact, :score_touchdowns, :score_field_goals, :score_penalties, :score_takeaways, :score_tackles, :pic, :big_pic)
    end

      def set_access_control_headers
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Expose-Headers'] = 'Etag'
      headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, PATCH, OPTIONS, HEAD'
      headers['Access-Control-Allow-Headers'] = '*, x-requested-with, Content-Type, If-Modified-Since, If-None-Match'
      end

end
