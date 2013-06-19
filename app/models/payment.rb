class Payment
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  include Mongoid::Timestamps

  embedded_in :plan

  field :paid_at, type: Date
  field :amount_paid, type: Float

  validates :amount_paid, presence: true
  validates_numericality_of :amount_paid, greater_than_or_equal_to: 0
  

  index({ paid_at: 1 })
  index({ amount_paid: 1 })
  
  scope :latest, asc(:paid_at)

end
