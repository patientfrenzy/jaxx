require 'fog'

module Jaxx
  class Process

    PRIVACIES = %w[public private]
    
    attr_reader :bucket, :access_key, :access_secret, :file, :privacy, :validations

    def initialize args = {}
      @bucket, @access_key, @access_secret, @file, @privacy = args.values_at 'bucket', 'access_key', 'access_secret', 'file', 'privacy', 'validations'
      @validations = [:bucket, :credentials, :file_presence] + (args['validations'] || [])
    end

    def privacy
      @privacy || 'private'
    end

    def private?
      privacy.to_s == 'private'
    end

    def public?
      !private?
    end

    def credentials
      return @credentials unless @credentials.nil?

      key, secret = access_key.to_s, access_secret.to_s
      @credentials = if key.empty? or secret.empty?
        Jaxx.environment.credentials
      else
        Jaxx::Environment::DEFAULT_CREDENTIALS.dup.merge!(:aws_access_key_id => key, :aws_secret_access_key => secret)
      end
    end

    def start &block
      errs = errors
      
      ["Unable to process transaction: ", format_errors(errs)].flatten.each do |msg|
        Jaxx.logger.write msg
      end and raise(RuntimeError, errs.inspect) unless errs.empty?

      block.call(storage)
    end

    def validate
      validations.inject({}) do |hsh, name|
        validation = send("validate_#{name}")
        hsh[name] = validation unless validation.nil?
        hsh
      end
    end

    alias :errors :validate

    private

    def storage
      @storage ||= Fog::Storage::AWS.new credentials 
    end

    def validate_bucket
      "is required" if bucket.to_s.empty?
    end

    def validate_file_presence
      "is required" if file.to_s.empty?
    end

    def validate_file_exists
      "returned false" unless File.exist?(file.to_s)
    end

    def validate_credentials
      "for access key and access secret required" if credentials[:aws_access_key_id].empty? or credentials[:aws_secret_access_key].empty?
    end

    def validate_privacy
      "#{privacy} is not supported" unless PRIVACIES.include?(privacy.to_s)
    end

    def format_errors(errs)
      errs.collect {|name, msg| [name.to_s.gsub(/_/, ' '), msg].join(' ') }
    end
  end
end
