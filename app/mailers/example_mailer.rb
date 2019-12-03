# frozen_string_literal: true

class ExampleMailer < ApplicationMailer
  default from: 'from@example.com'

  def sample_email(user)
    @user = user
    mail(to: 'test_email@gmail.com', subject: 'File Transfer')
  end
end
