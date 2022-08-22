class NesAlumnosMailer < ActionMailer::Base
  default :from => "nes_system@kadasoftware.com"

  def registration_confirmation(user)
    @user = user
    mail(:to => user.email, :subject => "Registro Cuenta Servicios Escolares UTM")
  end
end
