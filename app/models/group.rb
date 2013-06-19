class Group
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :user

  field :name, type: String
  field :entries, type: Array, default: []

  validates :name, presence: true

  index({ name: 1 })
  index({ entries: 1 })

  def count
    self.entries.count
  end
  def add_client(id)
    self.entries << id if !self.user.client(id).nil? && !self.entries.include?(id) 
  end
  def remove_client(id)
    self.entries.delete(id) unless self.user.client(id).nil?
  end
  def clients
    if self.entries.blank?
      []
    else 
      self.user.get_clients(self.entries)
    end
  end
  def has_client?(id)
    self.entries.include?(id)
  end
  def highest_paid_clients
    arr_clients, others_sum = [], 0

    ordered_clients = self.clients.delete_if{|c| c.paid_sum == 0}.sort_by{|c| c.paid_sum}.reverse!
    n = ordered_clients.length-1 > 5 ? 5 : ordered_clients.length-1
    
    ordered_clients.each_with_index do |c, i|
      if i < n
        arr_clients << {name: c.name, paid_sum: c.paid_sum}
      else
        others_sum += c.paid_sum
      end
    end
    arr_clients << {name: "others", paid_sum: others_sum}
  end
  def highest_profit_clients
    arr_clients, others_sum = [], 0

    ordered_clients = self.clients.delete_if{|c| c.sum_profit == 0}.sort_by{|c| c.sum_profit}.reverse!
    n = ordered_clients.length-1 > 4 ? 4 : ordered_clients.length-1
    
    ordered_clients.each_with_index do |c, i|
      if i < n
        arr_clients << {name: c.name, sum_profit: c.sum_profit}
      else
        others_sum += c.sum_profit
      end
    end
    arr_clients << {name: "others", sum_profit: others_sum}
  end
  def highest_remaining_clients
    arr_clients, others_sum = [], 0

    ordered_clients = self.clients.delete_if{|c| c.sum_remaining_amount == 0}.sort_by{|c| c.sum_remaining_amount}.reverse!
    n = ordered_clients.length-1 > 4 ? 4 : ordered_clients.length-1
    
    ordered_clients.each_with_index do |c, i|
      if i < n
        arr_clients << {name: c.name, sum_remaining_amount: c.sum_remaining_amount}
      else
        others_sum += c.sum_remaining_amount
      end
    end
    arr_clients << {name: "others", sum_remaining_amount: others_sum}
  end
end
