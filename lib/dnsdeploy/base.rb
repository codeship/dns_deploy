module Dnsdeploy
  class Base
    def initialize(records_file_path)
      @records_file_path = records_file_path
      @local_records_json = File.new(records_file_path).read
    end

    def self.update_records(records_file_path)
      self.new(records_file_path).update_records
    end

    def validate
      JSON.load(@local_records_json)
      puts "#{@records_file_path} is valid json".green
    rescue => e
      puts "unable to parse #{@records_file_path}".red
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
      @local ||= Dnsdeploy::Local.new(@local_records_json)
    end
  end
end
