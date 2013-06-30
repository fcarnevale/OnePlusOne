class PairingMailer < ActionMailer::Base
  default from: "ifttt@fourward.org"

  def weekly_pairing(person)
    @person = person
    mail(to: person.email, subject: "Here is your 1+1 pairing for the week!")
  end
end