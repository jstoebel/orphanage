require 'active_record'
require './orphanage'

class ExamTemp < ActiveRecord::Base
  include Orphanage

end
