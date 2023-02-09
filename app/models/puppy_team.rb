class PuppyTeam < ActiveRecord::Base
	belongs_to :puppy
	belongs_to :team
end
