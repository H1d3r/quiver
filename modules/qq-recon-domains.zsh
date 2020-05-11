#!/usr/bin/env zsh

############################################################# 
# qq-recon-domains
#############################################################

qq-recon-domains-help() {
  cat << END

qq-recon-domains
-------------
The recon-domains namespace provides commands to recon horizontal domains of a root domain.
All domains stored in $__PROJECT/domains/domains.txt and $__PROJECT/amass.
You can sort unique this file in place with the "sfu" alias.

Commands
--------
qq-recon-domains-install: installs dependencies
qq-recon-domains-amass-whois: find domains with whois
qq-recon-domains-amass-asn: find domains by asn

END
}

qq-recon-domains-install() {
  __pkgs amass 
}

qq-recon-domains-amass-whois() {
  __check-project
  qq-vars-set-domain
  mkdir -p ${__PROJECT}/amass
  mkdir -p ${__PROJECT}/domains
  print -z "amass intel -active -whois -d ${__DOMAIN} -dir ${__PROJECT}/amass >> ${__PROJECT}/domains/domains.txt"
}

qq-recon-domains-amass-asn() {
  __check-project
  local a && read "a?$(__cyan ASN: )"
  mkdir -p ${__PROJECT}/amass
  mkdir -p ${__PROJECT}/domains
  print -z "amass intel -active -asn ${a} -dir ${__PROJECT}/amass >> ${__PROJECT}/domains/domains.txt"
}
