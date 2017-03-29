require 'sqlite3'
require 'active_record'
require 'pry'

require './student'
require './exam'
require './exam_temp'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

ActiveRecord::Schema.define do
  create_table :students, force: true do |t|
    t.string :first_name
    t.string :last_name
    t.timestamps
  end

  create_table :exams, force: true do |t|
    t.integer :student_id
    t.integer :score
    t.datetime :taken_on
    t.timestamps
  end

  create_table :exam_temps, force: true do |t|
    t.integer :score
    t.datetime :taken_on
    t.string :first_name
    t.string :last_name
    t.timestamps
  end

end

stu = Student.create! first_name: "Jacob", last_name: "Stoebel"
exam = Exam.create! student_id: stu.id, score: 150, taken_on: Date.today

binding.pry
puts Student.new.inspect
