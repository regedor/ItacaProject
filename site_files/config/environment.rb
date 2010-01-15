# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
#RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
require 'lib/extensions.rb'

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use. To use Rails without a database
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Specify gems that this application depends on. 
  # They can then be installed with "rake gems:install" on new installations.
  # You have to specify the :lib option for libraries, where the Gem name (sqlite3-ruby) differs from the file itself (sqlite3)
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Comment line to use default local time.
  config.time_zone = 'UTC'

  # The internationalization framework can be changed to have another default locale (standard is :en) or more load paths.
  # All files from config/locales/*.rb,yml are added automatically.
  # config.i18n.load_path << Dir[File.join(RAILS_ROOT, 'my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_site_files_session',
    :secret      => '2e08bb10abbed0d35259bd4c45b1e5e9db536ee67030cf86700ad4b6676ee7410196d454d1ae3c552916bc9c7579c64ca59725d3719d5d6639f7d043f4fc4668'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with "rake db:sessions:create")
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # Please note that observers generated using script/generate observer need to have an _observer suffix
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
  config.active_record.observers = :user_observer
end

class String
  def humanize 
    {
      :new_movie                   => "Inserir filme",
      :new_sound_document          => "Inserir documento sonoro",
      :new_writen_document         => "Inserir documento escrito",
      :new_music_genre             => "Criar novo tipo de som",
      :new_photo                   => "Inserir foto",
      :new_director                => "Inserir realizador",
      :new_local                   => "Inserir local",
      :new_document_type           => "Criar novo tipo de documento",
      :new_prize                   => "Inserir prémio",
      :new_author                  => "Inserir autor",
      :new_country                 => "Inserir País",
      :new_genre                   => "Criar novo genero",
      :movie                       => "Filme",
      :movies                      => "Filmes",
      :sound_document              => "Documento Sonoro",
      :sound_documents             => "Documentos Sonoros",
      :writen_document             => "Documento Escrito",
      :writen_documents            => "Documentos Escritos",
      :photo                       => "Foto",
      :photos                      => "Fotos",
      :director                    => "Realizador",
      :directors                   => "Realizadores", 
      :country                     => "País", 
      :countries                   => "Países", 
      :local                       => "Local",
      :locals                      => "Locais", 
      :document_type               => "Tipo de Documento", 
      :document_types              => "Tipos de Documento", 
      :music_genre                 => "Tipo de Som", 
      :music_genres                => "Tipos de Som", 
      :genre                       => "Género", 
      :genres                      => "Géneros", 
      :prize                       => "Prémio",
      :prizes                      => "Prémios", 
      :name                        => "Nome",
      :title                       => "Título",
      :synopsis                    => "Sinopse", 
      :author                      => "Autor",  
      :author_2                    => "Autor 2",        
      :author_3                    => "Autor 3",        
      :author_4                    => "Autor 4",        
      :authors                     => "Autores",  
      :director                    => "Realizador",  
      :director_2                  => "Realizador 2",        
      :director_3                  => "Realizador 3",        
      :director_4                  => "Realizador 4",        
      :producer                    => "Produtor",   
      :production_year             => "Ano de Produção",            
      :edition_year                => "Ano de Edição",
      :document_type               => "Tipo de Documento", 
      :release_date                => "Ano de Rodagem",               
      :comments                    => "Comentário",           
      :production_context          => "Contexto de Produção",               
      :distributor                 => "Distribuidor",         
      :duration                    => "Duração",           
      :format                      => "Formato",          
      :category                    => "Temática",
      :categories                  => "Temáticas",
      :subcategory                 => "Descritor",
      :subcategories               => "Descritores",
      :subcategory_1               => "Descritor 1",        
      :subcategory_2               => "Descritor 2",  
      :subcategory_3               => "Descritor 3",  
      :subcategory_4               => "Descritor 4",  
      :free                        => "Tem autorização",    
      :rights                      => "Autorizações",  
      :first_work                  => "Primeira Obra",    
      :main_event                  => "Acontecimento principal",
      :cultural_context            => "Contexto sócio-cultural e político do acontecimento",
      :image_sound                 => "Imagem, som, montagem, narrativa",
      :ccdc                        => "Crítica de cinema e o discurso dos cineastas",
      :reading                     => "Leitura reflexiva",
      :exploration                 => "Exploração pedagógica",
      :analisis                    => "Análise aprofundada",
      :proposals                   => "Propostas de produção",
      :user                        => "Utilizador",
      :users                       => "Utilizadores",
      :phone                       => "Telefone",
      :sex                         => "Sexo",
      :biography                   => "Biografia",
      :description                 => "Descrição",
      :action                      => "Acção",
      :actions                     => "Acções",
      :created_at                  => "Data de inserção",
      :updated_at                  => "Última actulização",
      :youtube_link                => "Link de YouTube",
      :add                         => "Adicionar",
      :remove                      => "Remover",
      :all                         => "todos os",
      :add_movies                  => "Adicionar filmes",
      :add_writen_documents        => "Adicionar documentos escritos",
      :add_sound_documents         => "Adicionar documentos sonoros",
      :add_photos                  => "Adicionar fotos",
      :add_locals                  => "Adicionar locais",
      :add_prizes                  => "Adicionar prémios",
      :add_countries               => "Adicionar Países",
      :remove_all_writen_documents => "Remover todos os documentos escritos",
      :remove_all_sound_documents  => "Remover todos os documentos sonoros",
      :remove_all_photos           => "Remover todas as fotos",
      :file_size                   => "Tamanho (bytes)",
      :filename                    => "Nome do ficheiro",
      :yes                         => "Sim",
      :no                          => "Não",
      :countryname                 => "País"
    }[self.downcase.gsub(/ /, "_").gsub(/_id$/, "").to_sym] ||
    (self.split.size > 1 and return self.gsub(/_/, " ").split.map(&:humanize).join(" ").capitalize) || super	    
  end
end

