require 'rubygems'
require 'koala'
require 'json'

#token que só deverá expirar em 59 dias
@graph = Koala::Facebook::API.new('CAAD8cd4tMVkBAO3sh2DrzwZCDfeQq9ZAvTz7Jz24ZC26KtMfBoljqaXhD2vBV1zpP0bjrpxXUBzJvKKcFzOm6rMG9Sok7iNVUaxt5iwr7dfMqCvHpMboKpqrqgeLrfCH5ITVTAdezA6ZBSr9iOJrqyCSOYfui0zTmbXJ3FqtshwNRrRy4NPH')

#feed = @graph.get_connections("participabr", "posts") 


comentariosIniciais = []
comentariosExtraidos = []
comentariosNovos = []

primeiraVez = true

while true 

	feed = @graph.get_connections("mundoreagindo", "posts") 

	array = []
	comentariosExtraidos = []
	feed.each {|f| 
		if f['comments'] != nil && f['comments']['data'] != nil
			array.push(f['comments']['data'])
		end
	}

	array.each{ |comentarios|
		comentarios.each{|comentario|
			comentariosExtraidos.push("#{comentario['from']['name']} disse: #{comentario['message']}")
		}					
	}

	comentariosExtraidos = comentariosExtraidos.uniq

	if primeiraVez
		comentariosIniciais=comentariosExtraidos.clone 
		primeiraVez = false
	end

#		comentariosExtraidos.each{|comentario|
#			 puts comentario
#		}					

	comentariosNovos =  comentariosExtraidos - comentariosIniciais
	comentariosNovos = comentariosNovos.uniq
	comentariosIniciais += comentariosNovos 
	comentariosIniciais = comentariosIniciais.uniq
	comentariosNovos.each{|comentario|
		puts comentario
	}
	
	sleep(5)
end
