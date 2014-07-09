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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140709140044) do

  create_table "avoirs", :force => true do |t|
    t.float    "price",       :default => 0.0
    t.integer  "facture_id",                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "numavoir",    :default => "",  :null => false
    t.text     "designation", :default => ""
  end

  add_index "avoirs", ["facture_id"], :name => "facture_id"

  create_table "bonlivraisons", :force => true do |t|
    t.string   "numlivraison",                     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "devi_id",          :default => 0,  :null => false
    t.string   "adresselivraison", :default => ""
  end

  add_index "bonlivraisons", ["devi_id"], :name => "bonlivraison_devi_id"

  create_table "bonlivraisons_factures", :id => false, :force => true do |t|
    t.integer "facture_id",      :null => false
    t.integer "bonlivraison_id", :null => false
  end

  add_index "bonlivraisons_factures", ["bonlivraison_id"], :name => "index_bonlivraisons_factures_on_bonlivraison_id"
  add_index "bonlivraisons_factures", ["facture_id"], :name => "index_bonlivraisons_factures_on_facture_id"

  create_table "clients", :force => true do |t|
    t.integer  "numclient",                                        :null => false
    t.string   "nameentreprise",                                   :null => false
    t.text     "adresse",        :limit => 255,                    :null => false
    t.string   "namerefcontact"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tva_intra"
    t.boolean  "affacturage",                   :default => false
  end

  create_table "devis", :force => true do |t|
    t.string   "description"
    t.string   "numdevis"
    t.integer  "client_id",                                                            :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "tva",          :default => true
    t.string   "cond_payment", :default => "40% à la commande, 60% à la livraison."
    t.integer  "etat",         :default => 1
  end

  add_index "devis", ["client_id"], :name => "client_id"

  create_table "factures", :force => true do |t|
    t.string   "numfacture",                                                        :null => false
    t.string   "numcommande"
    t.integer  "devi_id",                                                           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "choixrib",          :default => "rib"
    t.integer  "accompte",          :default => 100
    t.boolean  "proforma",          :default => false
    t.string   "cond_reglement",    :default => "net à réception de la facture."
    t.boolean  "datepaiementcheck", :default => false
    t.datetime "datepaiement"
    t.boolean  "annulation",        :default => false
  end

  add_index "factures", ["devi_id"], :name => "devi_facture_id"

  create_table "factures_pvrecettes", :id => false, :force => true do |t|
    t.integer "pvrecette_id", :null => false
    t.integer "facture_id",   :null => false
  end

  add_index "factures_pvrecettes", ["facture_id"], :name => "factures_pvrecettes_facture_id"
  add_index "factures_pvrecettes", ["pvrecette_id"], :name => "factures_pvrecettes_pvrecette_id"

  create_table "informationlignes", :force => true do |t|
    t.string  "name"
    t.float   "number",         :default => 0.0
    t.float   "price",          :default => 0.0
    t.integer "devi_id",                           :null => false
    t.integer "information_id",                    :null => false
    t.string  "unite",          :default => "pce"
    t.integer "position"
  end

  add_index "informationlignes", ["devi_id"], :name => "devi_id"
  add_index "informationlignes", ["information_id"], :name => "information_id"

  create_table "informations", :force => true do |t|
    t.string "name"
  end

  create_table "lignedevis", :force => true do |t|
    t.integer "devi_id", :default => 0,   :null => false
    t.float   "prix",    :default => 0.0
    t.string  "name",    :default => ""
  end

  add_index "lignedevis", ["devi_id"], :name => "altered_lignedevis_devi_id"

  create_table "pvrecettes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "numpvrecette"
    t.integer  "devi_id",      :default => 1, :null => false
  end

  add_index "pvrecettes", ["devi_id"], :name => "index_devi_pvrecettes"

  create_table "titleinformationlignes", :force => true do |t|
    t.string   "title",                                     :null => false
    t.integer  "informationligne_id", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "information_id",      :default => 0,        :null => false
    t.integer  "devi_id",             :default => 0,        :null => false
    t.float    "font_size",           :default => 10.0,     :null => false
    t.string   "font_weight",         :default => "normal", :null => false
  end

  add_index "titleinformationlignes", ["devi_id"], :name => "titleinformationlignes_devi_id"
  add_index "titleinformationlignes", ["information_id"], :name => "altered_titleinformationlignes_information_id"
  add_index "titleinformationlignes", ["informationligne_id"], :name => "titleinformationlignes_informationligne_id"

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
