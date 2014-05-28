require 'spec_helper'

describe Phare::CLI do
  let(:described_class) { Phare::CLI }

  let(:cli) { described_class.new(env, argv) }
  let(:argv) { [] }
  let(:run!) { cli.run }

  describe :run do
    context 'with code check skipping' do
      let(:env) { { 'SKIP_CODE_CHECK' => '1' } }
      it { expect { run! }.to exit_with_code(0) }
    end

    context 'without code check skipping' do
      let(:env) { {} }

      context 'with suite errors' do
        before do
          expect(cli.suite).to receive(:run)
          expect(cli.suite).to receive(:status).and_return(1337)
        end

        it { expect { run! }.to exit_with_code(1) }
      end

      context 'without suite errors' do
        before do
          expect(cli.suite).to receive(:run)
          expect(cli.suite).to receive(:status).and_return(0)
        end

        it { expect { run! }.to exit_with_code(0) }
      end
    end
  end
end
