require 'spec_helper'

describe Phare::CheckSuite do
  describe :run do
    let(:suite) { described_class.new('.') }

    before do
      Phare::CheckSuite::CHECKS.each_with_index do |check, index|
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
      let(:exit_status_proc) { proc { |index| 0 } }

      it { expect { suite.run }.to change { suite.status }.to(0) }
    end
  end
end
