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

--function script_path()
--  local str = debug.getinfo(2, "S").source:sub(2)
--   return str:match("(.*/)")
--end

--print(script_path())
--print(arg[0])
--print("bla")
--local val=os.getenv("HOME")
local val=myModuleVersion()
local val=myModuleName()
local val=myFileName()


-- This gets the path to module files relative the Lua definition file as described here: https://lmod.readthedocs.io/en/6.6/100_generic_modules.html
local fn      = myFileName()                      -- 1
local full    = myModuleFullName()                -- 2
local loc     = fn:find(full,1,true)-2            -- 3
local mdir    = fn:sub(1,loc)                     -- 4
local appsDir = mdir:gsub("(.*)/","%1")           -- 5
local pkgPath = pathJoin(appsDir, full)           -- 6
--local val = pkg
--prepend_path("PATH",script_path())
--prepend_path("PATH","/scicore/home/nimwegen/GROUP/Moma/Moma_Containerization/00_containerize_preprocessing/mmpreprocesspy/docker")
--prepend_path("PATH", pathJoin(root, ""))

pkgPath = string.gsub(fn,".lua","")
prepend_path("PATH",pkgPath)

--setenv("MMPRE_HOME","/scicore/home/nimwegen/GROUP/Moma/Moma_Containerization/00_containerize_preprocessing/mmpreprocesspy/docker" )
--setenv("MYVAL",pkgPath)
setenv("MYVAL",pkgPath)
--PATH="/scicore/home/nimwegen/GROUP/Moma/Moma_Containerization/00_containerize_preprocessing/mmpreprocesspy/docker":$PATH
--export export MMPRE_HOME="/scicore/home/nimwegen/GROUP/Moma/Moma_Containerization/00_containerize_preprocessing/mmpreprocesspy/docker"

