class Notifier < ActionMailer::Base
  def activation_instructions(user, host_with_port)
    default_url_options[:host] = host_with_port
    subject       "Instrucciones de activación de su cuenta"
    from          "Widgets Ing. SW2 <se2widgets@gmail.com>"
    recipients    user.email
    sent_on       Time.now
    body          :account_activation_url => register_url(user.perishable_token)
  end

  def activation_confirmation(user, host_with_port)
    default_url_options[:host] = host_with_port
    subject       "Activación de cuenta completada"
    from          "Widgets Ing. SW2 <se2widgets@gmail.com>"
    recipients    user.email
    sent_on       Time.now
    body          :root_url => root_url
  end

  def request_approve(request, host_with_port)
    #ref = 
    default_url_options[:host] = host_with_port
    subject       "Solicitud Aprobada"
    from          "Widgets Ing. SW2 <se2widgets@gmail.com>"
    recipients    request.user.email
    sent_on       Time.now
    body          :reference => request.request_type == 'T'? Theme.find(request.theme_id).name : Widget.find(request.widget_id).name
  end

  def request_reject(request, host_with_port)
    ref = request.request_type == 'T'? Theme.find(request.theme_id).name : Widget.find(request.widget_id).name
    default_url_options[:host] = host_with_port
    subject       "Solicitud Rechazada"
    from          "Widgets Ing. SW2 <se2widgets@gmail.com>"
    recipients    request.user.email
    sent_on       Time.now
    body          :reference => ref
  end

  def password_reset_instructions(user, host_with_port)
    default_url_options[:host] = host_with_port
    subject       "Instrucciones para recuperar su password"
    from          "Widgets Ing. SW2 <se2widgets@gmail.com>"
    recipients   user.email
    content_type "text/html"
    sent_on      Time.now
    body         :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end
end