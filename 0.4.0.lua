help([==[

Description
===========
Preprocessing tool for the Mother-machine analayzer (MoMA).


More information
================
 - Homepage: https://github.com/michaelmell/mmpreprocesspy 
]==])

whatis([==[Description: preprocessing tool for the Mother-machine analayzer (MoMA)]==])
whatis([==[Homepage: https://github.com/michaelmell/mmpreprocesspy]==])

conflict("moma-preprocess")

local fn      = myFileName()

pkgPath = string.gsub(fn,".lua","")
prepend_path("PATH",pkgPath)
