# coding: utf-8

puts 'Seeding the database...'

[
  { pt: 'Matemática e Estatística', en: 'Art', fr: 'Art'},
  { pt: 'Engenharia e Tecnologia', en: 'Visual Arts', fr: 'Art plastique' },
  { pt: 'Ciência da Computação', en: 'Circus', fr: 'Cirque' },
  { pt: 'Biologia', en: 'Community', fr: 'Comunauté' },
  { pt: 'Química', en: 'Humor', fr: 'Humour' },
  { pt: 'Ciências Humanas e Sociais', en: 'Comicbooks', fr: 'bd' },
  { pt: 'Economia, Administração e Finanças', en: 'Dance', fr: 'Dance' },
  { pt: 'Ecologia e Ciências Ambientais', en: 'Design', fr: 'Design' },
  { pt: 'Física e Astronomia', en: 'Events', fr: 'Événementiel' },
  { pt: 'Geociências', en: 'Fashion', fr: 'Mode' },
  { pt: 'Bioquímica', en: 'Gastronomy', fr: 'Gastronomie' },
  { pt: 'Educação', en: 'Film & Video', fr: 'Cinéma' },
  { pt: 'Ciências Médicas', en: 'Games', fr: 'Jeux' },
  { pt: 'Psicologia e Psiquiatria', en: 'Journalism', fr: 'Journalisme' },
  { pt: 'Arte e Designer', en: 'Music', fr: 'Musique' },
  { pt: 'Sociologia e Ciências Políticas', en: 'Photography', fr: 'Photographie' },
  { pt: 'Antropologia', en: 'Science & Technology', fr: 'Sciences et technologies' },
  { pt: 'História', en: 'Theatre', fr: 'Théatre' },
  { pt: 'Letras e Linguísticas', en: 'Sport', fr: 'Sport' },
  { pt: 'Neurociências', en: 'Web', fr: 'Web' },
  { pt: 'Ciências dos Materiais', en: 'Carnival', fr: 'Carnaval' },
  { pt: 'Arquitetura e Urbanismo', en: 'Architecture & Urbanism', fr: 'Architecture et Urbanisme' },
  { pt: 'Educação Física e Condicionamento Físico', en: 'Literature', fr: 'Literature' },
  { pt: 'Nanociências', en: 'Mobility & Transportation', fr: 'Transport et Mobilité' },
  { pt: 'Ciências Marinhas', en: 'Environment', fr: 'Environement' },
  { pt: 'Ciências da Comunicação', en: 'Social Business', fr: 'Social' },
  { pt: 'Divulgação Científica', en: 'Social Business', fr: 'Social' },
  { pt: 'Eventos Científicos', en: 'Environment', fr: 'Environement' },
].each do |name|
   category = Category.find_or_initialize_by(name_pt: name[:pt])
   category.update_attributes({
     name_en: name[:en]
   })
   category.update_attributes({
     name_fr: name[:fr]
   })
 end


{
  company_name: 'Entropia Coletiva',
  company_logo: 'http://www.entropiacoletiva.com/images/logo_big.png',
  host: 'entropiacoletiva.com',
  base_url: "http://entropiacoletiva.com",

  email_contact: 'contato@entropiacoletiva.com',
  email_payments: 'contato@entropiacoletiva.com',
  email_projects: 'contato@entropiacoletiva.com',
  email_system: 'suporte@entropiacoletiva.com',
  email_no_reply: 'contato@entropiacoletiva.com',
  facebook_url: "http://facebook.com/entropiacoletiva",
  facebook_app_id: '173747042661491',
  twitter_url: 'https://twitter.com/entropiacc',
  twitter_username: "@entropiacc",
  mailchimp_url: "http://entropiacoletiva.us12.list-manage.com/subscribe?u=39b126181d4730739eb0625f0&id=d07ab04039",
  catarse_fee: '0.13',
  support_forum: 'http://entropiacoletiva.com/',
  base_domain: 'entropiacoletiva.com',
  uservoice_secret_gadget: 'change_this',
  uservoice_key: 'uservoice_key',
  faq_url: 'http://entropiacoletiva.com/',
  feedback_url: 'http://blog.entropiacoletiva.com',
  terms_url: 'http://entropiacoletiva.com/pt/terms-of-use',
  privacy_url: 'http://entropiacoletiva.com/pt/privacy-policy',
  about_channel_url: 'http://blog.entropiacoletiva.com',
  instagram_url: 'http://instagram.com/entropiacoletiva',
  blog_url: "http://blog.entropiacoletiva.com",
  github_url: 'www.entropiacoletiva.com',
  contato_url: 'suporte@entropiacoletiva.com'
}.each do |name, value|
   conf = CatarseSettings.find_or_initialize_by(name: name)
   conf.update_attributes({
     value: value
   }) if conf.new_record?
end

OauthProvider.find_or_create_by!(name: 'facebook') do |o|
  o.key = '1001442279930440' 
  o.secret = '468da8c758b8d8616abd70c97774d911'
  o.path = 'facebook'
end

puts
puts '============================================='
puts ' Showing all Authentication Providers'
puts '---------------------------------------------'

OauthProvider.all.each do |conf|
  a = conf.attributes
  puts "  name #{a['name']}"
  puts "     key: #{a['key']}"
  puts "     secret: #{a['secret']}"
  puts "     path: #{a['path']}"
  puts
end


puts
puts '============================================='
puts ' Showing all entries in Configuration Table...'
puts '---------------------------------------------'

CatarseSettings.all.each do |conf|
  a = conf.attributes
  puts "  #{a['name']}: #{a['value']}"
end

Rails.cache.clear

puts '---------------------------------------------'
puts 'Done!'
