# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

["Registrado", "Desarrollador", "Administrador", "Superadministrador"].each do |role|
  Role.find_or_create_by_name(role)
end
 
["Noticias", "Negocios", "Deporte", "TV, Peliculas & Musica", "Herramientas y Tecnologia", "Ocio", "Estilos de Vida", "Compras", "Viajes"].each do |category|
  Category.find_or_create_by_name(category) { |c| c.category_type = 'w' }
end

["Oficiales", "Animales", "Arte", "Cine", "Literatura", "VideoJuegos", "Musica", "Coches", "Lugares"].each do |category|
  Category.find_or_create_by_name(category) { |c| c.category_type = 't' }
end

User.find_or_create_by_username(
  :username => 'admin',
  :email => 'admin@example.com',
  :password => 'admin',
  :password_confirmation => 'admin',
  :role_id => Role.find_by_name('Superadministrador').id,
  :active => true,
  :created_at => Time.now,
  :updated_at => Time.now
).save!

User.find_or_create_by_username(
  :username => 'usuario',
  :email => 'omarcito.villalba@gmail.com',
  :password => 'usuario',
  :password_confirmation => 'usuario',
  :role_id => Role.find_by_name('Registrado').id,
  :active => true,
  :created_at => Time.now,
  :updated_at => Time.now
).save!

Image.find_or_create_by_id(
  :id => 1,
  :image_remote_url => 'http://img180.imageshack.us/img180/7093/logovq.png'
).save!

Image.find_or_create_by_id(
  :id => 2,
  :image_remote_url => 'http://www.ultimahora.com/imgs/uh-com.gif'
).save!

Image.find_or_create_by_id(
  :id => 3,
  :image_remote_url => 'http://www.tuningpy.com/logos/logo_lanacion_trans.gif'
).save!

Image.find_or_create_by_id(
  :id => 4,
  :image_remote_url => 'http://www.google.com/intl/es/images/logos/translate_logo.gif'
).save!

Image.find_or_create_by_id(
  :id => 5,
  :image_remote_url => 'http://dev.netvibes.com/doc/_media/examples/examples-weather.png?w=&h=&cache=cache'
).save!

Widget.find_or_create_by_name('UH') { |w|
  w.url = 'http://www.netvibes.com/modules/feedReader/feedReader.php?feedUrl=http%3A%2F%2Fwww.ultimahora.com%2Fadjuntos%2Frss%2FUltimoMomento.xml'
  w.category_id = Category.find_by_name('Noticias').id
  w.user_id = User.find_by_username('admin').id
  w.description = 'Ultimo Momento Noticias desde Paraguay.'
  w.approved = true
  w.public = true
  w.image_id = Image.find_by_data_file_name('uh-com.gif').id
  w.tag_names = 'UH, Ultimahora, noticias, diarios, deportes'
}

Widget.find_or_create_by_name('La Nacion') { |w|
  w.url = 'http://www.netvibes.com/modules/feedReader/feedReader.php?feedUrl=http%3A%2F%2Fwww.lanacion.com.py%2Frss'
  w.category_id = Category.find_by_name('Noticias').id
  w.user_id = User.find_by_username('admin').id
  w.description = 'Noticias Principales de La Nacion desde Paraguay.'
  w.approved = true
  w.public = true
  w.image_id = Image.find_by_data_file_name('logo_lanacion_trans.gif').id
  w.tag_names = 'Nacion, noticias, diarios, deportes'
}

Widget.find_or_create_by_name('Traductor Google') { |w| 
  w.url = 'http://nvmodules.typhon.net/antoine/traducteur.html'
  w.category_id = Category.find_by_name('Herramientas y Tecnologia').id
  w.user_id = User.find_by_username('admin').id
  w.description = 'Solo tiene que escribir el texto en el cuadro y traducirlo de manera rapida y facil'
  w.approved = true
  w.public = true
  w.image_id = Image.find_by_data_file_name('translate_logo.gif').id
  w.tag_names = 'traductor, translate, diccionario, ingles, español'
}

Widget.find_or_create_by_name('Clima') { |w| 
  w.url = 'http://www.netvibes.com/modules/weather/weather.html'
  w.category_id = Category.find_by_name('Noticias').id
  w.user_id = User.find_by_username('admin').id
  w.description = 'Muestra las predicciones meteorologicas del dia de cualquier ciudad de su eleccion.'
  w.approved = true
  w.public = true
  w.image_id = Image.find_by_data_file_name('examples-weather.png').id
  w.tag_names = 'tiempo, lluvia, meteorologia, soleado'
}

Image.find_or_create_by_id(
  :id => 6,
  :image_remote_url => 'http://dev.netvibes.com/doc/_media/examples/example-astronomy.png?w=&h=&cache=cache'
).save!

Widget.find_or_create_by_name('Foto astronomica del dia') { |w| 
  w.url = 'http://www.netvibes.com/api/uwa/examples/astronomy.html'
  w.category_id = Category.find_by_name('Herramientas y Tecnologia').id
  w.user_id = User.find_by_username('admin').id
  w.description = 'Actualidad sobre astronomia y ciencias del espacio.'
  w.approved = true
  w.public = true
  w.image_id = Image.find_by_data_file_name('example-astronomy.png').id
  w.tag_names = 'ciencia, astronomia, universo'
}

Image.find_or_create_by_id(
  :id => 7,
  :image_remote_url => 'http://www.north45pub.com/wp-content/uploads/facebook-logo.png'
).save!

