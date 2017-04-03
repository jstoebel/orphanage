require 'spec_helper'
require 'sqlite3'
require 'active_record'

RSpec.describe Orphanage, "orphan" do

  before(:each) do
    ExamTemp.send(:include, Orphanage)
  end

  after(:each) do
    # reset class state
    default_options = {
      home: Exam,
      destroy_on_adopt: false,
      update_timestamps: {
        created: true,
        updated: true
      }
    }

    ExamTemp.send(:adopt_options=, default_options)
  end

  describe "orphan" do

    it "uses defaults if none given" do
      expected_options = {
        home: Exam,
        destroy_on_adopt: false,
        update_timestamps: {
          created: true,
          updated: true
        }
      }
      ExamTemp.send(:orphan)
      expect(ExamTemp.send(:adopt_options)).to eq(expected_options)

    end # uses defaults if none given

    it "stores custom class options" do
      expected_options = {
        home: Bus,
        destroy_on_adopt: true,
        update_timestamps: {
          created: false,
          updated: false
        }
      }

      ExamTemp.send(:orphan, expected_options)
      expect(ExamTemp.send(:adopt_options)).to eq(expected_options)
    end # stores custom class options

  end # describe adopt_options

  describe "adopt" do

    before(:each) do
      ExamTemp.send(:orphan)
      @stu = Student.create! first_name: "Jacob", last_name: "Stoebel"
      @exam_temp = ExamTemp.create!({:score => 150,
        :taken_on => Date.today,
        :first_name => "Jacob",
        :last_name => "Stoebel",
        :created_at => (10.days.ago),
        :updated_at => (10.days.ago)
      })
    end

    context "with default options" do

      before do
        @pre_count = Exam.count
        @fks = {"student_id" => @stu.id}
        @adopted_record = @exam_temp.adopt(@fks)
      end

      it "carries over orphan attrs" do
        ignore_attrs = ["id", "created_at", "updated_at"]
        temp_attrs = @exam_temp
          .attributes
          .except(*ignore_attrs)
          .except("first_name", "last_name")
          .merge(@fks)
        transfered_attrs = @adopted_record.attributes.except(*ignore_attrs)

        expect(transfered_attrs).to eq(temp_attrs)
      end

      it "created record in home table" do
        expect(Exam.count - @pre_count).to eq(1)
      end # creates record in home table

      it "doesn't destroy self after adpotion" do
        expect(@exam_temp.destroyed?).to be false
      end # doesn't self destroy after adpotion

    end  # context

    context "with custom options" do

      before do

        @custom_options = {
          destroy_on_adopt: true,
          update_timestamps: {
            created: false,
            updated: false
          }
        }

        @pre_count = Exam.count
        @fks = {"student_id" => @stu.id}
        @adopted_record = @exam_temp.adopt(@fks, @custom_options)
      end

      it "carries over orphan attrs" do
        ignore_attrs = ["id"]
        temp_attrs = @exam_temp
          .attributes
          .except(*ignore_attrs)
          .except("first_name", "last_name")
          .merge(@fks)
        transfered_attrs = @adopted_record.attributes.except(*ignore_attrs)

        expect(transfered_attrs).to eq(temp_attrs)
      end

      it "creates record in home table" do
        expect(Exam.count - @pre_count).to eq(1)
      end # creates record in home table

      it "destroys self after adpotion" do
        expect(@exam_temp.destroyed?).to be true
      end # destroys self after adpotion

    end  # context

  end # describe adopt

end
