require "Dhalang/version"
require 'uri'
require 'tempfile'

module Dhalang
  class PDF
    PDF_GENERATOR_JS_PATH = File.expand_path('../js/pdfgenerator.js', __FILE__)

    def self.get_from_url(url)
      DhalangHelper::validate_url(url)
      pdf_temp_file = Tempfile.new("pdf")
      begin
        visit_page_with_puppeteer(url, pdf_temp_file.path)
        binary_pdf_content = get_file_content_as_binary_string(pdf_temp_file)
      ensure
        DhalangHelper::remove_temp_file(pdf_temp_file)
      end
      return binary_pdf_content
    end

    def self.get_from_html(html)
      html_temp_file = create_temporary_html_file(html)
      pdf_temp_file = Tempfile.new("pdf")
      begin
        visit_page_with_puppeteer("file://" + html_temp_file.path, pdf_temp_file.path)
        binary_pdf_content = get_file_content_as_binary_string(pdf_temp_file)
      ensure
        DhalangHelper::remove_temp_file(pdf_temp_file)
        DhalangHelper::remove_temp_file(html_temp_file)
      end
      return binary_pdf_content
    end

    private
    ## Creates a temp .html file which can be browsed to by puppeteer for creating a pdf
    def self.create_temporary_html_file(content)
      html_file = Tempfile.new(['page', '.html'])
      html_file.write(content)
      html_file.rewind
      return html_file
    end

    def self.visit_page_with_puppeteer(page_to_visit, path_to_save_pdf_to)
      system("node #{PDF_GENERATOR_JS_PATH} #{page_to_visit} #{Shellwords.escape(path_to_save_pdf_to)} #{Shellwords.escape(DhalangHelper::PUPPETEER_DIRECTORY)}")
    end

    def self.get_file_content_as_binary_string(file)
      IO.binread(file.path)
    end
  end
end
