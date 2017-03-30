class Room < ActiveRecord::Base
  belongs_to :building
  belongs_to :college

  validates_presence_of :college_id
  validates_presence_of :building_id

end
