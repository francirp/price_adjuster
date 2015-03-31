require 'open-uri'

class ShopifyWrapper

  PRICE_CHANGE_HASH =
    { "Standard (1 Side Rail)" => 0.0,
      "No Accessories" => 0.0,
      "No Trundle" => 0.0,
      "2 Side Rails" => 20.0,
      "1 Side Rail and 1 End Rail" => 15.0,
      "2 Side Rails and 1 End Rail" => 25.0,
      "1 Side Rail and 2 End Rails" => 15.0,
      "2 Side Rails and 2 End Rails" => 30.0,
      "Tray" => 0.0,
      "Trundle" => 0.0,
      "Bookshelf" => 15.0,
      "Standard (1 side rail)" => 0.0,
      "Modern Full Bed" => 0.0,
      "Modern King Bed" => 0.0,
      "Modern Queen Bed" => 0.0,
      "Modern Twin Bed" => 0.0 }

  attr_accessor :shop

  def initialize(args = {})
    app_key = ENV['SHOPIFY_API_KEY'] || '68a07168b4450103ad72b5b4fa33e5e6'
    app_password = ENV['SHOPIFY_API_PASSWORD'] || 'f3bbd7fb642c032c537d093b2149fd43'
    app_name = ENV['SHOPIFY_APP_NAME'] || 'modern-loft-beds.myshopify.com'
    url = "https://#{app_key}:#{app_password}@#{app_name}/admin"
    ShopifyAPI::Base.site = url
    set_child_variables
  end

  def set_child_variables
    # implemented by child classes
  end

  class ImportProductPrices < ShopifyWrapper

    attr_accessor :rows

    def initialize
      super
      @rows = ImportCSV.new.rows
    end

    def rows_by_handle
      rows.group_by(&:handle)
    end

    def handles
      rows_by_handle.keys
    end

    def execute
      handles.each do |handle|
        product = ShopifyAPI::Product.where(handle: handle).first
        product_rows = rows.find_all { |r| r.handle == handle }
        product.variants.each do |v|
          v.option1 = "Standard (1 Side Rail)" if v.option1 == "Standard (1 side rail)"
          row = product_rows.detect{ |r| (r.variants & [v.option1, v.option2, v.option3].compact).count == r.variants.count }
          raise "Row cannot find matching variants on Shopify".inspect if row.nil?
          v.price = row.price
        end
        product.save
      end
    end

  end
end
