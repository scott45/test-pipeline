# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170922163655) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assessments", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.text     "context"
    t.integer  "framework_criterium_id"
    t.text     "description"
    t.index ["framework_criterium_id"], name: "index_assessments_on_framework_criterium_id", using: :btree
  end

  create_table "assessments_phases", force: :cascade do |t|
    t.integer "assessment_id"
    t.integer "phase_id"
    t.index ["assessment_id", "phase_id"], name: "index_assessments_phases_on_assessment_id_and_phase_id", unique: true, using: :btree
    t.index ["assessment_id"], name: "index_assessments_phases_on_assessment_id", using: :btree
    t.index ["phase_id"], name: "index_assessments_phases_on_phase_id", using: :btree
  end

  create_table "bootcamper_decision_reasons", force: :cascade do |t|
    t.string  "camper_id"
    t.integer "decision_stage"
    t.integer "decision_reason_id"
  end

  create_table "bootcampers", primary_key: "camper_id", id: :string, force: :cascade do |t|
    t.string   "week_one_lfa"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "week_two_lfa"
    t.string   "decision_one"
    t.string   "cycle"
    t.string   "city"
    t.string   "country"
    t.string   "decision_two"
    t.integer  "progress_week1"
    t.integer  "progress_week2"
    t.string   "gender"
    t.decimal  "overall_average",      default: "0.0"
    t.decimal  "week1_average",        default: "0.0"
    t.decimal  "week2_average",        default: "0.0"
    t.decimal  "project_average",      default: "0.0"
    t.decimal  "value_average",        default: "0.0"
    t.decimal  "output_average",       default: "0.0"
    t.decimal  "feedback_average",     default: "0.0"
    t.text     "decision_one_comment"
    t.text     "decision_two_comment"
    t.integer  "program_id"
    t.index ["camper_id"], name: "index_bootcampers_on_camper_id", unique: true, using: :btree
    t.index ["program_id"], name: "index_bootcampers_on_program_id", using: :btree
    t.index ["week_one_lfa"], name: "index_bootcampers_on_week_one_lfa", using: :btree
  end

  create_table "criteria", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "decision_reason_statuses", id: false, force: :cascade do |t|
    t.integer "decision_reason_id"
    t.integer "decision_status_id"
    t.index ["decision_reason_id"], name: "index_decision_reason_statuses_on_decision_reason_id", using: :btree
    t.index ["decision_status_id"], name: "index_decision_reason_statuses_on_decision_status_id", using: :btree
  end

  create_table "decision_reasons", force: :cascade do |t|
    t.string "reason"
  end

  create_table "decision_statuses", force: :cascade do |t|
    t.string "status"
  end

  create_table "facilitators", force: :cascade do |t|
    t.string   "first_name", null: false
    t.string   "last_name",  null: false
    t.string   "email",      null: false
    t.string   "city"
    t.string   "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "framework_criteria", force: :cascade do |t|
    t.integer  "criterium_id"
    t.integer  "framework_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["criterium_id"], name: "index_framework_criteria_on_criterium_id", using: :btree
    t.index ["framework_id"], name: "index_framework_criteria_on_framework_id", using: :btree
  end

  create_table "frameworks", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "metrics", force: :cascade do |t|
    t.text    "description"
    t.integer "point_id"
    t.integer "assessment_id"
    t.index ["assessment_id"], name: "index_metrics_on_assessment_id", using: :btree
    t.index ["point_id", "assessment_id"], name: "index_metrics_on_point_id_and_assessment_id", unique: true, using: :btree
    t.index ["point_id"], name: "index_metrics_on_point_id", using: :btree
  end

  create_table "phases", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "program_id"
    t.index ["name"], name: "index_phases_on_name", using: :btree
    t.index ["program_id"], name: "index_phases_on_program_id", using: :btree
  end

  create_table "points", force: :cascade do |t|
    t.integer "value"
    t.string  "context"
  end

  create_table "programs", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "scores", force: :cascade do |t|
    t.float    "score"
    t.string   "week"
    t.text     "comments"
    t.string   "camper_id"
    t.integer  "assessment_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "phase_id"
    t.index ["assessment_id"], name: "index_scores_on_assessment_id", using: :btree
    t.index ["phase_id"], name: "index_scores_on_phase_id", using: :btree
  end

  add_foreign_key "assessments", "framework_criteria"
  add_foreign_key "bootcamper_decision_reasons", "bootcampers", column: "camper_id", primary_key: "camper_id"
  add_foreign_key "bootcamper_decision_reasons", "decision_reasons"
  add_foreign_key "bootcampers", "programs"
  add_foreign_key "framework_criteria", "criteria"
  add_foreign_key "framework_criteria", "frameworks"
  add_foreign_key "metrics", "assessments"
  add_foreign_key "metrics", "points"
  add_foreign_key "phases", "programs"
  add_foreign_key "scores", "assessments"
  add_foreign_key "scores", "bootcampers", column: "camper_id", primary_key: "camper_id"
end
