module EmailTemplateHelper

  def mail_with_template(params={})
    params[:body] = params[:email_template].present? ? params[:email_template].parsed_body(params[:template_params]) : params[:body]
    params[:subject] = params[:email_template].present? ? params[:email_template].parsed_subject(params[:template_params]) : params[:subject]
    mail(params.except(:email_template))
  end

end
