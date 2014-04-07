require 'spec_helper'

describe Phare::Check::JSCS do
  describe :should_run? do
    let(:check) { described_class.new('.') }
    before do
      expect(Phare).to receive(:system_output).with('which jscs').and_return(which_output)
      allow(File).to receive(:exists?).with(check.config).and_return(config_exists?)
      allow(Dir).to receive(:exists?).with(check.path).and_return(path_exists?)
    end

    context 'with found jscs command' do
      let(:which_output) { 'jscs' }
      let(:config_exists?) { true }
      let(:path_exists?) { true }
      it { expect(check).to be_able_to_run }
    end

    context 'with unfound jscs command' do
      let(:which_output) { '' }
      let(:config_exists?) { false }
      let(:path_exists?) { false }
      it { expect(check).to_not be_able_to_run }
    end

  end

  describe :run do
    let(:check) { described_class.new('.') }
    let(:run!) { check.run }

    context 'with available JSCS' do
      let(:command) { check.command }

      before do
        expect(check).to receive(:should_run?).and_return(true)
        expect(Phare).to receive(:system).with(command)
        expect(Phare).to receive(:last_exit_status).and_return(jscs_exit_status)
        expect(check).to receive(:print_banner)
      end

      context 'with check errors' do
        let(:jscs_exit_status) { 0 }
        it { expect { run! }.to change { check.status }.to(jscs_exit_status) }
      end

      context 'without check errors' do
        let(:jscs_exit_status) { 1337 }
        before { expect(Phare).to receive(:puts).with("Something went wrong. Program exited with #{jscs_exit_status}.") }
        it { expect { run! }.to change { check.status }.to(jscs_exit_status) }
      end

      context 'with --diff option' do
        let(:check) { described_class.new('.', diff: true) }
        let(:files) { ['foo.js', 'bar.js'] }
        let(:command) { "jscs #{files.join(' ')}" }
        let(:jscs_exit_status) { 1337 }

        before { expect(check.tree).to receive(:changes).and_return(files).at_least(:once) }

        it { expect { run! }.to change { check.status }.to(jscs_exit_status) }
      end
    end

    context 'with unavailable JSCS' do
      before do
        expect(check).to receive(:should_run?).and_return(false)
        expect(Phare).to_not receive(:system).with(check.command)
        expect(check).to_not receive(:print_banner)
      end

      it { expect { run! }.to change { check.status }.to(0) }
    end
  end
end
