(define-module (sys-modules packages sanctum)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system copy)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages crypto)
  #:use-module (gnu packages vim)
  #:use-module (gnu packages web))

(define-public libkyrka
  (package
    (name "libkyrka")
    (version "1.2.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/jorisvink/libkyrka")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32 "1fnjddwcgm6lqqvzy2p43n7amfg22q7lf2k1dlrfd9sp4vzx78n5"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:tests? #f
      #:parallel-build? #f
      #:make-flags
      #~(list (string-append "PREFIX=" #$output)
              (string-append "CC=" #$(cc-for-target)))
      #:phases
      #~(modify-phases %standard-phases
          (delete 'configure))))
    (native-inputs (list pkg-config))
    (propagated-inputs (list libsodium))
    (home-page "https://sanctorum.se/")
    (synopsis "Library implementation of the sanctum VPN protocol")
    (description "libkyrka is a library implementation of the sanctum VPN
protocol.")
    (license license:isc)))
(define-public tier6
  (package
    (name "tier6")
    (version "0.6.1")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/jorisvink/tier6")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32 "13gc0r24wm22x757v3zy2mb9hymnpkaxrvx0lwqpsj2jcl7w9m9s"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:tests? #f
      #:parallel-build? #f
      #:make-flags
      #~(list (string-append "PREFIX=" #$output)
              (string-append "CC=" #$(cc-for-target)))
      #:phases
      #~(modify-phases %standard-phases
          (delete 'configure)
          (add-before 'build 'create-release-file
            (lambda _
              (call-with-output-file "RELEASE"
                (lambda (port) (display #$version port)))))
          (add-before 'install 'make-bin-dir
            (lambda _
              (mkdir-p (string-append #$output "/bin")))))))
    (native-inputs (list pkg-config))
    (inputs (list libkyrka))
    (home-page "https://sanctorum.se/")
    (synopsis "Global ethernet network")
    (description "Build a global ethernet network based on sanctum.")
    (license license:isc)))

(define-public sanctum
  (package
   (name "sanctum")
   (version "1.4.1")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/jorisvink/sanctum")
                  (commit version)))
            (file-name (git-file-name name version))
            (sha256
             (base32 "187qxrqpc2xni811lgc6z9d1la8yb2x4w2ssa42znhvyvnps1ajm"))))
   (build-system gnu-build-system)
   (arguments
    (list
     #:tests? #f
     #:parallel-build? #f
     #:make-flags
     #~(list (string-append "PREFIX=" #$output)
             "INSTALL_TARGETS=install-bin install-man"
             "BUILD_DATE=1970-01-01"
             (string-append "CC=" #$(cc-for-target)))
     #:phases
     #~(modify-phases %standard-phases
		      (delete 'configure)
		      (add-before 'build 'create-release-file
				  (lambda _
				    (call-with-output-file "RELEASE"
				      (lambda (port) (display #$version port))))))))
   (native-inputs (list pkg-config))
   (inputs (list libsodium))
   (home-page "https://sanctorum.se/")
   (synopsis "Privilege-separated, post-quantum-secure VPN daemon")
   (description "Sanctum is a small VPN daemon with a hybrid classical and
post-quantum key exchange and full privilege separation.")
   (license license:isc)))

(define-public rlq
  (package
   (name "rlq")
   (version "1.0")
   (source (origin
            (method url-fetch)
            (uri "https://reliquary.se/rlq")
            (sha256
             (base32 "0wbl5zp5hnfy40vkcf7l7nnl2p2lqm1bn0bdvdczr7j18ay8562d"))))
   (build-system copy-build-system)
   (arguments
    (list
     #:install-plan #~'(("rlq" "bin/rlq"))
     #:phases
     #~(modify-phases %standard-phases
		      (replace 'unpack
			       (lambda* (#:key source #:allow-other-keys)
				 (copy-file source "rlq")))
		      (add-after 'install 'make-executable
				 (lambda _
				   (chmod (string-append #$output "/bin/rlq") #o555)))
		      (add-before 'install 'absolute-commands
				  (lambda _
				    (substitute* "rlq"
						 (("(^|[[:space:];|&(])(sanctum|ambry|hymn)([[:space:]]|$)" all pre cmd post)
						  (string-append pre #$sanctum "/bin/" cmd post)))))
		      (add-after 'make-executable 'wrap
				 (lambda _
				   (wrap-program (string-append #$output "/bin/rlq")
						 `("PATH" ":" prefix
						   ,(map (lambda (p) (string-append p "/bin"))
							 (list #$jq #$xxd #$curl #$sanctum)))))))))
   (inputs (list bash-minimal jq xxd curl sanctum))
   (home-page "https://reliquary.se/")
   (synopsis "Helper for reliquary")
   (description "Reliquary commands and subcommands to help you manage your
flocks and devices with ease.")
   (license license:expat)))
