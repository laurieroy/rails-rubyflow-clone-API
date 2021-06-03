class ArticlesController < ApplicationController
	include Paginable
	skip_before_action :authorize!, only: [:index, :show]

	def index
		paginated = paginate(Article.recent)
		render_collection(paginated)
	end

	def show
		article = Article.find(params[:id])
		render json: serializer.new(article)
	end

	# def create
	# 	article = Article.new(article_params)
	# 	if article.valid?
	# 		#handle next lesson
	# 	else
	# 		render json: article, adapter: :json_api, serializer: serializer, status: :unporocessable_entity
	# 	end

	# end

	def serializer
		ArticleSerializer
	end

	private
	def article_params
		ActionController::Parameters.new
	end
end