require 'active_record'
class Student < ActiveRecord::Base
  has_many :exams
end
