class ItemsController < ApplicationController
    load_and_authorize_resource
    
    def index
        @item = item.order(name: :asc)
    end

    def new
        @item = item.new
        @name = name.all
        @description = description.all
        @quantity = quantity.all
    end

    def create
        @item = item.new(item_params)
         
        if @item.save
            redirect_to :action => 'list'
        else
            @name = name.all
            @description = description.all
            @quantity = quantity.all
            render :action => 'new'
        end
        
     end
     
     def item_params
        params.require(:item).permit(:name, :description, :quantity)
     end

    def list
        @item = item.all
    end

    def show
        @item =  item.find(params[:id])
    end
    
    def edit
        @item = item.find(params[:id])
        @name = name.all
        @description = description.all
        @quantity = quantity.all
    end
end
