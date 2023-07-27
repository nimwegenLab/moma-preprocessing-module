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

--local root="/scicore/home/nimwegen/GROUP/Moma/Modules/moma-preprocess-module/moma-preprocess/0.2.0"

conflict("moma-preprocess")
--setenv("", "")

prepend_path("PATH","/scicore/home/nimwegen/GROUP/Moma/Moma_Containerization/00_containerize_preprocessing/mmpreprocesspy/docker")
--prepend_path("PATH", pathJoin(root, ""))
setenv("MMPRE_HOME","/scicore/home/nimwegen/GROUP/Moma/Moma_Containerization/00_containerize_preprocessing/mmpreprocesspy/docker" )
--PATH="/scicore/home/nimwegen/GROUP/Moma/Moma_Containerization/00_containerize_preprocessing/mmpreprocesspy/docker":$PATH
--export export MMPRE_HOME="/scicore/home/nimwegen/GROUP/Moma/Moma_Containerization/00_containerize_preprocessing/mmpreprocesspy/docker"

