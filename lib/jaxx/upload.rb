require 'jaxx/process'

module Jaxx
  class Upload

    attr_reader :process

    def initialize args = {}
      @process = Process.new(args.merge('validations' => [:privacy, :file_exists]))
    end

    def execute
      process.start do |storage|
        directory  = storage.directories.get(process.bucket)
        directory ||= storage.directories.create(:key => process.bucket, :public => process.public?)
        directory.files.create(:key => File.basename(process.file), :body => File.read(process.file), :public => process.public?)
      end
    end

  end
end