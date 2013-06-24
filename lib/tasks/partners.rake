desc "Test out some basic partnership stuff"

task :partners => :environment do

  def prep_people
    puts "resetting every person's 'paired' db field to false..."
    Person.all.each do |p|
      puts "resetting #{p.name} to false"
      p.paired = false
      p.save
    end
    puts "done resetting 'paired' field on all people"
    puts ""
  end

  prep_people

  people = Person.all
  people.sort_by!(&:teams_count)

  all_peeps = people.each_slice(2)

  all_peeps[0].each do |p_one|
    unless p_one.paired == true
      potential_partners = p_one.potential_partners
      potential_partners.shuffle!

      puts "potential partners for #{p_one.name} are #{potential_partners.inspect}..."
      puts ""
      potential_partners.each do |potential|
        unless p.paired == true || potential.paired == true
          puts "checking past partnerships between #{p.name} and #{potential.name}..."
          past_partnerships = Partnership.where("(partner_id = ? AND person_id = ?) OR (person_id = ? AND partner_id = ?)", p.id, potential.id, p.id, potential.id).sort_by(&:created_at)

          if past_partnerships.length == 0
            puts "#{p.name} and #{potential.name} will be partners for the first time!"
            Partnership.create(person_id: p.id, partner_id: potential.id)
            p.paired = true; p.save
            potential.paired = true; potential.save
            puts "partnership created between #{p.name} and #{potential.name}"
            puts ""

          elsif past_partnerships.length >= 1
            now = Time.now.utc
            last_partnership_time = past_partnerships.last.created_at.utc
            time_diff = now - last_partnership_time

            if time_diff > 2.weeks
              puts "#{p.name} and #{potential.name} haven't been partnered for more than two weeks"
              Partnership.create(person_id: p.id, partner_id: potential.id)
              p.paired = true; p.save
              potential.paired = true; potential.save
              puts "partnership created between #{p.name} and #{potential.name}"
              puts ""
            end
          end
        end
      end
    end
  end


  # algorithm
  # set paired to false before running
  # 1. sort people by their number of teams (people with least # of teams first)
  # 2. start pairing with the person at the top of that list, use array shift to "pop" first person off.
  #    remove their newly appointed partner as well
  # 3. retrieve eligible partners (on same team(s))
  # 4. look for someone they haven't partnered with yet. if that returns no one, 
  #    look for someone they haven't partnered with for two weeks. use the first record 
  #    that gets returned. if that returns no one, look for someone they didn't partner 
  #    with last week. use the first record returned. if that returns no one, give them any 
  #    person on their team. if that returns no one, they're out of luck.
  # 5. whenever a match is match, toggle a boolean field on them ()

end