class NewsController < ApplicationController

  # CREATE
  get '/news/new' do
    if logged_in?
      erb :'/news/create_news'
    else
      redirect to '/news'
    end
  end

  post '/news/new' do
    if logged_in?
      if News.find_by(date: params[:date], content: params[:content])
        flash[:message] = "News item already exists."
        redirect to "/news/new"
      else
        @news = News.create(date: params[:date], content: params[:content], url: params[:url], image_url: params[:image_url])
        flash[:message] = "Successfully created news item!"
        redirect to "/news"
      end
    else
      redirect to '/artists'
    end
  end

  # READ
  get '/news' do
    @news = News.where("date <= ?", Date.today).order(:date).reverse
    erb :'/news/news_index'
  end

  get '/news/pending' do
    if logged_in?
      @news = News.where("date > ?", Date.today).order(:date)
      erb :'/news/news_index'
    else
      redirect to '/news'
    end
  end

  # UPDATE
  get '/news/:id/edit' do
    if logged_in?
      @news = News.find_by(id: params[:id])
      erb :'/news/edit_news'
    else
      redirect to '/news'
    end
  end

  patch '/news/:id' do
    if logged_in?
      @news = News.find_by(id: params[:id])
      @news.date = params[:date] if params[:date] != @news.date
      @news.content = params[:content] if params[:content] != @news.content
      @news.url = params[:url] if params[:url] != @news.url
      @news.image_url = params[:image_url] if params[:image_url] != @news.image_url
      @news.save
      flash[:message] = "Successfully updated news item!"
      redirect to "/news"
    else
      flash[:message] = "Could not update news item."
      redirect to '/news/:id/edit'
    end
  end

  # DELETE
  delete '/news/:id/delete' do
    @user = current_user
    @news = News.find_by(id: params[:id])
    if logged_in? && @user.authenticate(params[:password])
      @news.destroy
      flash[:message] = "BALEETED!"
      redirect to '/news'
    else
      flash[:message] = "Incorrect password. Could not delete news item."
      redirect to "/news/#{@news.id}/edit"
    end
  end

end
