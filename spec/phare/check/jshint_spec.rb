require 'spec_helper'

describe Phare::Check::JSHint do
  let(:described_class) { Phare::Check::JSHint }

  describe :should_run? do
    let(:check) { described_class.new('.') }
    before do
      expect(Phare).to receive(:system_output).with('which jshint').and_return(which_output)
      allow(File).to receive(:exist?).with(check.config).and_return(config_exists?)
      allow(Dir).to receive(:exist?).with(check.path).and_return(path_exists?)
    end

    context 'with found jshint command' do
      let(:which_output) { 'jshint' }
      let(:config_exists?) { true }
      let(:path_exists?) { true }
      it { expect(check).to be_able_to_run }

      context 'with only excluded files and the --diff option' do
        let(:check) { described_class.new('.', diff: true) }
        let(:files) { ['foo.js'] }

        before do
          expect(check).to receive(:excluded_files).and_return(files).once
          expect(check.tree).to receive(:changes).and_return(files).at_least(:once)
        end

        it { expect(check.should_run?).to be_falsey }
      end
    end

    context 'with unfound jshint command' do
      let(:which_output) { '' }
      let(:config_exists?) { false }
      let(:path_exists?) { false }
      it { expect(check).to_not be_able_to_run }
    end
  end

  describe :run do
    let(:check) { described_class.new('.') }
    let(:run!) { check.run }

    context 'with available JSHint' do
      let(:command) { check.command }
      let(:directory) { '.' }
      let(:expanded_path) { '.jshintrc' }

      before do
        expect(File).to receive(:expand_path).with("#{directory}app/assets/javascripts", anything).once.and_call_original
        expect(File).to receive(:expand_path).with("#{directory}.jshintrc", anything).once.and_return(expanded_path)
        expect(check).to receive(:should_run?).and_return(true)
        expect(Phare).to receive(:system).with(command)
        expect(Phare).to receive(:last_exit_status).and_return(jshint_exit_status)
        expect(check).to receive(:print_banner)
      end

      context 'with check errors' do
        let(:jshint_exit_status) { 0 }
        before { expect(Phare).to receive(:puts).with('Everything looks good from here!') }
        it { expect { run! }.to change { check.status }.to(jshint_exit_status) }
      end

      context 'without check errors' do
        let(:jshint_exit_status) { 1337 }
        before { expect(Phare).to receive(:puts).with("Something went wrong. Program exited with #{jshint_exit_status}.") }
        it { expect { run! }.to change { check.status }.to(jshint_exit_status) }
      end

      context 'with --diff option' do
        let(:check) { described_class.new(directory, diff: true) }
        let(:files) { ['app/foo.js', 'bar.js'] }
        let(:jshint_exit_status) { 1337 }

        context 'without exclusions' do
          let(:command) { "jshint --config #{expanded_path} --extra-ext .js,.es6 #{files.join(' ')}" }

          before do
            expect(check.tree).to receive(:changes).and_return(files).at_least(:once)
            expect(check).to receive(:excluded_files).and_return([]).once
          end

          it { expect { run! }.to change { check.status }.to(jshint_exit_status) }
        end

        context 'with exclusions' do
          let(:command) { "jshint --config #{expanded_path} --extra-ext .js,.es6 bar.js" }

          before do
            expect(check).to receive(:excluded_files).and_return(['app/foo.js']).once
            expect(check.tree).to receive(:changes).and_return(files).at_least(:once)
          end

          it { expect { run! }.to change { check.status }.to(jshint_exit_status) }
        end
      end
    end

    context 'with unavailable JSHint' do
      before do
        expect(check).to receive(:should_run?).and_return(false)
        expect(Phare).to_not receive(:system).with(check.command)
        expect(check).to_not receive(:print_banner)
      end

      it { expect { run! }.to change { check.status }.to(0) }
    end
  end
end
