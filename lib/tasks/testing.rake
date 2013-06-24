desc "Test out some basic partnership stuff"

task :testing => :environment do

  def prep_people
    puts "resetting every person's 'paired' db field to false..."
    Person.all.each do |p|
      puts "resetting #{p.name} to false"
      p.paired = false
      p.save
    end
    puts "done resetting 'paired' field on all people"
    puts ""
    puts ""
  end

  prep_people

  # people = Person.all(order: "teams_count ASC")
  people = Person.all
  people.sort_by!(&:teams_count)

  people.each do |p|
    unless p.paired == true
      puts "#{p.name}"
      puts "paired? #{p.paired}"
      puts "---"
      puts ""

      potential_partners = p.potential_partners
      potential_partners.shuffle!

      puts "potential partners for #{p.name} are #{potential_partners.inspect}..."
      potential_partners.each do |potential|
        puts "potential partner: #{potential.name}"
        puts "paired? #{potential.paired}"
        puts "---"
        puts "setting paired to true"
        potential.paired = true
        potential.save
        puts "paired? #{potential.paired}"
        puts ""
      end
    end
  end
end