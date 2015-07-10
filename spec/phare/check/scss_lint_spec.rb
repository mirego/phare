require 'spec_helper'

describe Phare::Check::ScssLint do
  let(:described_class) { Phare::Check::ScssLint }

  describe :should_run? do
    let(:check) { described_class.new('.') }

    before do
      expect(Phare).to receive(:system_output).with('which scss-lint').and_return(which_output)
      allow(Dir).to receive(:exist?).with(check.send(:expanded_path)).and_return(path_exists?)
    end

    context 'with found scss-lint command' do
      let(:which_output) { 'scss-lint' }
      let(:path_exists?) { true }
      it { expect(check).to be_able_to_run }

      context 'with only excluded files and the --diff option' do
        let(:check) { described_class.new('.', diff: true) }
        let(:files) { ['foo.scss'] }

        before do
          expect(check).to receive(:excluded_files).and_return(files).once
          expect(check.tree).to receive(:changes).and_return(files).at_least(:once)
        end

        it { expect(check.should_run?).to be_falsey }
      end
    end

    context 'with unfound scss-lint command' do
      let(:which_output) { '' }
      let(:path_exists?) { false }
      it { expect(check).to_not be_able_to_run }
    end
  end

  describe :path do
    let(:check) { described_class.new('.') }

    before { expect(check).to receive(:configuration_file).and_return(configuration) }

    context 'with `scss_files` specified' do
      let(:configuration) { { 'scss_files' => scss_files } }

      context 'as a String' do
        let(:scss_files) { 'src/stylesheets/**/*.scss' }

        it { expect(check.send(:path)).to eql(scss_files) }
      end

      context 'as an Array' do
        let(:scss_files) { ['src/stylesheets/**/*.scss', 'vendor/**/*.scss'] }

        it { expect(check.send(:path)).to eql(scss_files.join(' ')) }
      end
    end

    context 'without `scss_files` specified' do
      let(:configuration) { {} }

      it { expect(check.send(:path)).to eql(Phare::Check::ScssLint::DEFAULT_PATH) }
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
        let(:files) { ['foo.rb', 'bar.rb'] }
        let(:scsslint_exit_status) { 1337 }

        context 'without exclusions' do
          let(:command) { "scss-lint #{files.join(' ')}" }

          before do
            expect(check.tree).to receive(:changes).and_return(files).at_least(:once)
            expect(check).to receive(:excluded_files).and_return([]).once
          end

          it { expect { run! }.to change { check.status }.to(scsslint_exit_status) }
        end

        context 'with exclusions' do
          let(:command) { 'scss-lint bar.rb' }

          before do
            expect(check).to receive(:excluded_files).and_return(['foo.rb']).once
            expect(check.tree).to receive(:changes).and_return(files).at_least(:once)
          end

          it { expect { run! }.to change { check.status }.to(scsslint_exit_status) }
        end
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
