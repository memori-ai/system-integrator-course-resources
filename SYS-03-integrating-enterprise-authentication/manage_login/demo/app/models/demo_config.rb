class DemoConfig
  include Mongoid::Document
  include Mongoid::Timestamps

  field :demo_name, type: String
  field :settings, type: Hash, default: {}

  index({ demo_name: 1 }, { unique: true })

  validates :demo_name, presence: true, uniqueness: true

  def self.for(demo_name)
    where(demo_name: demo_name).first_or_create!(demo_name: demo_name)
  end

  def get(key)
    settings[key.to_s]
  end

  def set(key, value)
    settings[key.to_s] = value
  end

  def merge_settings!(new_settings)
    new_settings.each { |k, v| settings[k.to_s] = v if v.present? }
    save!
  end
end
