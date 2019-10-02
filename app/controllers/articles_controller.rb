class ArticlesController < ApplicationController
  def index
    articles = Article.all
    json_response(articles)
  end

  def show
    article = Article.find(params[:id])
    json_response(article)
  end

  def create
    article = Article.create!(article_params)
    json_response(article, :created)
  end

  def update
    article = Article.find(params[:id])
    article.update(article_params)
    head :no_content
  end

  def destroy
    Article.find(params[:id]).destroy
    head :no_content
  end

  private

  def article_params
    params.permit(:title, :content)
  end
end
