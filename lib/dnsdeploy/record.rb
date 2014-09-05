module Dnsdeploy
  class Record < DNSimple::Record
    def to_s
      "#{self.name}.#{self.domain.name} #{self.record_type} #{self.content} (ttl: #{self.ttl})"
    end
  end
end
