class ItemsController < ApplicationController
    load_and_authorize_resource
    skip_authorize_resource :only => :index
    
    def index
        @item = Item.order(name: :asc)
    end

    def new
        @item = Item.new
    end

    def create
        @item = Item.new(item_params)
         
        if @item.save
            redirect_to :action => 'index'
        else
            render :action => 'new'
        end
        
    end

    def show
        @item = Item.find(params[:id])
    end
    
    def edit
        @item = Item.find(params[:id])
    end

    private

    def item_params
        params.require(:item).permit(:name, :description, :quantity)
    end
end
