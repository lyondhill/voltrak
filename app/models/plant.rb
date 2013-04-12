class Plant
  include Mongoid::Document

  field :name
  field :temperature, type: Integer

  has_many :frames

  ## methods ##
  class << self
    def find_by_slug(slug)
      find(slug)
    rescue
      where(name: slug).first
    end

    def find_by_slug!(slug)
      find_by_slug(slug) || raise(Mongoid::Errors::DocumentNotFound.new(self, { slug: slug }))
    end
  end

end
