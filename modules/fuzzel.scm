(define-module (modules fuzzel)
  #:use-module (gnu home services)
  #:use-module (guix gexp)
  #:use-module (gnu packages xdisorg)
  #:export (fuzzel-home-services))

(define fuzzel-home-services
  (list 
   (simple-service 'fuzzel-config-service
		   home-xdg-configuration-files-service-type
		   (list `("fuzzel/fuzzel.ini"
			   ,(plain-file "fuzzel.ini" "\
[main]
font=monospace:size=12
terminal=foot
layer=overlay
width=30

[colors]
background=2E3440dd
text=88C0D0ff
match=88C0D0ff
selection=88C0D0ff
"))))))
