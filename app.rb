require 'sinatra'
require 'sinatra/activerecord'
require './config/environment'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'

enable :sessions

class Post < ActiveRecord::Base
 validates :title, presence: true
 validates :body, presence: true
end

  get "/" do
    @posts = Post.order("created_at DESC")
    @title = "Welcome!"
    erb :"posts/index"
  end

  helpers do
    def title
      if @title
        "#{@title}"
      else
        "Welcome!"
      end
    end
  end

  get "/posts/create" do
   @title = "Create post"
   @post = Post.new
   erb :"posts/create"
  end

  post "/posts" do
    @post = Post.new(params[:post])
    if @post.save
        redirect "posts/#{@post.id}", :notice => 'Success! Love the new post.'
    else
        redirect "posts/create", :error => 'Something went wrong. Try again!)'
    end
  end

  get "/posts/:id" do
   @post = Post.find(params[:id])
   @title = @post.title
   erb :"posts/view"
  end

  # edit post
  get "/posts/:id/edit" do
    @post = Post.find(params[:id])
    @title = "Edit Form"
    erb :"posts/edit"
  end

  put "/posts/:id" do
    @post = Post.find(params[:id])
    @post.update(params[:post])
    redirect "/posts/#{@post.id}"
  end

  helpers do
  include Rack::Utils
  alias_method :h, :escape_html
  end
