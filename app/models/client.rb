class Client
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  embeds_many :plans

  field :name, type: String
  field :phone, type: String
  field :email, type: String
  field :notes, type: String
  field :deleted, type: Boolean, default: false

  attr_protected :user_id
  
  after_destroy :remove_from_groups

  validates :name, :user_id, presence: true

  index({ user_id: 1 })
  index({ user_id: 1, name: 1 })
  index({ user_id: 1, deleted: 1 })

  scope :active, where(deleted: false)

  def paid_this_month?
    self.plans.where('payments.paid_at' => 
                     {'$gte' => Date.today.at_beginning_of_month,
                      '$lte' => Date.today.at_beginning_of_month.next_month}).exists?
  end
  def remove_from_groups
    self.user.groups.where(:entries.in => [self.id]).each do |group|
      group.entries.delete(self.id)
      group.save
    end
  end
  def sum_remaining_amount
    self.plans.sum(:remaining_amount)
  end
  def paid_sum
    self.plans.sum(:paid_sum)
  end
  def sum_profit
    self.plans.sum(:profit)
  end
end