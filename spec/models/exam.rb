require 'active_record'
class Exam < ActiveRecord::Base
  belongs_to :student

  validates_presence_of :student_id
end
