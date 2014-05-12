#!/usr/bin/env ruby
# encoding: utf-8

# File: file_methods.rb
# Created: 15/02/12
#
# (c) Michel Demazure <michel@demazure.com>

# production de rapports pour Jacinthe
module JacintheReports
  # separator for CSV files
  CSV_SEPARATOR = ';'

  # Pattern for cleaning filenames
  INCORRECT = /[^[[:alnum:]]]/

  # @param msg [String] string to be corrected
  # @return [String] string with bad characters replaced by dots.
  def self.correct(msg)
    msg.gsub(INCORRECT, '.')
  end

  # save file +filename+ as bak file
  # @param filename [String] name of file to save
  def self.bak(filename)
    if File.exist?(filename)
      bak_file = File.basename(filename, '.*') + '.bak'
      full_bak_file = File.join(File.dirname(filename), bak_file)
      File.rename(filename, full_bak_file)
    end
  end

  # @return [String] encoding for csv files
  def self.system_csv_encoding
    case
    when J2R.win?
      'iso-8859-1'
    when J2R.darwin?
      'iso-8859-1'
    else
      fail J2R::Error::SystemError, 'System not supported'
    end
  end

  # @param output [Array or String] output encode
  # @param encoding [String] encoding
  # @return [String] encoded output
  def self.protected_encode(output, encoding)
    output = Array(output).join("\n")
    output.encode(encoding, undef: :replace)
  end

  # save to path with csv system encoding
  # produce and save csv formatted output
  # @param path [Pathname] path of output file
  # @param output [Object] formatted output to save
  def self.to_csv_file(path, output)
    coding = J2R.system_csv_encoding
    output = protected_encode(output, coding)
    to_file(path, output, coding)
  end

  # write the output to a temporary file
  # @param ext [String] filename extension
  # @param output [Array] output to show in temp file
  # @param encoding [String] encoding of the temp file
  # @return [Path] the file path
  def self.to_temp_file(ext, output, encoding = 'utf-8')
    require 'tempfile'
    file = Tempfile.new(['J2R', ext], encoding: encoding)
    output = protected_encode(output, encoding)
    file.puts output
    file.close
    file.path
  end

  # save to file with bak
  # @param path [Pathname] path of output file
  # @param output [Object] formatted output to save
  # @param encoding [String] name of encoding, default "utf-8"
  def self.to_file(path, output, encoding = 'utf-8')
    bak(path)
    output = protected_encode(output, encoding)
    File.open(path, 'w', encoding: encoding) { |file| file.puts output }
    path
  end

  # dump obj to file in YAML form
  # @param path [String] absolute path of file
  # @param obj [Object] object to be written in yaml form
  def self.yaml_dump(path, obj)
    to_file(path, obj.to_yaml)
  end

  # Charge un fichier de configuration
  # @param filename [String] name of config file
  # @return [Hash] configurations
  def self.load_config(filename)
    path = File.expand_path(filename, CONFIG_DIR)
    YAML.load(File.open(path))
  rescue StandardError => err
    raise(Error::ConfigureError, err.message)
  end

  # open a file in the system
  # @param [Path] path file to open
  def self.open_file_command(path)
    case
    when J2R.win?
      system("start #{path}")
    when J2R.darwin?
      system("open #{path}")
    when J2R.linux?
      system("xdg-open #{path}")
    else
      fail J2R::Error::SystemError, 'System not supported'
    end
    'Fait'
  end
end
