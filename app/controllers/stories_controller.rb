class StoriesController < ApplicationController
 
 def index
   @updated_element = nil
   @updated_element = Kernel.const_get(params[:updated_element_type]).find(params[:updated_element]) if params[:updated_element_type]
 end

 def parse
   updated_element = Parser.parse params[:phrase]
   if updated_element
     flash[:notice] = "#{updated_element} aggiornato/a!"
     redirect_to :action => :index,
       :updated_element => updated_element, 
       :updated_element_type => updated_element.class.name 
   else
     flash[:error] = "Devi inserire una frase valida"
     redirect_to :action => :index
   end
   
  end

  def show
    @story = Story.find(params[:id])
  end

end
