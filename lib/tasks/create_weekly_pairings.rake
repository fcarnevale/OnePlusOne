desc "Create the pairings for the week"

task :create_weekly_pairings => :environment do

  def reset_people
    puts "resetting every person's 'paired' db field to false..."
    Person.all.each do |p|
      puts "resetting #{p.name} to false"
      p.paired = false
      p.save
    end
    puts "done resetting 'paired' field on all people"
    puts ""
  end

  def reset_partnerships
    puts "resetting last week's partnerships so that they're no longer current..."
    partnerships = Partnership.where(current: true)
    partnerships.each do |p|
      p.current = false
      p.save
    end
    puts "done resetting partnerships"
    puts ""
  end

  reset_people
  reset_partnerships

  people = Person.all
  people.sort_by!(&:potential_partners_count)

  already_partnered = []

  people.each do |p|
    # puts "on #{p.name}. already_partnered is: #{already_partnered}"
    # puts ""
    unless already_partnered.include?(p.id)
      puts "finding a partner for #{p.name}..."
      puts ""

      never_partnered_with = p.never_partnered_with
      # puts "never_partnered_with for #{p.name}:"
      # puts "#{never_partnered_with}"
      # puts ""

      never_partnered_with.each do |person_id|
        # puts "already_partnered.include?(#{person_id}): #{already_partnered.include?(person_id)}"
        # puts "already_partnered.include?(#{p.id}): #{already_partnered.include?(p.id)}"
        unless already_partnered.include?(person_id)
          # puts "in the never_partnered_with unless block"
          # puts ""
          Partnership.create(partner_id: p.id, person_id: person_id, current: true)
          already_partnered << p.id
          already_partnered << person_id
          p.paired = true; p.save
          person = Person.find(person_id)
          person.paired = true; person.save
          puts "#{p.name}(#{p.id}) has been partnered with #{person.name}(#{person.id}) for the first time!"
          puts ""
          break
        end
      end

      next if already_partnered.include?(p.id)

      least_recent_partners = p.least_recent_partners

      least_recent_partners.each do |person_id|
        unless already_partnered.include?(person_id) || p.most_recent_partner == person_id
          # puts "in the least_recent_partners unless block"
          # puts ""
          Partnership.create(partner_id: p.id, person_id: person_id, current: true)
          already_partnered << p.id
          already_partnered << person_id
          p.paired = true; p.save
          person = Person.find(person_id)
          person.paired = true; person.save
          puts "#{p.name}(#{p.id}) has been partnered with #{person.name}(#{person.id})!"
          puts ""
          break
        end
      end
    end
  end
end