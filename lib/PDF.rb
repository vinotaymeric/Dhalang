require "Dhalang/version"
require 'uri'
require 'tempfile'

module Dhalang
  # Contains a set of methods that can be used for creating PDF's with Puppeteer.
  class PDF
    PDF_GENERATOR_JS_PATH = File.expand_path('../js/pdfgenerator.js', __FILE__)

    # Creates a fullsize PDF from the given url.
    #
    # @params::url - The url to create the PDF of, make sure it starts with www. and ends with a .tld.
    #
    # @returns A string containing the created PDF in binary.
    #
    def self.get_from_url(url)
      DhalangHelper::validate_url(url)
      pdf_temp_file = Tempfile.new("pdf")
      begin
        visit_page_with_puppeteer(url, pdf_temp_file.path)
        binary_pdf_content = DhalangHelper::read_file_content_as_binary_string(pdf_temp_file)
      ensure
        DhalangHelper::remove_temp_file(pdf_temp_file)
      end
      return binary_pdf_content
    end

    # Creates a fullsize PDF from the given html content.
    #
    # @params::html - The content of the html file to create.
    #
    # @returns A string containing the created PDF in binary.
    #
    def self.get_from_html(html)
      html_temp_file = create_temporary_html_file(html)
      pdf_temp_file = Tempfile.new("pdf")
      begin
        visit_page_with_puppeteer("file://" + html_temp_file.path, pdf_temp_file.path)
        binary_pdf_content = DhalangHelper::read_file_content_as_binary_string(pdf_temp_file)
      ensure
        DhalangHelper::remove_temp_file(pdf_temp_file)
        DhalangHelper::remove_temp_file(html_temp_file)
      end
      return binary_pdf_content
    end

    private
    # Creates a temp .html file which can be browsed to by puppeteer for creating a pdf.
    #
    # @params::content - The content of the html file to create.
    #
    # @returns The created TempFile.
    #
    def self.create_temporary_html_file(content)
      html_file = Tempfile.new(['page', '.html'])
      html_file.write(content)
      html_file.rewind
      return html_file
    end

    # Performs a page visit with Puppeteer, then creates a PDF based on the page. 
    #
    # @params::url            - The url of the page to visit.
    # @params::temp_pdf_path  - The path of the temp file to write the created pdf to.
    #
    def self.visit_page_with_puppeteer(url, temp_pdf_path)
      system("node #{PDF_GENERATOR_JS_PATH} #{url} #{Shellwords.escape(temp_pdf_path)} #{Shellwords.escape(DhalangHelper::PUPPETEER_DIRECTORY)}")
    end
  end
end
