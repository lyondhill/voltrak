class Frame
  include Mongoid::Document

  has_many :cells
  belongs_to :plant
  
end