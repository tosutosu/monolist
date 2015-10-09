class OwnershipsController < ApplicationController
  before_action :logged_in_user

  def create
    binding.pry
    
    if params[:asin]
      @item = Item.find_or_initialize_by(asin: params[:asin])
    else
      @item = Item.find(params[:item_id])
    end
    binding.pry
    # itemsテーブルに存在しない場合はAmazonのデータを登録する。
    if @item.new_record?
      begin
      binding.pry
        # TODO 商品情報の取得 Amazon::Ecs.item_lookupを用いてください
        response = Amazon::Ecs.item_search(params[:q] , 
                                  :response_group => 'Medium' , 
                                  :country => 'jp')
      binding.pry
      rescue Amazon::RequestError => e
        return render :js => "alert('#{e.message}')"
      end
      binding.pry
      amazon_item       = response.items.first
      @item.title        = amazon_item.get('ItemAttributes/Title')
      @item.small_image  = amazon_item.get("SmallImage/URL")
      @item.medium_image = amazon_item.get("MediumImage/URL")
      @item.large_image  = amazon_item.get("LargeImage/URL")
      @item.detail_page_url = amazon_item.get("DetailPageURL")
      @item.raw_info        = amazon_item.get_hash
      @item.save!
    end
    binding.pry
    # TODO ユーザにwant or haveを設定する
    # params[:type]の値ににHaveボタンが押された時にはの時は「Have」,
    # Wantボタンがされた時には「Want」が設定されています。
    if params[:type] == "Have" && current_user.have?(@item) == false
      current_user.have(@item)
    elsif params[:type] == "Want" && current_user.want?(@item) == false
      current_user.want(@item)
    end
    binding.pry
  end

  def destroy
    @item = Item.find(params[:item_id])

    # TODO 紐付けの解除。 
    # params[:type]の値ににHavedボタンが押された時にはの時は「Have」,
    # Wantedボタンがされた時には「Want」が設定されています。
    if params[:type] = 'Haved'
       current_user.unhave(@item)
    elsif params[:type] = 'Wanted'
       current_user.unwant(@item)
    end
  end
end
