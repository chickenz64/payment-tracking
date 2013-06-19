class User
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :clients, dependent: :destroy
  embeds_many :groups

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""
  field :name, type: String
  # field :groups, type: Hash, default: {}
  # field :groups, type: Array, default: []

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String

  validates_presence_of :name

  index({ email: 1 })


  def get_clients(ids=[])
    if ids.blank?
      self.clients.active.desc(:created_at)
    else  
      self.clients.where(:id.in => ids)
    end
  end
  def get_clients_no_remaining
    tmp = self.get_clients.to_a
    tmp.delete_if{|c| c.sum_remaining_amount == 0 }
    tmp
  end
  def get_groups
    self.groups.where(:created_at.ne=>nil).desc(:created_at)
  end
  def client(id)
    self.get_clients.where(id:id).first rescue nil
  end
  def group(id)
    self.get_groups.where(id:id).first rescue nil
  end
  def save_group(name)
    if self.groups.include?(name.to_s) || name.blank?
      false
    else
      self.groups << name.to_s
      self.save
    end  
  end
  def search_clients(name)
    # name = name.nil? ? "" : name
    self.get_clients.where(name:Regexp.new(name.to_s, true))
  end
end