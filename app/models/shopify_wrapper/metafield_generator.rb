class ShopifyWrapper::MetafieldGenerator < ShopifyWrapper

  attr_reader :key_values, :namespace, :value_type

  def initialize(args = {})
    super
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
      metafield.save
    end

end