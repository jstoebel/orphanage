require 'spec_helper'
require 'sqlite3'
require 'active_record'

RSpec.describe Orphanage, "orphan_of" do

  before(:each) do
    ExamTemp.send(:include, Orphanage)
  end

  after(:each) do
    # reset class state
    default_options = {
      destroy_on_adopt: true,
      update_timestamps: {
        created: true,
        updated: true
      }
    }

    ExamTemp.send(:adopt_options=, default_options)
  end

  describe "home_model" do
    it "stores valid home_model" do
      ExamTemp.send(:orphan_of, :exam)
      expect(ExamTemp.send(:home_model)).to equal(Exam)
    end # stores valid home_model

    it "fails on invalid home_model" do
      expect {ExamTemp.send(:orphan_of, :bogus_model)}.to raise_error(NameError)
    end # fails on invalid home_model

    it "properly handles model name ending with 's'" do
      ExamTemp.send(:orphan_of, :bus)
      expect(ExamTemp.send(:home_model)).to equal(Bus)
    end  # properly handles model name ending with 's'
  end

  describe "adopt_options" do

    it "uses defaults if none given" do
      expected_options = {
        destroy_on_adopt: true,
        update_timestamps: {
          created: true,
          updated: true
        }
      }
      ExamTemp.send(:orphan_of, :exam)
      expect(ExamTemp.send(:adopt_options)).to eq(expected_options)

    end # uses defaults if none given

    it "stores custom class options" do
      expected_options = {
        destroy_on_adopt: false,
        update_timestamps: {
          created: false,
          updated: false
        }
      }

      ExamTemp.send(:orphan_of, :exam, expected_options)
      expect(ExamTemp.send(:adopt_options)).to eq(expected_options)
    end # stores custom class options

  end # describe adopt_options

  describe "adopt" do

    before(:each) do
      @stu = Student.create! first_name: "Jacob", last_name: "Stoebel"
      @exam_temp = ExamTemp.create! score: 150, taken_on: Date.today
    end

    it "adopts the record" do
      expect{@exam_temp.adopt({:student_id => @stu.id})}.to change{Exam.count}.by(1)

    end # adopts the record

    it "destroys self after adpotion" do
      @exam_temp.adopt({:student_id => @stu.id})
      expect {@exam_temp}.to raise_error ActiveRecord::RecordNotFound
    end # self destroys after adpotion

  end # describe adopt

end
