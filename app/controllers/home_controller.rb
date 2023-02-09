class HomeController < ApplicationController
  respond_to :html, :json
  before_filter :set_access_control_headers 
  before_filter :redirect, except: [:rankings, :finalstats] 
  before_action :authenticate_user!, except: [:index, :rankingslanding]
  layout :choose_layout
 
 def choose_layout
     case action_name
    when "rankingslanding" 
      "application_rankingslanding"  
    else
      "application"
 end
end

    
  
 def redirect
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
           redirect_to action: 'rankings' 
         return
        else
         #after the game - go to  finalstats
         puts 'after the game'
         session['status'] = 'after'
         redirect_to action: 'finalstats' 
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
    @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}", success_action_status: 201, acl: :public_read) 
    response.headers['P3P'] = 'CP="NON DSP COR CURa IVAa IVDa CONa OUR NOR STA"'
     if current_user != nil 
      team = usersteam
   if team  != nil
      @puppies = Puppy.all

      render :template => "home/edit", :locals => { :pup1 => team[1] || -1 , :pup2 => team[2] || -1 , :pup3 => team[3] || -1, :puppies=>@puppies, :votestats=>votestats } 
   else
      redirect_to action: 'draft'
   end
   else 
    @puppies = Puppy.all
    respond_with(@puppies) 
   end 
  end
  

  def noteams
     sql = "SELECT count(*) as cnt FROM `teams`" 
   @res = ActiveRecord::Base.connection.execute(sql);
   team = @res.first  
   return team[0]
  end

  def votestats
       sqlruff  = "SELECT count(*) AS ruff FROM `users` WHERE vote ='R' " 
   sqlfluff = "SELECT count(*) AS fluff FROM `users` WHERE vote ='F' " 

   @resruff  = ActiveRecord::Base.connection.execute(sqlruff);
   @resfluff = ActiveRecord::Base.connection.execute(sqlfluff);
   
   ruff = @resruff.first
   fluff = @resfluff.first

   sum = ruff[0].to_i + fluff[0].to_i
   pctfluff = fluff[0].to_f *  100 / sum 
   pctruff =  ruff[0].to_f *  100 / sum 
   
   votestats = Array.new
   votestats[0] = pctfluff
   votestats[1]  = pctruff
   return votestats
  end


  def usersteam
    sql = "SELECT id, pup1,pup2,pup3 FROM `teams` WHERE user_id = " + current_user.id.to_s
   @res = ActiveRecord::Base.connection.execute(sql);
   team = @res.first 
   if team != nil
   team[1] = team[1] || -1
   team[2] = team[2] || -1
   team[3] = team[3] || -1
   end
   return team
  end

  def ranking 
           ranking = 0
            touchdown = 7
            fieldg = 3
            tackle = 2
            takeaway = 3
            penalty = -2
    
   @allpuppies = Puppy.all
   @allteams = Team.all
   team = usersteam
   rs = Array.new
   results = Array.new
   teamscores = Array.new        
   if usersteam != nil
   @allpuppies.each_with_index do |puppy, index| 
   res = ( touchdown * puppy.score_touchdowns) + (fieldg *  puppy.score_field_goals) + (tackle * puppy.score_tackles) + (takeaway * puppy.score_takeaways) + (penalty * puppy.score_penalties) 
   # puts "puppy" + puppy.id.to_s + " has " + res.to_s
   results[puppy.id] = res  
   end 
   sql = "SELECT * FROM `puppies` WHERE id in (" + team[1].to_s + "," + team[2].to_s + ", " + team[3].to_s + ")" 
   @puppies = ActiveRecord::Base.connection.execute(sql); 
   score = 0
      @puppies.each_with_index do |puppy, index|
    score += ( touchdown * puppy[6]) + (fieldg *  puppy[15]) + (tackle * puppy[9]) + (takeaway * puppy[8]) + (penalty * puppy[7]) 
   # puts " team score: "+score.to_s 
    end 

   @allteams.each do |team| 
   # puts team.id
     if team
     p1i = team.pup1 || -1
     p2i = team.pup2 || -1
     p3i = team.pup3 || -1

      p1 = results[p1i] || 0
      p2 = results[p2i] || 0
      p3 = results[p3i] || 0
      teamscore = p1 + p2  + p3
   #   puts "team x has: "+teamscore.to_s
      teamscores.push( teamscore);
     end
   end
  teamscores.sort! {|x, y| x <=> y}
 # puts teamscores
  noteams = teamscores.count
  ranking =0
  teamscores.each_with_index do |tscore, index| 
    if score < tscore then   
     # puts 'index >>>' + index.to_s + '  score' + score.to_s + ' tscore ' + tscore.to_s
     ranking = noteams - index
     break
    end
  end

   if score == 0
      ranking = teamscores.count
    end

  rs[0] = ranking
  rs[1] = score
  else
  rs[0] = 0
  rs[1] = 0
  end
  return rs
  end



  def finalstats
   if current_user != nil
   votes = votestats
   rank = ranking
   get_friends_image_who_drafted
   render :template => "home/finalstats", :locals => {:ranking => rank[0], :votes => votes, :noteams => noteams, :score=>rank[1], :puppies=>@puppies } 
   else
      redirect_to action: 'index'
   end 
   end


  def draft  
  if current_user != nil
       team = usersteam
    if team  != nil
      session['tid'] = team[0]
      @puppies = Puppy.all
      render :template => "home/draft", :locals => { :pup1 => team[1] || -1, :pup2 => team[2] || -1 , :pup3 => team[3] || -1 , :puppies=>@puppies } 
   else
      # session['tid'] = team[0]
      @puppies = Puppy.all
      render :template => "home/draft", :locals => { :pup1=>'***', :pup2=>'***', :pup3=>'***', :puppies=>@puppies }       
   #   redirect_to action: 'draft'
   end
   else
      redirect_to action: 'index'
   end 
  end


  def dovote  
   if  @user = User.find(current_user.id)   
   # User.where('user_id = ?', current_user.id.to_s).update_all(user_params)    
     sql = "UPDATE users SET vote='" + user_params['vote'] + "' WHERE id=" + current_user.id.to_s
      @res  = ActiveRecord::Base.connection.execute(sql);
   # @user.update() 
     render :status=>200, :json=>{:id=>@user.id, :message=>'success'}       
   else
     render :status=>200, :json=>{ :message=>'error'}       
     
   end      
  
  end

   def editteam  
     
      team = usersteam
   if team  != nil
      session['tid'] = team[0]
      
      Team.where('user_id = ?', current_user.id.to_s).update_all(team_update_params)      
            render :status=>200, :json=>{:id=>team[0]}
            return  
          
      else 
          @team = Team.new(team_update_params)
          if  @team.save
          render :status=>200, :json=>{:id=>@team.id}       
           session['tid'] = @team.id
             return
          end 

      end     
  end

  def vote  
  end
   def selfclose  
  end

  def voted  
   sqlruff  = "SELECT count(*) AS ruff FROM `users` WHERE vote ='R' " 
   sqlfluff = "SELECT count(*) AS fluff FROM `users` WHERE vote ='F' " 

   @resruff  = ActiveRecord::Base.connection.execute(sqlruff);
   @resfluff = ActiveRecord::Base.connection.execute(sqlfluff);
   
   ruff = @resruff.first
   fluff = @resfluff.first

   sum = ruff[0].to_i + fluff[0].to_i
   pctfluff = fluff[0].to_f *  100 / sum 
   pctruff =  ruff[0].to_f *  100 / sum 
   puts pctfluff
   puts pctruff
   render :template => "home/voted", :locals => { :pctfluff => pctfluff, :pctruff => pctruff, :tid=>session['tid'] } 

  end
  

   def edit  
   if current_user != nil
      team = usersteam 
      vote = votestats
   if team  != nil
      session['tid'] = team[0]
      @puppies = Puppy.all
      render :template => "home/edit", :locals => { :pup1 => team[1] || -1, :pup2 => team[2] || -1, :pup3 => team[3] || -1, :puppies=>@puppies, :votestats=>vote} 
   else
      @puppies = Puppy.all
      render :template => "home/edit", :locals => { :pup1=>'***', :pup2=>'***', :pup3=>'***', :puppies=>@puppies, :votestats=>vote } 
      
   #   redirect_to action: 'draft'
   end

   else 
     redirect_to action: 'index'
   end 

   end

 #  def edited    
 #  sql = "SELECT pup1,pup2,pup3 FROM `teams` WHERE id = " + session['tid'].to_s
 #  @res = ActiveRecord::Base.connection.execute(sql);
 #  team = @res.first          
 #  sql = "SELECT * FROM `puppies` WHERE id in (" + team[0].to_s + "," + team[1].to_s  + "," + team[2].to_s   + ")" 
 #  @puppies = ActiveRecord::Base.connection.execute(sql); 
 #  respond_with(@puppies)         
 # end

   def created    

   team = usersteam        	
   if team
    get_friends_image_who_drafted
    sql = "SELECT * FROM `puppies` WHERE id in (" + team[1].to_s  + "," + team[2].to_s  + "," + team[3].to_s  + ")" 
    @puppies =  ActiveRecord::Base.connection.execute(sql);   
     fpup = @puppies.first

    if  current_user.vote == nil
     redirect_to action: 'vote'
    else
    render :template => "home/created", :locals => { :pup1=>fpup, :pup2=>'***', :pup3=>'***', :puppies=>@puppies } 
    end
   
   else
    flash[:error] = "Team not found"
    redirect_to root_path
   end
  end

   def createteam  
   team = usersteam
   if team  != nil
          Team.where('user_id = ?', current_user.id.to_s).update_all(team_update_params)      
            render :status=>200, :json=>{:id=>team[0], :action=>'update'}
   else
    @team = Team.new(team_params)
  if  @team.save
     render :status=>200, :json=>{:id=>@team.id, :name=>@team.TEAM_NAME,  :action=>'create'}       
     session['tid'] = @team.id
        return
  end 
   end
  end


  def team_params
      params.require(:team).permit(:TEAM_NAME, :pup1, :pup2, :pup3, :TEAM_DESCRIPTION, :user_id)
     
  end

   def team_update_params
      params.require(:team).permit(:pup1, :pup2, :pup3, :user_id)
     
  end

 def user_params
      params.require(:user).permit(:vote)
 end
     
 
   def set_access_control_headers
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Credentials'] = 'true'
      headers['Access-Control-Expose-Headers'] = 'Etag'
      headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, PATCH, OPTIONS, HEAD'
      headers['Access-Control-Allow-Headers'] = '*, x-requested-with, Content-Type, If-Modified-Since, If-None-Match'
end

  def get_friends_image_who_drafted
    friends_ids = current_user.get_friends_ids
    @friends_images = []
    unless friends_ids.nil?
      friends_ids.each do |friend_id|
        friend = User.find_by_uid(friend_id)
        if friend && friend.team
          @friends_images << friend.image_url
        end
      end
    end
  end

  def rankings
    votes = votestats
    rank = ranking
    @puppies = Puppy.all
    render :template => "home/rankings", :locals => { :votes => votes,:ranking =>rank[0], :score=>rank[1], :noteams => noteams, :puppies=>@puppies } 
 
  end

    def rankingslanding
       if current_user == nil
    votes = votestats
    @puppies = Puppy.all
    render :template => "home/rankingslanding", :locals => { :votes => votes, :noteams => noteams, :puppies=>@puppies } 
     else
      redirect_to action: 'draft' 
     end
  end
end
