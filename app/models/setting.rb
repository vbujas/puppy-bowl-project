class Setting < ActiveRecord::Base
  validates :begin_date, :end_date, presence: true
end
