namespace :db do
  namespace :fill do
    task :categories => :environment do
      puts "A criar Categorias!\n"
      Category.new( :name => "Emigração"                           ).save 
      Category.new( :name => "Emigração África"                    ).save 
      Category.new( :name => "Emigração América do Norte"          ).save 
      Category.new( :name => "Emigração América Latina"            ).save
      Category.new( :name => "Emigração Ásia"                      ).save
      puts "Concluido!"
    end
    task :genres => :environment do
      puts "A criar Generos!\n"
      Genre.new( :name => "Emigração"                              ).save 
      Genre.new( :name => "Emigração África"                       ).save 
      Genre.new( :name => "Emigração América do Norte"             ).save 
      Genre.new( :name => "Emigração América Latina"               ).save
      Genre.new( :name => "Emigração Ásia"                         ).save
      puts "Concluido!"
    end

    task :document_types => :environment do
      puts "A criar document types!\n"
      DocumentType.new( :name => "Ficção"                          ).save 
      DocumentType.new( :name => "Documentário"                    ).save 
      DocumentType.new( :name => "Investigação"                    ).save 
      DocumentType.new( :name => "Institucionais"                  ).save
      DocumentType.new( :name => "Amadores"                        ).save
      DocumentType.new( :name => "outros"                          ).save
      puts "Concluido!"
    end

    task :users => :environment do
      puts "A criar Users!"
      user = User.new
      user.login                 = 'regedor'
      user.password              = 'works68'
      user.password_confirmation = 'works68'
      user.name                  = 'Miguel Regedor'
      user.role                  =  User::ROOT
      user.email                 = 'miguelregedor@gmail.com'
      user.phone                 = "964472540"
      user.sex                   = "male"
      user.save
      user.activate!
      user = User.new
      user.login                 = 'itaca'
      user.password              = 'itacapass'
      user.password_confirmation = 'itacapass'
      user.name                  = 'IDM Admin'
      user.role                  =  User::ADMIN
      user.email                 = 'jsribeiro@gmail.com'
      user.phone                 = ""
      user.sex                   = "male"
      user.save
      user.activate!
      puts "Concluido!"
    end

    task :all => [:categories, :users, :genres, :document_types]

  end
end
