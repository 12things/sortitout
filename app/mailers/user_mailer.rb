class UserMailer < ActionMailer::Base
  layout 'email' # use email.(html|text).erb as the layout
  default :from => "sort it out! <noreply@sortitout.de>"
  
  def account_activation(user)
    @user = user
    @url  = activation_url(@user.perishable_token)
    mail(:to => user.email,
         :subject => "Aktiviere deinen Account, #{user.email}!")
  end
  
  def topic_invitation(user, topic)
    @user = user
    @topic = topic
    @url  = topic_url(topic)
    mail(:to => user.email,
         :subject => "Einladung zum Thema „#{topic.title}“!")
  end  
end
