class Savedbmailer < ActionMailer::Base
  default :from => "billing@tharsis-software.com"

  def save_mail_db
	  mail(:to => "billing@tharsis-software.com", :subject => "Sauvegarde du fichier de la base de donnée sqlite")
	  mail.attachments['development.sqlite3'] = {:mime_type => 'application/x-gzip',
		                                       :content => File.read("#{RAILS_ROOT}/db/development.sqlite3")}
  end
end
