require 'dalli'

RSpec.describe Heartcheck::Checks::Cache do
  let(:connection) { Dalli::Client.new }
  let(:check_errors) { subject.instance_variable_get(:@errors) }

  subject do
    described_class.new.tap do |c|
      c.add_service(name: 'Default check', connection: connection)
    end
  end

  describe '#validate' do
    context 'when nothing fails' do
      it 'calls set get and delete' do
        expect(connection).to receive(:set).and_call_original
        expect(connection).to receive(:get).and_call_original
        expect(connection).to receive(:delete).and_call_original
        subject.validate
        expect(check_errors).to be_empty
      end
    end

    context 'when something fails' do
      before do
        allow(connection).to receive(:set).and_return(false)
        allow(connection).to receive(:get).and_return(false)
        allow(connection).to receive(:delete).and_return(false)
      end

      context 'with default errors' do
        before do
          subject.validate
        end

        it { expect(check_errors).to include('Default check fails to set') }
        it { expect(check_errors).to include('Default check fails to get') }
        it { expect(check_errors).to include('Default check fails to delete') }
      end

      context 'with custom errors' do
        before do
          subject.on_error do |errors, name, key_error|
            errors << "#{name} can't #{key_error} a value"
          end
          subject.validate
        end

        context 'get' do
          let(:msg) { 'Default check can\'t set a value' }
          it { expect(check_errors).to include(msg) }
        end

        context 'get' do
          let(:msg) { 'Default check can\'t get a value' }
          it { expect(check_errors).to include(msg) }
        end

        context 'get' do
          let(:msg) { 'Default check can\'t delete a value' }
          it { expect(check_errors).to include(msg) }
        end
      end
    end

    it 'supports concurrent application instances/checks' do
      total_concurrent_instances = 30

      concurrent_checks = 0.upto(total_concurrent_instances).map do |n|
        Thread.new do
          checker_instance = described_class.new.tap do |c|
            c.add_service(name: "check #{n}", connection: connection)
          end

          checker_instance.check
        end
      end

      check_results = concurrent_checks.map(&:value)

      expect(check_results.inspect).not_to include('error')
    end
  end
end
