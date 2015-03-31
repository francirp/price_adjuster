class ShopifyWrapper::MetafieldGenerator < ShopifyWrapper

  attr_reader :product, :key_values, :namespace, :value_type

  def initialize(args = {})
    super
    @product = args[:product]
    @namespace = args[:namespace]
    @key_values = args[:key_values]
    @value_type = args.fetch(:value_type, "string")
  end

  def create
    key_values.each do |k, v|
      create!(k, v)
    end
  end

  private

    def create!(key, value)
      metafield = ShopifyAPI::Metafield.new
      metafield.attributes = { namespace: namespace, key: key, value: value, value_type: value_type }
      if product
        product.add_metafield(metafield)
      else
        metafield.save
      end
    end

end