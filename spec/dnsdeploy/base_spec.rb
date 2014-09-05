require 'spec_helper'

describe Dnsdeploy::Base do
  let(:domain)      { DNSimple::Domain.new name: random_domain }
  let(:name)        { random_string }
  let(:record_type) { random_string }
  let(:content)     { random_string }
  let(:ttl)         { random_number }
  let(:prio)        { random_number }
  let(:local)       { double(:local, domains: [domain], records: [record]) }
  let(:record)      { Dnsdeploy::Record.new(domain: domain, name: name, record_type: record_type,
                                            content: content, ttl: ttl, prio: prio ) }
  let(:records_file) { 'spec/assets/records.json' }

  subject(:base) { described_class.new(records_file) }

  before do
    allow(DNSimple::Record).to receive(:all).and_return([])
    allow(Dnsdeploy::Local).to receive(:new).and_return local
  end

  it "should create records" do
    expect(DNSimple::Record).to receive(:create).with(domain, name, record_type, content, {ttl: ttl, prio: prio })
    base.update_records
  end
end
