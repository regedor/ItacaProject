namespace :db do
  namespace :fill do
    task :categorias => :environment do
      puts "A criar Categorias!\n"
        Category.new( :name => "Cat1" ).save 
        Category.new( :name => "Cat2"        ).save 
        Category.new( :name => "Cat3"     ).save 
        Category.new( :name => "Cat4"       ).save
        Category.new( :name => "Cat5"      ).save
      puts "Concluido!"
    end

    task :users => :environment do
      puts "A criar Users!"
      user = User.new
      user.login                 = 'regedor'
      user.password              = 'works68'
      user.password_confirmation = 'works68'
      user.name                  = 'Miguel Regedor'
      user.role                  = 0
      user.email                 = 'miguelregedor@gmail.com'
      user.phone                 = "964472540"
      user.sex                   = "male"
      user.save
      user.activate!
      puts "Concluido!"
    end

    task :all => [:categorias, :users]

  end
end
