class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  #validates_presence_of :numeropostal, :message=>"Veuillez entrer le numéro correspondant à votre adresse"
  #validates_presence_of :adressepostal, :message=>"Veuillez entrer l'adresse de cette utilisateur"
  #validates_presence_of :ville_id, :message=>"Veuillez séléctionner une ville"
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  validates_uniqueness_of :username
  #attr_accessible :name, :prenom, :numeropostal, :adressepostal, :ville_id, :birthdaydate, :email, :password, :password_confirmation
  attr_accessible :username, :email, :password, :password_confirmation
  #attr_accessor :region_id, :pay_id
end
