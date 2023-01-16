class ArticlesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :public_articles, only: [:index, :show]
  before_action :users_with_articles, only: [:index]

  def index
    @current_user_articles = current_user&.articles.order_by_date params[:sort]
    @public_articles = @public_articles
  end

  def show
    @article = @public_articles.find(params[:id])
  end

  def new
    @article = current_user.articles.build
  end

  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      redirect_to @article
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @article = current_user.articles.find(params[:id])
  end

  def update
    @article = current_user.articles.find(params[:id])

    if @article.update(article_params)
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article = current_user.articles.find(params[:id])
    @article.destroy

    redirect_to articles_path, status: :see_other
  end

  private
  def article_params
    params.require(:article).permit(:title, :body, :status)
  end

  def public_articles
    @public_articles = Article.public_posts&.order_by_date params[:sort]
  end

  def users_with_articles
    @users_with_articles = User.all.users_with_articles
  end
end
