# frozen_string_literal: true

class GenericMailer < ApplicationMailer
  default from: %("NUSSU commIT" <duty@#{ENV['MAILGUN_DOMAIN']}>)

  def users_with_name(user_ids)
    User.find(user_ids)&.pluck(:username, :email)&.map do |u|
      %("#{u[0]}" <#{u[1]}>)
    end
  end
end
