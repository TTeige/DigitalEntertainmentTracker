ActionMailer::Base.delivery_method = :smtp
ActionMailer::Basesmtp_settings = {
    :address                => 'smtp.gmail.com',
    :port                   => '587',
    :authentication         => :plain,
    :user_name              => ENV["GMAIL_USERNAME"],
    :password               => ENV["GMAIL_PASSWORD"],
    :domain                 => ENV["GMAIL_DOMAIN"],
    :enable_starttls_auto   => true
}