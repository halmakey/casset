require_relative '../dsl'
require 'json'
require 'combine_pdf'

module Casset
  class Dsl
    def xcassets(name, &block)
      XCAssets.new File.join(@dirname, "#{name}.xcassets"), &block
    end
  end

  class XCAssets < Dsl
    def imageset(name, &block)
      XCImageSet.new File.join(@dirname, "#{name}.imageset"), &block
    end

    def dir(name, &block)
      XCAssets.new File.join(@dirname, name), &block
    end

    def compat(name, ipadfile, iphonefile)
      image = XCImageSet.new File.join(@dirname, "#{name}.imageset")
      image.image idiom: "universal", filename: "ipad.pdf"
      image.image idiom: "universal", filename: "iphone.pdf", "height-class" => "compact"
      image.image idiom: "universal", filename: "iphone.pdf", "width-class" => "compact"
      image.image idiom: "universal", filename: "iphone.pdf", "width-class" => "compact", "height-class" => "compact"
      image.image idiom: "iphone", filename: "iphone.pdf"
      image.image idiom: "iphone", filename: "iphone.pdf", "height-class" => "compact"
      image.image idiom: "iphone", filename: "iphone.pdf", "width-class" => "compact"
      image.image idiom: "iphone", filename: "iphone.pdf", "width-class" => "compact", "height-class" => "compact"
      image.pdf ipadfile, 'ipad.pdf'
      image.pdf iphonefile, 'iphone.pdf'
      image.save
    end
  end

  class XCImageSet < Dsl
    def initialize(name, &block)
      @contents = {}
      super(name, &block)
      save
    end

    def save
      return if @contents['images'].nil?
      @contents.delete :info
      @contents[:info] = {
        info: {
          version: 1,
          author: "xcode"
        }
      }
      jsonfile = File.join(@dirname, "Contents.json")
      File.open(jsonfile, "w") do |f|
        json = JSON.pretty_generate(@contents, space_before: ' ')
        f.write json
        puts jsonfile
      end
    end

    def image(image)
      @contents['images'] = [] if @contents['images'].nil?
      @contents['images'] << image
    end

    def pdf(infile, outfile)
      page = infile[/:(\d+?)$/, 1]
      infile = infile.sub /:\d+?$/, ''
      outfile = File.join(@dirname, outfile)

      inpdf = CombinePDF.load(infile, allow_optional_content: true)
      outpdf = CombinePDF.new
      outpdf << inpdf.pages[page.to_i]
      outpdf.save outfile
      puts outfile
    end
  end
end
