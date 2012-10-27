class Frame
  include Mongoid::Document

  field :temperature, type: Integer

  has_many :cells
  belongs_to :plant
  
end