require 'active_record'
class Exam < ActiveRecord::Base
  belongs_to :student
end
