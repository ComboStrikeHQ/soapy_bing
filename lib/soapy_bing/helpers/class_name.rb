module SoapyBing
  module Helpers
    module ClassName
      def class_name
        @class_name ||= self.class.name.demodulize
      end
    end
  end
end
