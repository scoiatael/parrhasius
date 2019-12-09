# frozen_string_literal: true

require 'fileutils'
require 'pathname'

INTO = ARGV.first
FROM = ARGV[1..-1]

if INTO.nil? || FROM.empty?
  raise StandardError, 'Usage: merge-into dest src1 src2..'
end

class ImgDir
  attr_reader :dir

  REQUIRED = %w[original thumbnail].freeze

  def initialize(dir)
    @dir = Pathname.new(File.expand_path(dir))
  end

  def valid?
    @dir.directory? && all_required_present? && no_extra_children?
  end

  def all_required_present?
    (children.map { |c| c.basename.to_s } - REQUIRED).empty?
  end

  def no_extra_children?
    (REQUIRED - children.map { |c| c.basename.to_s }).empty?
  end

  def children
    @dir.children
  end
end

srcs = FROM.map { |f| ImgDir.new(f) }

invalid = srcs.reject(&:valid?)

unless invalid.empty?
  raise StandardError, "#{invalid.map(&:dir).join(', ')} are invalid sources"
end

dst = ImgDir.new(INTO)

unless dst.dir.exist?
  FileUtils.mkdir_p(dst.dir + '/original')
  FileUtils.mkdir_p(dst.dir + '/thumbnail')
end

raise StandardError, "#{dst.dir} is invalid destination" unless dst.valid?

srcs.each do |s|
  s.children.each do |ch|
    type = ch.basename.to_s # either original or thumbnail
    ch.children .each do |c|
      c_dst = [dst.dir, type, c.basename].join('/')
      FileUtils.mv(c.realpath, c_dst)
    end
    FileUtils.rmdir(ch.realpath)
  end
  FileUtils.rmdir(s.dir)
end
