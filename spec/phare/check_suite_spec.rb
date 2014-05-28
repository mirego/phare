require 'spec_helper'

describe Phare::CheckSuite do
  let(:described_class) { Phare::CheckSuite }

  describe :run do
    let(:options) { { directory: '.' } }
    let(:suite) { described_class.new(options) }

    before do
      Phare::CheckSuite::DEFAULT_CHECKS.values.each_with_index do |check, index|
        exit_status = exit_status_proc.call(index)
        allow_any_instance_of(check).to receive(:run)
        allow_any_instance_of(check).to receive(:status).and_return(exit_status)
      end
    end

    context 'with a single failing check' do
      let(:exit_status_proc) do
        proc { |index| index == 2 ? 1337 : 0 }
      end

      it { expect { suite.run }.to change { suite.status }.to(1337) }
    end

    context 'with a multiple failing checks' do
      let(:exit_status_proc) do
        proc { |index| (index * 500) + 20 }
      end

      it { expect { suite.run }.to change { suite.status }.to(20) }
    end

    context 'with no failing check' do
      let(:exit_status_proc) { proc { 0 } }

      it { expect { suite.run }.to change { suite.status }.to(0) }
    end
  end

  describe :checks do
    let(:options) { { directory: '.', skip: skip, only: only } }
    let(:suite) { described_class.new(options) }
    let(:skip) { [] }
    let(:only) { [] }

    context 'with "only" option' do
      let(:only) { [:rubocop, :foo, :jshint] }
      it { expect(suite.checks).to eql [:rubocop, :jshint] }
    end

    context 'with "skip" option' do
      let(:skip) { [:scsslint, :foo, :jshint] }
      it { expect(suite.checks).to eql [:rubocop, :jscs] }
    end

    context 'with both "only" and "skip" option' do
      let(:skip) { [:scsslint, :rubocop] }
      let(:only) { [:scsslint, :foo, :jshint] }
      it { expect(suite.checks).to eql [:scsslint, :jshint] }
    end

    context 'with both "only" and "skip" option' do
      it { expect(suite.checks).to eql Phare::CheckSuite::DEFAULT_CHECKS.keys }
    end
  end
end
