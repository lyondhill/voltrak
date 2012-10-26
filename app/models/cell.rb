class Cell
  include Mongoid::Document
  
  STATUSES = [:errored, :active, :inactive]

  field :status, type: Symbol

  validates_inclusion_of :status, in: STATUSES

  has_many :reports
  belongs_to :frame
  
end