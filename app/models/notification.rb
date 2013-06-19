class Notification
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email, type: String

  # validates_presence_of :email
  validates_uniqueness_of :email
  validates :email, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/ }

  index({ email: 1 })
end
