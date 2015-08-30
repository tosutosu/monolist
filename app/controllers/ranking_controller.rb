class RankingController < ApplicationController
    def have
        binding.pry
        @desc_have_items
        have_item_ids = Have.group(:item_id).order('count_item_id desc').limit(10).count(:item_id).keys
        have_item_ids.each do |id|
            @desc_have_items = @desc_have_items + Item.find_by_id(id)
        end
    end
    
    def want
        
    end
end