Widget.find_or_create_by_name('Facebook') { |w| 
  w.url = 'http://www.netvibes.com/modules/facebook/facebook.html'
  w.category_id = Category.find_by_name('Ocio').id
  w.description = 'Echa un vistazo a las actualizaciones de tus amigos de Facebook'
  w.user_id = User.find_by_username('admin').id
  w.approved = true
  w.public = true
  w.image_id = Image.find_by_data_file_name('facebook-logo.png').id
  w.tag_names = 'facebook, red, social, network'
}

Image.find_or_create_by_id(
  :id => 8,
  :image_remote_url => 'http://www.aiesec.org/cms/aiesec/AI/Iberoamerica/MEXICO/AIESEC%20ITAM/Web_Imagenes/Twitter_logo.jpg'
).save!

Widget.find_or_create_by_name('Twitter') { |w| 
  w.url = 'http://www.netvibes.com/modules/twitter/twitter.html'
  w.category_id = Category.find_by_name('Ocio').id
  w.description = 'Actualiza tu estado y sigue a tus amigos de Twitter.'
  w.user_id = User.find_by_username('admin').id
  w.approved = true
  w.public = true
  w.image_id = Image.find_by_data_file_name('Twitter_logo.jpg').id
  w.tag_names = 'twitter, novedades, amigos, diversion'
}

Image.find_or_create_by_id(
  :id => 9,
  :image_remote_url => 'http://www.yoyonation.com/yoyoopen/uploads/images/zahipedia_fox_sports.jpg'
).save!

Widget.find_or_create_by_name('Fox Sports') { |w| 
  w.url = 'http://www.netvibes.com/modules/feedReader/feedReader.php?feedUrl=http%3A%2F%2Ffeeds.feedburner.com%2Ffoxsports%2FRSS%2Fsoccer'
  w.category_id = Category.find_by_name('Deporte').id
  w.description = 'Las ultimas noticias del mundo deportivo'
  w.user_id = User.find_by_username('admin').id
  w.approved = true
  w.public = true
  w.image_id = Image.find_by_data_file_name('zahipedia_fox_sports.jpg').id
  w.tag_names = 'deportes, futbol, fox sports, tv, novedades'
}

Image.find_or_create_by_id(
  :id => 10,
  :image_remote_url => 'http://www.symbian-freak.com/downloads/freeware/cat_s60_3rd/images/games/spaceinvaders.gif'
).save!

Widget.find_or_create_by_name('Space Invaders Juego') { |w| 
  w.url = 'http://www.labpixies.com/campaigns/invaders/invaders_nv.xml'
  w.category_id = Category.find_by_name('Ocio').id
  w.user_id = User.find_by_username('admin').id
  w.description = 'El juego arcade mas popular de todos los tiempos'
  w.approved = true
  w.public = true
  w.image_id = Image.find_by_data_file_name('spaceinvaders.gif').id
  w.tag_names = 'juego, space, invaders, arcade, fun'
}

Image.find_or_create_by_id(
  :id => 11,
  :image_remote_url => 'http://lh3.ggpht.com/_40vh-VkgC00/SgH86XZwn5I/AAAAAAAAAC4/n_Vvjc88xcY/s1600/tuxheader.jpg'
).save!

Image.find_or_create_by_id(
  :id => 12,
  :image_remote_url => 'http://lh4.ggpht.com/_uQWjD9x889E/SvRZGj95LfI/AAAAAAAAAiI/YeVU29N1gKo/s1600/google.jpg'
).save!

Image.find_or_create_by_id(
  :id => 13,
  :image_remote_url => 'http://www.bharathspecial.com/themes/cartoon.jpg'
).save!

Image.find_or_create_by_id(
  :id => 14,
  :image_remote_url => 'http://lh3.ggpht.com/_Ce8HhaE2spA/SirODAUUSDI/AAAAAAAAAA8/cUDmnin-EGM/s1600/volvo-igoogle1000.jpg'
).save!


Theme.find_or_create_by_name('Tux') { |t| 
  t.name = 'Tux'
  t.user_id = User.find_by_username('admin').id
  t.image_id = Image.find_by_data_file_name('tuxheader.jpg').id
  t.category_id = Category.find_by_name('Animales').id
  t.public = true
  t.approved = true
  t.font = "Arial"
  t.color = "FFFFFF"
}

Theme.find_or_create_by_name('Ingenieria') { |t| 
  t.name = 'Ingenieria'
  t.user_id = User.find_by_username('admin').id
  t.image_id = Image.find_by_data_file_name('google.jpg').id
  t.category_id = Category.find_by_name('Arte').id
  t.public = true
  t.approved = true
  t.font = "Arial"
  t.color = "FFFFFF"
}

Theme.find_or_create_by_name('Bugs Bunny') { |t| 
  t.name = 'Bugs Bunny'
  t.user_id = User.find_by_username('admin').id
  t.image_id = Image.find_by_data_file_name('cartoon.jpg').id
  t.category_id = Category.find_by_name('Cine').id
  t.public = true
  t.approved = true
  t.font = "Arial"
  t.color = "FFFFFF"
}

Theme.find_or_create_by_name('Volvo Car') { |t| 
  t.name = 'Volvo Car'
  t.user_id = User.find_by_username('admin').id
  t.image_id = Image.find_by_data_file_name('volvo-igoogle1000.jpg').id
  t.category_id = Category.find_by_name('Coches').id
  t.public = true
  t.approved = true
  t.font = "Arial"
  t.color = "FFFFFF"
}