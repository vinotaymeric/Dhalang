require "Dhalang/version"
require 'uri'
require 'tempfile'

module Dhalang
  class Screenshot
    SCREENSHOT_GENERATOR_JS_PATH = File.expand_path('../js/screenshotgenerator.js', __FILE__)

    def self.get_from_url_as_jpeg(url)
      DhalangHelper::validate_url(url)
      get_image(url, :jpeg)
    end

    def self.get_from_url_as_png(url)
      DhalangHelper::validate_url(url)
      get_image(url, :png)
    end

    private
    def self.create_temporary_screenshot_file
      # TODO: change this to non png, it is not related to file format i guess. And if it is than jpeg shouldn't work.
      Tempfile.new("png")
    end

    def self.get_image(url, type)
      temp_file = create_temporary_screenshot_file
      begin
        visit_page_with_puppeteer(url, temp_file.path, type)
        binary_image_content = get_file_content_as_binary_string(temp_file)
      ensure
        DhalangHelper::remove_temp_file(temp_file)
      end
      return binary_image_content
    end

    def self.visit_page_with_puppeteer(page_to_visit, path_to_save_pdf_to, image_save_type)
      system("node #{SCREENSHOT_GENERATOR_JS_PATH} #{page_to_visit} #{Shellwords.escape(path_to_save_pdf_to)} #{Shellwords.escape(DhalangHelper::PUPPETEER_DIRECTORY)} #{Shellwords.escape(image_save_type)}")
    end

    def self.get_file_content_as_binary_string(file)
      IO.binread(file.path)
    end
  end
end
