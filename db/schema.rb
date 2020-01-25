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

ActiveRecord::Schema.define(version: 2020_01_25_225015) do

  create_table "net_promoter_scores", force: :cascade do |t|
    t.integer "score", null: false
    t.string "touchpoint", null: false
    t.string "respondent_class", null: false
    t.integer "respondent_id", null: false
    t.string "object_class", null: false
    t.integer "object_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["object_class", "object_id"], name: "object_index"
    t.index ["respondent_class", "respondent_id", "object_class", "object_id"], name: "duplication_protection_index", unique: true
    t.index ["respondent_class", "respondent_id"], name: "respondent_index"
    t.index ["touchpoint"], name: "index_net_promoter_scores_on_touchpoint"
  end

end
