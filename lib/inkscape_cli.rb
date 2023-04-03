# frozen_string_literal: true

require_relative 'inkscape_cli/version'
require_relative 'inkscape_cli/command'
require 'open3'
require 'timeout'

module InkscapeCli
  class Error < StandardError; end
end
