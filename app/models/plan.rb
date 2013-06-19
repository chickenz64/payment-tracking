class Plan
  include Mongoid::Document
  include Mongoid::Timestamps
  
  embedded_in :client
  embeds_one :product
  embeds_many :payments

  accepts_nested_attributes_for :product
  
  field :profit, type: Float, default: 0.0
  field :closed, type: Boolean, default: false
  field :paid_sum, type: Float, default: 0.0
  field :notes, type: String

  attr_protected :closed, :paid_sum, :profit

  before_save :calculate_profit, :calculate_paid_sum, :calculate_closed # order is important
  
  index({ profit: 1 })
  index({ closed: 1 })
  index({ paid_sum: 1 })

  def payment(id)
    self.payments.where(id:id).first rescue nil
  end
  def get_payments
    self.payments.latest
  end
  def is_closed
    self.closed ? I18n.t('y') : I18n.t('n')
  end
  def calculate_profit
    self.profit = self.product.selling_price.to_f - self.product.original_price.to_f
    true
  end
  def remaining_amount
    self.product.selling_price.to_f - self.paid_sum.to_f
  end
  def calculate_closed
    self.closed = ( self.paid_sum >= self.product.selling_price )
    true
  end
  def calculate_paid_sum
    self.paid_sum = self.payments.sum(:amount_paid)
    true
  end
end
