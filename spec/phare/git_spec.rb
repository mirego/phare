require 'spec_helper'

describe Phare::Git do
  let(:described_class) { Phare::Git }

  let(:extensions) { ['.rb'] }
  let(:options) { { diff: true } }
  let(:git) { described_class.new(extensions, options) }

  describe :changed? do
    context 'with --diff options' do
      before { expect(git).to receive(:changes).and_return(changes) }

      context 'with changes' do
        let(:changes) { ['foo.rb'] }

        it { expect(git.changed?).to eq(true) }
      end

      context 'without changes' do
        let(:changes) { [] }

        it { expect(git.changed?).to eq(false) }
      end
    end

    context 'without --diff options' do
      let(:options) { { diff: false } }

      it { expect(git.changed?).to eq(false) }
    end
  end

  describe :changes do
    before { expect(Phare).to receive(:system_output).with('git status -s').and_return(tree) }

    context 'with empty tree' do
      let(:tree) { '' }

      it { expect(git.changes).to eq([]) }
    end

    context 'with untracked file' do
      let(:tree) { "?? foo.rb" }

      it { expect(git.changes).to eq(['foo.rb']) }
    end

    context 'with added file' do
      let(:tree) { "A  foo.rb\nAM bar.rb" }

      it { expect(git.changes).to eq(['foo.rb', 'bar.rb']) }
    end

    context 'with modified file' do
      let(:tree) { "M  foo.rb\nDM bar.rb" }

      it { expect(git.changes).to eq(['foo.rb']) }
    end

    context 'with deleted file' do
      let(:tree) { " D foo.rb\nMD bar.rb" }

      it { expect(git.changes).to eq([]) }
    end
  end
end
