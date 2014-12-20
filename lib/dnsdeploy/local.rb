require 'singleton'

module Dnsdeploy
  class Local
    def initialize(local_records_json)
      @local_records_json = local_records_json
    end

    def all_records
      @all_records ||= json.map do |record_set|
        domain = dnsimple_domain(record_set['zone'])
        create_records(domain, record_set['records'])
      end.flatten
    end

    def records(domain)
      all_records.select { |r| r.domain.name == domain.name }
    end

    def domains
      @domains ||= json.inject({}) do |memo, record_set|
        memo[record_set['zone']] = dnsimple_domain(record_set['zone'])
        memo
      end
    end

    def create_records(domain, json_records)
      json_records.map do |record|
        Record.new(domain: domain, name: record['name'], record_type: record['type'],
          content: record['value'], ttl: record['ttl'], prio: record['prio'])
      end
    end

    def json
      @json ||= JSON.load(@local_records_json)
    end

    def dnsimple_domain(zone)
      @dnsimple_domains ||= {}
      @dnsimple_domains[zone] ||= DNSimple::Domain.all.select { |d| d.name == zone }.first
    end
  end
end
