class Plant
  include Mongoid::Document

  field :name
  field :temperature, type: Integer

  has_many :frames



end
