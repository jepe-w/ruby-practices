require 'sinatra'
require 'sinatra/reloader'
require 'json'

FILE_PATH = 'public/memos.json'

def get_memos(file_path)
  File.open(file_path) { |item| JSON.parse(item.read) }
end

def set_memos(file_path, memos)
  File.open(file_path, 'w') { |item| JSON.dump(memos, item) }
end

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
	@title = memos[params[:id]]['title']
	@content = memos[params[:id]]['content']
	erb :memo
end

post '/memos' do
	title = params[:title]
	content = params[:content]

	memos = get_memos(FILE_PATH)
	id = (memos.keys.map(&:to_i).max + 1).to_s
	memos[id] = { 'title' => title, 'content' => content}
	set_memos(FILE_PATH, memos)

	redirect '/memos'
end

get '/memos/:id/edit' do
	memos = get_memos(FILE_PATH)
	@title = memos[params[:id]]['title']
	@content = memos[params[:id]]['content']
	erb :edit
end

patch '/memos/:id' do
  title = params[:title]
  content = params[:content]

  memos = get_memos(FILE_PATH)
  memos[params[:id]] = { 'title' => title, 'content' => content }
  set_memos(FILE_PATH, memos)

  redirect "/memos/#{params[:id]}"
end

# patch '/memo/1' do
#   "Hello World"
# end
