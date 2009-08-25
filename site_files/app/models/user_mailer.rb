class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Confirmação do endereço de email'
    @body[:url]  = "http://ism.itacaproject.com/activate/#{user.activation_code}"
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'A seu registo está confirmado!'
    @body[:url]  = "http://ism.itacaproject.com/"
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "Imagens e Sonoriades das Migrações"
      @subject     = "[ism.itacaproject.com] "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
