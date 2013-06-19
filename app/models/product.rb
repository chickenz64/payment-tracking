class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::MultiParameterAttributes

  embedded_in :plan

  field :name, type: String
  field :original_price, type: Float
  field :selling_price, type: Float
  field :delivery_date, type: Date
  field :discount, type: Float, default: 0.0

  validates :name, :original_price, :selling_price, presence: true
  validates_numericality_of :selling_price, greater_than_or_equal_to: 0
  validates_numericality_of :original_price, greater_than_or_equal_to: 0
  
  index({ name: 1 })
  index({ original_price: 1 })
  index({ selling_price: 1 })
end
