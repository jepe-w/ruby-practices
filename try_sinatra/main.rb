require 'sinatra'
require 'sinatra/reloader'

# def set_memos(file_path, memos)
#   File.open(file_path, 'w') { |f| JSON.dump(memos, f) }
# end

get '/' do
	redirect '/memos'
end

get '/memos' do
	@memos = get_memos(FILE_PATH)
	erb :index
end

get '/memos/new' do
	erb :new_memo
end

get '/memos/:id' do
	memos = get_memos(FILE_PATH)
	@title = memos[parms[:id]]['title']
	@content = memos[parms[:id]]['content']
	erb :memo
end

get '/memos/memo/edit' do
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