require "Dhalang/version"
require 'uri'
require 'tempfile'

module Dhalang
  # Contains a set of methods that can be used for creating screenshots with Puppeteer.
  class Screenshot
    SCREENSHOT_GENERATOR_JS_PATH = File.expand_path('../js/screenshotgenerator.js', __FILE__)

    # Creates a fullsize JPEG screenshot from the given url.
    #
    # @params::url - The url to create the screenshot of, make sure it starts with http://www. or https://www. and ends with a .tld.
    #
    # @returns A string containing the created screenshot in binary.
    #
    def self.get_from_url_as_jpeg(url)
      DhalangHelper::ensure_url_is_valid(url)
      get_image(url, :jpeg)
    end

    # Creates a fullsize PNG screenshot from the given url.
    #
    # @params::url - The url to create the screenshot of, make sure it starts with http://www. or https://www. and ends with a .tld.
    #
    # @returns A string containing the created screenshot in binary.
    #
    def self.get_from_url_as_png(url)
      DhalangHelper::ensure_url_is_valid(url)
      get_image(url, :png)
    end

    private
    # Groups logic for the creation of the screenshot. 
    #
    # @params::url  - The url of the page to visit.
    # @params::image_type - The file type of the image to use.
    # 
    # @returns A string containing the created screenshot in binary.
    #
    def self.get_image(url, image_type)
      temp_file = Tempfile.new(image_type.to_s)
      begin
        visit_page_with_puppeteer(url, temp_file.path, image_type)
        binary_image_content = DhalangHelper::read_file_content_as_binary_string(temp_file)
      ensure
        DhalangHelper::remove_temp_file(temp_file)
      end
      return binary_image_content
    end

    # Performs a page visit with Puppeteer, then creates a full-page screenshot of the page. 
    #
    # @params::url              - The url of the page to visit.
    # @params::temp_file_path   - The path of the temp file to write the created screenshot to.
    # @params::image_type       - The file type of the image to use.
    #
    def self.visit_page_with_puppeteer(url, temp_file_path, image_type)
      system("node #{SCREENSHOT_GENERATOR_JS_PATH} #{url} #{Shellwords.escape(temp_file_path)} #{Shellwords.escape(DhalangHelper::PUPPETEER_DIRECTORY)} #{Shellwords.escape(image_type)}")
    end
  end
end
