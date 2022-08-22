class PasswordResetMailer < ApplicationMailer
  def reset_email(user)
    @user = user
    mail(to: @user.correo_adicional, subject: 'Instrucciones para reestablecer la contraseña')
  end
end
