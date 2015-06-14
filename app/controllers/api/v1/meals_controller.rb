module Api
  module V1
    class MealsController < BaseController
      before_action :authenticate!
      load_and_authorize_resource except: :index
      
      # Only these fields are exposed
      EXPOSED_FIELDS = [:id, :name, :calories, :eaten_at]

      ##
      #
      # GET /api/v1/meals/
      #
      # params:
      #   user_id - must be set to the current user unless she is admin
      #   date_from
      #   date_to
      #   time_from
      #   time_to
      #   token - current user authorization
      #
      # returns:
      #   200 - success
      #   401 - unauthorized
      #   403 - forbidden
      #    
      # = Examples
      #
      #   resp = conn.get "/api/v1/meals", user_id: access_token.user_id, token: "25be778dc2ed161b63eb07684d45a561"
      #   resp.status
      #   => 200
      #   resp.body
      #   => [{"id"=>1,"name"=>"Double Cheese Burger","calories"=>1000000,"eaten_at"=>"2015-06-28T13:23:33.525Z"}, ...]
      #
      def index
        if params[:user_id].present? && params[:user_id] == current_user.id
          authorize! :index_owned, Meal
        else
          authorize! :index, Meal
        end

        meals = Meal

        meals = meals.where("user_id = ?", params[:user_id]) if params[:user_id].present?

        meals = meals.where("eaten_at::date >= ?", params[:date_from]) if params[:date_from].present?
        meals = meals.where("eaten_at::date <= ?", params[:date_to]) if params[:date_to].present?
        meals = meals.where("eaten_at::time >= ?", params[:time_from]) if params[:time_from].present?
        meals = meals.where("eaten_at::time <= ?", params[:time_to]) if params[:time_to].present?

        render json: meals.order("id DESC").to_json(only: EXPOSED_FIELDS)
      end

      ##
      #
      # GET /api/v1/meals/:id
      #
      # params:
      #   token - current user authorization
      #
      # returns:
      #   200 - success
      #   401 - unauthorized
      #   403 - forbidden
      #   404 - not found
      #    
      # = Examples
      #
      #   resp = conn.get "/api/v1/meals/20", token: "25be778dc2ed161b63eb07684d45a561"
      #   resp.status
      #   => 200
      #   resp.body
      #   => {"name"=>"Double Cheese Burger","calories"=>1000000,"eaten_at"=>"2015-06-28T13:23:33.525Z"}
      #
      def show
        render json: @meal.to_json(only: EXPOSED_FIELDS)
      end

      ##
      #
      # POST /api/v1/meals
      # 
      # params:
      #   meal (Hash)
      #   token - current user authorization
      #
      # returns:
      #   201 - success
      #   401 - unauthorized
      #   422 - wrong parameters
      #    
      # = Examples
      #
      #   resp = conn.post "/api/v1/meals", meal: { name: "Double Cheese Burger", calories: "1000000", eaten_at: "2015-06-28T13:23:33.525Z"}, token: "25be778dc2ed161b63eb07684d45a561"
      #   resp.status
      #   => 201
      #   resp.body
      #   => {"name"=>"Double Cheese Burger","calories"=>1000000,"eaten_at"=>"2015-06-28T13:23:33.525Z"}
      #
      def create
        @meal.user = current_user
        @meal.save!

        render json: @meal.to_json(only: EXPOSED_FIELDS), status: :created
      end

      ##
      #
      # PUT /api/v1/meals/:id
      # 
      # params:
      #   meal (Hash)
      #   token - current user authorization
      #
      # returns:
      #   204 - success
      #   401 - unauthorized
      #   403 - forbidden
      #   422 - wrong parameters
      #
      def update
        @meal.update_attributes!(meal_params)

        render nothing: true, status: :no_content
      end
      
      ##
      #
      # DELETE /api/v1/meals/:id
      # 
      # params:
      #   token - current user authorization
      #
      # returns:
      #   204 - success
      #   401 - unauthorized
      #   403 - forbidden
      #
      def destroy
        @meal.destroy!

        render nothing: true, status: :no_content
      end

      private

        def meal_params
          params.require(:meal).permit(:name, :calories, :eaten_at)
        end
    end
  end
end