ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :tls => true,
  :address => "smtp.gmail.com",
  :port => "587",
  :domain => "se2.heroku.com",
  :authentication => :plain,
  :user_name => "se2widgets@gmail.com",
  :password => "unrayodesol"
}


# Mail de la facultad -- descomentar lo de abajo y agregar un user/pass porque el servidor de email de 
# la facultad no permite relay sin autenticación
# ActionMailer::Base.smtp_settings = {
#   :address => "mail.uca.edu.py",
#   :authentication => :plain,
#   :user_name => "",
#   :password => ""
# }