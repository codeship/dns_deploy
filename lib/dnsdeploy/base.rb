require 'dnsdeploy/util'

module Dnsdeploy
  class Base
    include Util

    def self.update_records(records_file_path)
      self.new(records_file_path).update_records
    end

    def initialize(records_file_path)
      @records_file_path = records_file_path

      @local_records_json = LazyLoader.create_lazy_loader do
        File.new(@records_file_path).read
      end
      @local = LazyLoader.create_lazy_loader do
        Dnsdeploy::Local.new(@local_records_json.get)
      end
      @valid = LazyLoader.create_lazy_loader do
        _validate_json(@local_records_json.get, @records_file_path.get)
      end
    end

    def validate
      @valid.get
    end

    def update_records
      @local.get.domains.each do |domain|
        exit 1 unless _update_record(domain)
      end
    end

    private

    def _update_record(domain)
        log "[Processing] Domain #{domain.name}"
        # Delete records on DNSimple
        DNSimple::Record.all(domain).collect(&:destroy)
        # create records, return false if there was a false
        !@local.get.records(domain).map(&:_dnsimple_record_create).include?(false)
    end

    def _dnsimple_record_create(record)
      log "[CREATE] #{record}".green
      begin
        DNSimple::Record.create(record.domain, record.name, record.record_type,
          record.content, { ttl: record.ttl, prio: record.prio })
        true
      rescue DNSimple::RequestError => e
        log "[ERROR] #{e} #{record}".red
        false
      end
    end

    def _validate_json(json, file_path = nil)
      begin
        JSON.load(json)
        log "#{file_path || "Input JSON"} is valid json".green
        true
      rescue => e
        log "unable to parse #{file_path || "input JSON"}".red
        false
      end
    end
  end
end
