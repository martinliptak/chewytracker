module Users
  module Settings
    extend ActiveSupport::Concern
  
    included do
      serialize :settings, Hash
    end

    def expected_calories
      settings[:expected_calories] || 2000
    end

    def expected_calories=(v)
      settings[:expected_calories] = v.to_i
    end
  end
end
