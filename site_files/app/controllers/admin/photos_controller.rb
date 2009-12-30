class Admin::PhotosController < Admin::BaseController
  include Flexigrid
  crudify

  def index
    @resource_columns = "
      {display:'ID'                       ,name:'id'             ,width:24, sortable:true ,align:'left',hide:false},
      {display:'Image'                    ,name:'image'          ,width:60, sortable:false,align:'left',hide:false},
      {display:'Titulo'                   ,name:'title'          ,width:400,sortable:true ,align:'left',hide:false},
      {display:'Autor'                    ,name:'author_names'   ,width:300,sortable:false,align:'left',hide:false},
      {display:'Tamanho'                  ,name:'file_size'      ,width:58, sortable:false,align:'left',hide:false},
      {display:'Completo'                 ,name:'fill_percentage',width:57, sortable:false,align:'left',hide:false},
      {display:'Última actualização'      ,name:'updated_at'     ,width:120,sortable:true ,align:'left',hide:false},
      {display:'Actions'                  ,                       width:100,sortable:false,align:'left',hide:false},
    "
    super
  end

  def grid_data
    av = ActionView::Base.new
    return_data = default_flex_data Photo, "title"
    @resources = @resources.select { |p| p.base_version_id.nil? }
    return_data[:rows]  = @resources.collect{ |m| {
      :cell => [ 
        m.id                                                                     ,
        m.filename && av.image_tag(m.versions[:preview].relative_path) || av.image_tag('/images/bg_photo-icon.png') ,
        m.title                                                                  ,
        m.author_names                                                           ,
        m.file_size                                                              ,
        m.fill_percentage                                                        ,
        m.updated_at                                                             ,
        '<a href="' + edit_member_path(m) + '" > Editar </a>' +
        "<span> | </span>" +
        '<a href="' + delete_member_path(m) + '" > Remover </a>'
    ]
    }}
    # Convert the hash to a json object
    render :text => return_data.to_json, :layout=>false
  end

end
