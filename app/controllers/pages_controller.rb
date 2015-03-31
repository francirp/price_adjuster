class PagesController < ApplicationController

  def home

    # destroy metafields
    # ShopifyAPI::Metafield.all.each {|m| m.destroy }
    # raise "hello"

    # generate metafields
    # ShopifyWrapper::MetafieldGenerator::BUNK_BED_FIELDS.each do |k, v|
    #   ShopifyWrapper::MetafieldGenerator.new(namespace: "bunk_bed_fields", key_values: { k => v }).create
    # end

    raise "hello"

    # ShopifyWrapper::MetafieldGenerator.new(namespace: "ceilings", key_values: ShopifyWrapper::MetafieldGenerator::CEILINGS, value_type: "integer").create

    # update product pricing
    # ShopifyWrapper::ImportProductPrices.new.execute
    # render text: 'Success!'
  end

end
