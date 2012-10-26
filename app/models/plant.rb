class Plant
  include Mongoid::Document

  field :name

  has_many :frames

  
end
