module Dnsdeploy
  class Base
    def initialize(args)
      @records_file = File.new(args.first)
    end

    def self.update_records(args)
      self.new(args).update_records
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
