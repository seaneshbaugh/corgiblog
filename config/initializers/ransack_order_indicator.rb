module Ransack
  module Helpers
    module FormHelper
      def order_indicator_for(order)
        if order == 'asc'
          '<i class="icon-arrow-up"></i>'
        elsif order == 'desc'
          '<i class="icon-arrow-down"></i>'
        else
          nil
        end
      end
    end
  end
end
