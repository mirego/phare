require 'spec_helper'

describe Phare::Check::Stylelint do
  let(:described_class) { Phare::Check::Stylelint }

  describe :should_run? do
    let(:check) { described_class.new('.') }
    let(:config_exists?) { true }
    let(:path_exists?) { true }
    let(:local_which_output) { '' }
    let(:global_which_output) { '' }
    before do
      allow(Phare).to receive(:system_output).with('which stylelint').and_return(global_which_output)
      allow(Phare).to receive(:system_output).with('which .node_modules/.bin/stylelint').and_return(local_which_output)
      allow(File).to receive(:exist?).with(check.config).and_return(config_exists?)
      allow(Dir).to receive(:exist?).with(check.path).and_return(path_exists?)
    end

    context 'with found stylelint command' do
      context 'for a local stylelint' do
        let(:local_which_output) { 'node_modules/.bin/stylelint' }
        it { expect(check).to be_able_to_run }
      end

      context 'for a global stylelint' do
        let(:global_which_output) { 'stylelint' }
        it { expect(check).to be_able_to_run }
      end

      context 'with only excluded files and the --diff option' do
        let(:global_which_output) { 'stylelint' }
        let(:check) { described_class.new('.', diff: true) }
        let(:files) { ['foo.scss'] }

        before do
          expect(check).to receive(:excluded_files).and_return(files).once
          expect(check.tree).to receive(:changes).and_return(files).at_least(:once)
        end

        it { expect(check.should_run?).to be_falsey }
      end
    end

    context 'with unfound stylelint command' do
      let(:config_exists?) { false }
      let(:path_exists?) { false }
      it { expect(check).to_not be_able_to_run }
    end
  end

  describe :run do
    let(:check) { described_class.new('.') }
    let(:run!) { check.run }

    context 'with available Stylelint' do
      let(:command) { check.command }

      before do
        expect(check).to receive(:should_run?).and_return(true)
        expect(Phare).to receive(:system).with(command)
        expect(Phare).to receive(:last_exit_status).and_return(stylelint_exit_status)
        expect(check).to receive(:print_banner)
      end

      context 'without check errors' do
        let(:stylelint_exit_status) { 0 }
        before { expect(Phare).to receive(:puts).with('Everything looks good from here!') }
        it { expect { run! }.to change { check.status }.to(stylelint_exit_status) }
      end

      context 'with check errors' do
        let(:stylelint_exit_status) { 1 }
        before { expect(Phare).to receive(:puts).with("Something went wrong. Program exited with #{stylelint_exit_status}.") }
        it { expect { run! }.to change { check.status }.to(stylelint_exit_status) }
      end

      context 'with --diff option' do
        let(:check) { described_class.new('.', diff: true) }
        let(:files) { ['foo.rb', 'bar.rb'] }
        let(:stylelint_exit_status) { 0 }

        context 'without exclusions' do
          let(:command) { "stylelint #{files.join(' ')}" }

          before do
            expect(check.tree).to receive(:changes).and_return(files).at_least(:once)
            expect(check).to receive(:excluded_files).and_return([]).once
          end

          it { expect { run! }.to change { check.status }.to(stylelint_exit_status) }
        end

        context 'with exclusions' do
          let(:command) { 'stylelint bar.rb' }

          before do
            expect(check).to receive(:excluded_files).and_return(['foo.rb']).once
            expect(check.tree).to receive(:changes).and_return(files).at_least(:once)
          end

          it { expect { run! }.to change { check.status }.to(stylelint_exit_status) }
        end
      end
    end

    context 'with unavailable Stylelint' do
      before do
        expect(check).to receive(:should_run?).and_return(false)
        expect(Phare).to_not receive(:system).with(check.command)
        expect(check).to_not receive(:print_banner)
      end

      it { expect { run! }.to change { check.status }.to(0) }
    end
  end
end
