desc "Send weekly pairing emails"

task :send_weekly_pairing_emails => :environment do

  people = Person.all

  puts "preparing to send 1+1 emails for the week..."
  
  people.each do |p|
    unless p.current_partner == ""
      puts "sending 1+1 email for #{p.name}..."

      PairingMailer.weekly_pairing(p).deliver
      
      puts "email sent to #{p.name}."
      puts ""
    end
  end
  puts "done sending weekly 1+1 emails!"
  puts ""
end