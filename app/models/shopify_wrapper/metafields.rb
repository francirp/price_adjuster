class ShopifyWrapper::Metafields < ShopifyWrapper

  # COLORS = { "Charcoal" => "Charcoal", "Black" => "Black", "Silver (Anodized)" => "Silver (Anodized)", "White" => "White", "Sandstone" => "Sandstone", "Bronze" => "Bronze" }
  # CEILINGS = { "8' Ceiling" => "8' Ceiling", "9' Ceiling (Standard)" => "9' Ceiling (Standard)", "10' Ceiling" => "10' Ceiling" }
  CEILINGS = { "ceiling_height" => '{"type":"select","options":[{"value":"8\' Ceiling","key":"8\' Ceiling","price":0},{"value":"9\' Ceiling (Standard)","key":"9\' Ceiling (Standard)","price":0},{"value":"10\' Ceiling","key":"10\' Ceiling (Standard)","price":0}]}' }
  COLORS = { "color" => '{"type":"select","options":[{"value":"Charcoal","key":"Charcoal","price":0},{"value":"Black","key":"Black","price":0},{"value":"Silver (Anodized)","key":"Silver (Anodized)","price":0},{"value":"White","key":"White","price":0},{"value":"Sandstone","key":"Sandstone","price":0},{"value":"Bronze","key":"Bronze","price":0}]}' }
  GUARD_RAILS = { "guard_rail" => '{"type":"select","options":[{"value":"1 Side Rail (Standard)","key":"1 Side Rail (Standard)","price":0},{"value":"2 Side Rails","key":"2 Side Rails","price":175},{"value":"1 Side Rail and 1 End Rail","key":"1 Side Rail and 1 End Rail","price":160},{"value":"2 Side Rails and 1 End Rail","key":"2 Side Rails and 1 End Rail","price":335},{"value":"1 Side Rail and 2 End Rails","key":"1 Side Rail and 2 End Rails","price":320},{"value":"2 Side Rails and 2 End Rails","key":"2 Side Rails and 2 End Rails","price":670}]}' }
  ACCESSORIES = { "accessories" => '{"type":"select_many","options":[{"value":"Bookshelf","key":"Bookshelf","price":660.00},{"value":"Tray","key":"Tray","price":115.00},{"value":"Trundle","key":"Trundle","price":565.00}]}' }

  BUNK_BED_FIELDS = {
    "bed_size" => '{"type":"select","options":[{"value":"King","key":"King","price":300.00},{"value":"Queen","key":"Queen","price":100.00},{"value":"Full","key":"Full","price":50.0},{"value":"Twin","key":"Twin","price":0.0},{"value":"Twin Over Queen","key":"Twin Over Queen","price":200.0},{"value":"Full Over Queen","key":"Full Over Queen","price":250.0}]}'
  }.merge(ACCESSORIES).merge(CEILINGS).merge(COLORS).merge(GUARD_RAILS)

  LOFT_BED_FIELDS = {
    "bed_size" => '{"type":"select","options":[{"value":"King","key":"King","price":300.00},{"value":"Queen","key":"Queen","price":100.00},{"value":"Full","key":"Full","price":50.0},{"value":"Twin","key":"Twin","price":0.0}]}',
    "accessories" => '{"type":"select_many","options":[{"value":"Bookshelf","key":"Bookshelf","price":660.00},{"value":"Tray","key":"Tray","price":115.00}]}'
  }.merge(CEILINGS).merge(COLORS).merge(GUARD_RAILS)

  STANDARD_BED_FIELDS = {
    "bed_size" => '{"type":"select","options":[{"value":"King","key":"King","price":300.00},{"value":"Queen","key":"Queen","price":100.00},{"value":"Full","key":"Full","price":50.0},{"value":"Twin","key":"Twin","price":0.0}]}'
  }.merge(COLORS).merge(ACCESSORIES)

  def initialize(args = {})
    super
  end

  def recreate_all
    destroy_all
    create_all
  end

  def destroy_all
    ShopifyAPI::Metafield.all.each { |m| m.destroy }
  end

  def create_all
    %w(bunk_bed loft_bed standard_bed).each do |bed|
      name = "#{bed}_fields"
      product = ShopifyAPI::Product.where(handle: bed.dasherize).first
      ShopifyWrapper::MetafieldGenerator.new(product: product, namespace: name, key_values: self.class.const_get(name.upcase)).create
    end
  end

end