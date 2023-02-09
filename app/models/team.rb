class Team < ActiveRecord::Base
	has_many :puppy_teams
	has_many :puppies, :through => :puppy_teams
end
