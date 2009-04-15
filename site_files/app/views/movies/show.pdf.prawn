#Preparing vars...
pic = "#{RAILS_ROOT}/public/images/pdf_top.png"
elements= [
  { :render_type => 'normal'       , :attribute => "title"                                            } ,  
  { :render_type => 'id_field'     , :attribute => "genre_id"                                         } ,  
  { :render_type => 'id_field'     , :attribute => "category_id"                                      } ,  
  { :render_type => 'subcategories', :attribute => "subcategories"                                    } ,  
  { :render_type => 'normal'       , :attribute => "synopsis"                                         } ,
  { :render_type => 'id_field'     , :attribute => "author_id"                                        } ,
  { :render_type => 'id_field'     , :attribute => "director_id"                                      } ,  
  { :render_type => 'normal'       , :attribute => "producer"                                         } ,
  { :render_type => 'normal'       , :attribute => "production_year"                                  } ,  
  { :render_type => 'normal'       , :attribute => "release_date"                                     } ,  
  { :render_type => 'normal'       , :attribute => "production_context"                               } ,  
  { :render_type => 'normal'       , :attribute => "distributor"                                      } ,  
  { :render_type => 'normal'       , :attribute => "duration"                                         } ,  
  { :render_type => 'normal'       , :attribute => "format"                                           } ,  
  { :render_type => 'yes_or_no'    , :attribute => "free"                                             } ,  
  { :render_type => 'normal'       , :attribute => "rights"                                           } ,  
  { :render_type => 'none'         , :attribute => "youtube_link"                                     } ,  
  { :render_type => 'normal'       , :attribute => "comments"                                         } ,  
  { :render_type => 'normal'       , :attribute => "main_event"                                       } ,
  { :render_type => 'normal'       , :attribute => "cultural_context"                                 } ,  
  { :render_type => 'normal'       , :attribute => "image_sound"                                      } ,  
  { :render_type => 'normal'       , :attribute => "ccdc"                                             } ,
  { :render_type => 'normal'       , :attribute => "reading"                                          } ,  
  { :render_type => 'normal'       , :attribute => "exploration"                                      } ,
  { :render_type => 'normal'       , :attribute => "analisis"                                         } ,  
  { :render_type => 'normal'       , :attribute => "proposals"                                        } ,  
  { :render_type => 'none'         , :attribute => "created_at"                                       } ,  
  { :render_type => 'none'         , :attribute => "updated_at"                                       } ,  
  { :render_type => 'none'         , :attribute => "user_id"                                          } ,  
  { :render_type => 'none'         , :attribute => "status"                                           } , 
  { :render_type => 'simple'       , :attribute => "Link"               , :value => movie_url(@movie) }   
]
itens = []
elements.each do | element |
  itens << render_full_info_element(element, @movie, nil, true)if render_full_info_element element, @movie
end 


#Printing PDF...

pdf.image pic if File::exists?(pic) 
pdf.text "Descrição e análise do filme \"#{@movie.title}\"", :style => :bold, :size => 13, :spacing => 20

itens.each do |iten|
  pdf.text iten.first, :size => 11, :spacing => 3, :style => :bold
  pdf.text iten.last,  :size => 11, :spacing => 2
  pdf.move_down 11
end

#pdf.table itens, :border_style => :grid,  
#  :row_colors => ["FFFFFF", "DDDDDD"],  
#  :align => { 0 => :right, 1 => :left },
#  :widths => { 0 => '200px', 1 => '300px' }


