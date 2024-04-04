require 'sinatra'
require 'sinatra/reloader'

get '/' do
	erb :index
end

get '/items' do 
	erb :items
end

get '/new' do 
	erb :new_memo
end

get '/items/edit' do 
	erb :edit
end

# get '/erb_template_page' do
# 	erb :erb_template_page
# end

# get '/markdown_template_page' do
# 	markdown :markdown_template_page
# end

# get '/erb_and_md_template_page' do
# 	erb :erb_and_md_template_page
# end