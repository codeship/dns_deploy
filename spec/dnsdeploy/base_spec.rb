require 'spec_helper'

describe Dnsdeploy::Base do
  let(:name)        { random_string }
  let(:record_type) { random_string }
  let(:content)     { random_string }
  let(:ttl)         { random_number }
  let(:prio)        { random_number }
  let(:local)       { double(:local, domains: { 'example.com' => domain }, records: [record]) }
  let(:record)      { Dnsdeploy::Record.new(domain: domain, name: name, record_type: record_type,
                                            content: content, ttl: ttl, prio: prio ) }
  let(:records_file) { 'spec/assets/records.json' }

  subject(:base) { described_class.new(records_file) }

  before do
    allow(DNSimple::Record).to receive(:all).and_return([])
    allow(Dnsdeploy::Local).to receive(:new).and_return local
  end

  context 'existing domain' do
    let(:domain) { DNSimple::Domain.new name: random_domain }

    it "should create records" do
      expect(DNSimple::Record).to receive(:create).with(domain, name, record_type, content, {ttl: ttl, prio: prio })
      base.update_records
    end
  end

  context 'non existent domain' do
    let(:domain) { nil }

    it "should print an error" do
      expect(DNSimple::Record).to_not receive(:create)

      expect { base.update_records }.to output("[ERROR] Domain example.com does not exists on DNSimple\n").to_stdout
    end
  end
end
