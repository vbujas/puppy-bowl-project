# == Schema Information
#
# Table name: puppies
#
#  id               :integer          not null, primary key
#  PUPPY_NAME       :string(255)
#  PUPPY_BREED      :string(255)
#  PUPPY_SEX        :string(255)
#  PUPPY_AGE        :integer
#  PUPPY_FUN_FACT   :string(255)
#  SCORE_TOUCHDOWNS :integer          default(0), not null
#  SCORE_PENALTIES  :integer          default(0), not null
#  SCORE_TAKEAWAYS  :integer          default(0), not null
#  SCORE_TACKLES    :integer          default(0), not null
#  PUPPY_PIC        :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class Puppy < ActiveRecord::Base

    has_many :puppy_teams
	has_many :teams, :through => :puppy_teams

  def totals
    (score_touchdowns * 7) + (score_takeaways * 3) + (score_tackles * 2) + (score_field_goals * 3) + (score_penalties * -2)
  end
end
