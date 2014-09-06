module Dnsdeploy
  class Base
    def initialize(records_file)
      @records_file = File.new(records_file)
    end

    def self.update_records(records_file)
      self.new(records_file).update_records
    end

    def validate
      JSON.load(@records_file.read)
      puts "#{@records_file.path} is valid json".green
    rescue => e
      puts "unable to parse #{@records_file.path}".red
    end

    def update_records
      local.domains.each do |domain|
        puts "[Processing] Domain #{domain.name}"

        # Delete records on DNSimple
        DNSimple::Record.all(domain).collect(&:destroy)

        # create records
        local.records(domain).each do |record|
          puts "[CREATE] #{record}".green
          begin
            DNSimple::Record.create(record.domain, record.name, record.record_type,
              record.content, { ttl: record.ttl, prio: record.prio })
          rescue DNSimple::RequestError => e
            puts "[ERROR] #{e} #{record}".red
            @exit = 1
          end
        end

        exit(@exit) if @exit
      end
    end

    def local
      @local ||= Dnsdeploy::Local.new(@records_file)
    end
  end
end
