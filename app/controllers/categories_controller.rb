class CategoriesController < ApplicationController
	def show
    	@category = Category.find_by_key(params[:key])
      puts '______________ CATEGORY'
      puts @category.id
      @projects = @category.projects.where(state: 'set_for_publish')
      puts '______________ PROJECTS'
      puts @projects.length
  end
end
