# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@webamm.org'
  layout 'mailer'
end
