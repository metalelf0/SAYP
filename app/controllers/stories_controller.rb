class StoriesController < ApplicationController
 
 def index
    @updated_element = Kernel.const_get(params[:updated_element_type]).find(params[:updated_element])
 end

 def parse
   updated_element = Parser.parse params[:phrase]
   if updated_element
     flash[:notice] = "#{updated_element[0]} aggiornato/a!"
     redirect_to :action => :index,
       :updated_element => updated_element[0], 
       :updated_element_type => updated_element[1]
   else
     flash[:error] = "Devi inserire una frase valida" 
     redirect_to :action => :index
   end
   
  end
 
end
