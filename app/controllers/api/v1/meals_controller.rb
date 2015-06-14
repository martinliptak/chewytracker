module Api
  module V1
    class MealsController < BaseController
      respond_to :json
      
      def index
        @meals = Meal.all
      end
      
      def show
        respond_with Meal.find(params[:id])
      end
      
      def create
        respond_with Meal.create(params[:meal])
      end
      
      def update
        respond_with Meal.update(params[:id], params[:meals])
      end
      
      def destroy
        respond_with Meal.destroy(params[:id])
      end
    end
  end
end