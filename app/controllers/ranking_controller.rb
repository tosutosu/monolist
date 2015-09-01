class RankingController < ApplicationController
    def have
        @haved_ranking_items = haved_ranking()
    end
    
    def want
        @wanted_ranking_items = wanted_ranking()
    end
    
private
    def haved_ranking (size = 10)
        haved_ids = Have.group(:item_id).order('count_item_id desc').limit(size).count(:item_id).keys
        Item.find(haved_ids).sort_by{|i| haved_ids.index(i.id)}
    end
    
    def wanted_ranking (size = 10)
        wanted_ids = Want.group(:item_id).order('count_item_id desc').limit(size).count(:item_id).keys
        Item.find(wanted_ids).sort_by{|i| wanted_ids.index(i.id)}
    end
end
