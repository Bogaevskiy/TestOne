class PostsController < ApplicationController

	def index
		@post = Post.all.order('created_at DESC').paginate(:page => params[:page], :per_page => 50)
	end

	def new
		@post = Post.new
		@user = User.new		
	end

	def show
		@post = Post.find(params[:id])		
		if @post.grade == nil
			@average_grade = 'не определена'
			@grade = Grade.new
		else
			@average_grade = @post.grade.average
		end
	end

	def create
		if User.find_by(name: params[:post]["user"]["name"]) == nil		
			@user = User.new
			@user.name = params[:post]["user"]["name"]
			@user.save
		else
			@user = User.find_by(name: params[:post]["user"]["name"])
		end
		@post = @user.posts.build(post_params)
		@post.name = params[:post]["name"]
		@post.content = params[:post]["content"]
		@post.address = request.remote_ip
		@post.save		
		if (@post.save)
			redirect_to @post
		else
			render 'new', notice: "Произошла ошибка сохранения"
		end
	end
	
	def grade
		@post = Post.find(params[:id])
		if @post.grade == nil
			@grade = @post.build_grade
			@grade.save
		end
		@post.grade.value.push(params['grade']['value'].to_i)
		@post.grade.save
		@post.grade.average = @post.grade.inject(0){|sum, elem| sum = sum + elem}.to_f / @post.grade.size
		@post.grade.average.save
		redirect_to @post		
	end

	def idgrade_value		
		begin
			@post = Post.find(params[:post]['name'].to_i)			
			if @post.grade == nil
				@grade = @post.build_grade
				@grade.save
			end	
			@post.grade.value.push(params[:post]['value'].to_i)
			@post.grade.save
			if @post.grade.save
				redirect_to idgrade_path
			else
			redirect_to idgrade_path, notice: "Произошла ошибка"
			end
		rescue ActiveRecord::RecordNotFound
			redirect_to idgrade_path, notice: "Произошла ошибка"
		end			
	end	

	def top
		@post = Post.joins(:grade).merge(Grade.order('average DESC')).limit(50)
		@top = {}
		@post.each do |post|
			@top.merge!({post.name => post.content})			
		end
		@top.to_json
	end

	def groups
		#@group = Post.select("id, count(id) as quantity").group(:address).having("count(id) > 1")
		@group = Post.select("COUNT(address) as total, address").group(:address).having("COUNT(address)>1")
		@group = {}
		@group.each do |group|
			@post = Post.where(address: group.address)
			names = []
			if @post.select('DISTINCT user.name').count > 1
				@post.each do |post|
					names.push(post.name)
				end
			end
			@group.merge!({group.address => names})
		end
		@group.to_json
	end 

	private
		def post_params
			params.require(:post).permit(:name, :content, user_attributes: [:name])
		end
end
