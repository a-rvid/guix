(define-module (modules foot)
  #:use-module (gnu home services)
  #:use-module (guix gexp)
  #:use-module (gnu packages xdisorg)
  #:export (foot-home-services))

(define foot-home-services
  (list 
   (simple-service 'foot-config-service
		   home-xdg-configuration-files-service-type
		   (list `("foot/foot.ini"
			   ,(plain-file "foot.ini" "\
[main]
font=monospace:size=12
term=xterm-256color

[cursor]
blink = yes

[mouse]
hide-when-typing = yes

[colors-dark]
background=2E3440
# text=88C0D0
"))))))
