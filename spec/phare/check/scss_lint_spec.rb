require 'spec_helper'

describe Phare::Check::ScssLint do
  let(:described_class) { Phare::Check::ScssLint }

  describe :should_run? do
    let(:check) { described_class.new('.') }
    before do
      expect(Phare).to receive(:system_output).with('which scss-lint').and_return(which_output)
      allow(Dir).to receive(:exists?).with(check.path).and_return(path_exists?)
    end

    context 'with found scss-lint command' do
      let(:which_output) { 'scss-lint' }
      let(:path_exists?) { true }
      it { expect(check).to be_able_to_run }
    end

    context 'with unfound scss-lint command' do
      let(:which_output) { '' }
      let(:path_exists?) { false }
      it { expect(check).to_not be_able_to_run }
    end
  end

  describe :run do
    let(:check) { described_class.new('.') }
    let(:run!) { check.run }

    context 'with available ScssLint' do
      let(:command) { check.command }

      before do
        expect(check).to receive(:should_run?).and_return(true)
        expect(Phare).to receive(:system).with(command)
        expect(Phare).to receive(:last_exit_status).and_return(scsslint_exit_status)
        expect(check).to receive(:print_banner)
      end

      context 'with check errors' do
        let(:scsslint_exit_status) { 0 }
        before { expect(Phare).to receive(:puts).with('Everything looks good from here!') }
        it { expect { run! }.to change { check.status }.to(scsslint_exit_status) }
      end

      context 'without check errors' do
        let(:scsslint_exit_status) { 1337 }
        before { expect(Phare).to receive(:puts).with("Something went wrong. Program exited with #{scsslint_exit_status}.") }
        it { expect { run! }.to change { check.status }.to(scsslint_exit_status) }
      end

      context 'with --diff option' do
        let(:check) { described_class.new('.', diff: true) }
        let(:files) { ['foo.css', 'bar.css.scss'] }
        let(:command) { "scss-lint #{files.join(' ')}" }
        let(:scsslint_exit_status) { 1337 }

        before { expect(check.tree).to receive(:changes).and_return(files).at_least(:once) }

        it { expect { run! }.to change { check.status }.to(scsslint_exit_status) }
      end
    end

    context 'with unavailable ScssLint' do
      before do
        expect(check).to receive(:should_run?).and_return(false)
        expect(Phare).to_not receive(:system).with(check.command)
        expect(check).to_not receive(:print_banner)
      end

      it { expect { run! }.to change { check.status }.to(0) }
    end
  end
end
