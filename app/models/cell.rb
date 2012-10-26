class Cell
  include Mongoid::Document
  
  has_many :reports
  belongs_to :frame
  
end