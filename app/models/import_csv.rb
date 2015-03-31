class ImportCSV

  module Editable
    # should be ordered according to order of CSV
    HEADERS = [:handle, :variant_1, :variant_2, :variant_3, :price]
    FILE = "/Users/ryanfrancis/Documents/francis\ lofts/price_adjuster/public/import_11_17_2014.csv"
  end

  attr_accessor :file_name

  def initialize
  end

  def file
    # "#{Rails.root}/public/#{file_name}"
    Editable::FILE
  end

  def rows
    rows = []
    CSV.foreach(file, headers: true) do |csv_row|
      values = csv_row.to_hash.values.compact
      row = Row.new(*values)
      raise "One of the Excel variant names does not match any in Shopify".inspect if (row.variants & ShopifyWrapper::PRICE_CHANGE_HASH.keys).count != row.variants.count
      rows << row
    end
    rows
  end

  class Row < Struct.new(*Editable::HEADERS)

    def variants
      [variant_1, variant_2, variant_3].compact.delete_if {|val| [0, "0", ""].include?(val)}
    end

  end

end
