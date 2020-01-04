module Dhalang
    class DhalangHelper
        PUPPETEER_DIRECTORY = Dir.pwd + '/node_modules/'
 
        # Checks if the given url is valid. A url is valid if it starts with www. and ends with .sometld.
        #
        # @params::url - The url to validate
        #
        # @throws::InvalidURIError - In case the url was not found valid.
        #
        def self.validate_url(url)
            if (url !~ URI::DEFAULT_PARSER.regexp[:ABS_URI])
                raise URI::InvalidURIError, 'The given url was invalid, use format http://www.example.com'
            end
        end

        # Closes and then removes the given temp file.
        #
        # @params::temp_file - The temp file to remove to validate.
        #
        def self.remove_temp_file(temp_file)
            temp_file.close unless temp_file.closed?
            temp_file.unlink
        end
    end
end