class ApplicationController < Sinatra::Base

    set :default_content_type, 'application/json'

    get '/games' do
        games = Game.all.order(:title).limit(10)
        games.to_json
    end

    get '/games/:id' do
        game = Game.find(params[:id])

        game.to_json(only: [:id, :title, :genre, :price], 
            include: {
                reviews: { only: [:comment, :score], 
                    include: {
                        user: { only: [:name] }
                    } 
                }
            }
        )
    end

    get '/users' do
        users = User.all.order(:name).limit(10)
        users.to_json
    end    

    get '/users/:id' do
        user = User.find(params[:id])
        user.to_json
    end    

    post '/reviews' do
        review = Review.create(
            score: params[:score],
            comment: params[:comment],
            game_id: params[:game_id],
            user_id: params[:user_id]
        )

        review.to_json
    end

    get '/reviews' do
        reviews = Review.all.order(:comment).limit(10)
        reviews.to_json
    end    
    
    get '/reviews/:id' do
        review = Review.find(params[:id])
        review.to_json
    end

    patch '/reviews/:id' do
        # find the review using the ID
        review = Review.find(params[:id])

        review.update(
            score: params[:score],
            comment: params[:comment]
        )

        review.to_json
    end    

    delete '/reviews/:id' do
        # delete the review
        review.destroy

        # send a response with the deleted review as JSON
        review.to_json
    end

end
