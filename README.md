#Uso
perl brute.pl [parametros]

#Parametros
--target : url que se atacara, con formato http://url (obligatorio) 
--u : nombre del input del usuario (obligatorio) 
--p : nombre del input de la contraseña (obligatorio)
--frase : frase de error en la web, con datos incorrectos (obligatorio)
--user : si sabes cual es el usuario, ingresalo aqui (opcional)
--pass : si sabes cual es la contraseña, ingresala aqui (opcional)
--debug : muestra el usuario, contraseña y respuesta de cada peticion

#Comentarios
Asegurate de que el diccionario dir.txt, este en la misma carpeta que brute.pl. 
La url o target debe empezar con http://
Este script por el momento tiene conflictos con sitios en cloudfare, pero si logras tener la ip real del sitio, realizara el ataque sin problemas
El script es demasiado basico, espero poder mejorarlo mas
Antes de criticar ayude a mejorarlo
Si tienes una recomendacion, no dudes en comentarla :)
#Demo
https://youtu.be/yx_uJSwaRjU
