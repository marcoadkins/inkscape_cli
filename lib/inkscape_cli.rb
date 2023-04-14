# frozen_string_literal: true

require_relative 'inkscape_cli/version'
require_relative 'inkscape_cli/command'
require 'inkscape_cli/configuration'
require 'open3'
require 'timeout'

module InkscapeCLI
  extend InkscapeCLI::Configuration

  define_setting :executable, 'inkscape'
  define_setting :timeout, 300

  class Error < StandardError; end
end
