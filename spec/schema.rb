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

  create_table :buildings, force: true do |t|
    t.string :name
    t.timestamps
  end

  create_table :colleges, force: true do |t|
    t.string :name
    t.integer :floors
    t.timestamps
  end

  create_table :rooms, force: true do |t|
    t.integer :number
    t.integer :building_id
    t.integer :department_id
    t.timestamps
  end

  create_table :room_temps, force: true do |t|
    t.integer :number
    t.string :department_name
    t.string :building_name
    t.timestamps
  end

  create_table :buses, force: true do |t|
    t.string :route
  end

end
