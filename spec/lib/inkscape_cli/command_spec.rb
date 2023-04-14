# frozen_string_literal: true
require_relative '../../spec_helper'
require 'ostruct'

RSpec.describe InkscapeCLI::Command do
  let(:exitstatus) { 0 }
  let(:thread_value) { OpenStruct.new(exitstatus: exitstatus) }
  let(:thread) { instance_double(Process::Waiter, pid: 123, value: thread_value, join: true) }
  let(:stdin) { instance_double(IO, binmode: nil, read: '') }
  let(:stdout) { instance_double(IO, binmode: nil, read: '') }
  let(:stderr) { instance_double(IO, binmode: nil, read: '') }
  let(:command_response) { [stdout.read, stderr.read, exitstatus] }

  before do
    allow(Open3).to receive(:popen3).and_yield(stdin, stdout, stderr, thread)
    allow(thread).to receive(:join).and_return(true)
  end

  describe '#new' do
    subject { described_class.new }

    it 'instantiates the object' do
      expect(subject).to be_an_instance_of(described_class)
    end

    context 'when a block is provided' do
      subject do
        described_class.new do |command|
          command.input_file = 'fixtures/input.svg'
        end
      end

      it 'instantiates the object and calls the block with it' do
        expect(subject).to eq(command_response)
      end
    end
  end

  describe '#execute' do
    subject do
      c = described_class.new
      c.instance_variable_set(:@args, args)
      c.execute
    end

    let(:args) { ['fixtures/input.svg', '-o', 'output.png'] }

    it 'calls out to shell using the executable, args, and timeout' do
      subject
      expect(Open3).to have_received(:popen3).with(InkscapeCLI.executable, *args)
      expect(thread).to have_received(:join).with(InkscapeCLI.timeout)
    end
  end

  describe '#method_missing' do
    subject do
      c = described_class.new
      c.export_filename = 'out.png'
      c
    end

    it 'uses the method name to set an arg' do
      expect(subject.args).to eq(['--export-filename', 'out.png'])
    end
  end

  describe '#input_file' do
    subject do
      c = described_class.new
      c.input_file = 'input.png'
      c
    end

    it 'sets the input file as an arg' do
      expect(subject.args).to eq(['input.png'])
    end
  end
end
