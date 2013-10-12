module Ransack
  module Helpers
    module FormHelper
      def order_indicator_for(order)
        if order == 'asc'
          '<span class="glyphicon glyphicon-chevron-up"></span>'
        elsif order == 'desc'
          '<span class="glyphicon glyphicon-chevron-down"></span>'
        else
          nil
        end
      end
    end
  end
end
