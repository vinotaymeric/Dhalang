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
    end
end