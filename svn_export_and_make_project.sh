#!/bin/bash
# version 1.0

param=$1
path="http://192.168.1.233/svn/SPRD7731/trunk/MocorDroid6.0_Trunk_16b_rls1_W16.29.2"
rpath="http://192.168.1.233/svn/sprd7731/trunk/MocorDroid6.0_Trunk_16b_rls1_W16.29.2_SUNVOV/C7367/C7367_HWD"
gsm_path="http://192.168.1.233/svn/sprd7731/trunk/GSM/r11"

eng_version="sp7731c_c7367_fwvga_oversea-userdebug"
user_version="sp7731c_c7367_fwvga_oversea-user"
out_file="sp7731c_c7367_fwvga"

custom_list=(
          "C7367_FWVGA_Driver"
          "C7367_FWVGA_R2_HOTWAV_NOGPS_B1"
)

#######################################################################
#
# export all svn files and folders
#
#######################################################################
function export_all(){
  echo "-----------start to export all model-------------"    
  index=0
  for var in $list
    do
      index=`expr $index + 1`
      if [ $index -lt 10 ];then
          export_single $var "0"$index    
      else
        export_single $var $index
      fi
    done
  svn --force export ${gsm_path} ./ | tee gsm.txt;                    
  export_check
}
#######################################################################
#
# export one file or folder
#
#######################################################################
function export_single(){
  svn --force export ${path}/$1 | tee svn_info/$2.txt;
  echo "$1 result is "$? >> svn_result.txt
}
#######################################################################
#
# export result check
#
#######################################################################
function export_check(){
  echo "-----------start to check leave model-------------"    	
  exportOK="以导出版本"
  
  for i in `ls svn_info/`
    do
        info=`$i "`tail -n 1 svn_info/$i`
    	#echo "$i "`tail -n 1 svn_info/$i`;
    	echo $info
    	#if [[ $info =~ $exportOK ]]
    	#then
    	#    echo $info" exprot ok!!"
    	#else
    	#    echo $info" exprot fail!!"
    	#fi
    done
  
  index=0
  for var in ${custom_list[*]}
    do
      index=`expr $index + 1`
      echo r$index.txt`tail -n 1 r$index.txt`;
    done 

    echo gsm.txt`tail -n 1 gsm.txt`;    
}
#######################################################################
#
# export custom product code and resource
#
#######################################################################
function export_custom(){
  echo "-----------start to export all resource-------------"     
  index=0
  for var in ${custom_list[*]}
    do
      index=`expr $index + 1`
      svn --force export ${rpath}/$var ./ | tee r$index.txt;
    done  
}
#######################################################################
#
# make eng version
#
#######################################################################
function make_eng_version(){
	echo "-----------start to new eng version -------------"    
	source build/envsetup.sh
	lunch_list=`print_lunch_menu`
	
	num="n"
	for var in $lunch_list
	  do
	    # echo $var
        if [ $var = $eng_version ];then
          echo $var
          break
        else
          num=$var     
        fi
      done	    
      
    num=${num%.}
    echo "num is "$num        
    lunch $num
    sprd=`echo $path | grep -i "SPRD"`
    
    if [ "$sprd" != "" ];then
      echo "start kheader"
      kheader
    fi
            
    make -j8 2>&1 |tee log.txt
}
#######################################################################
#
# make eng version
#
#######################################################################
function make_user_version(){
	echo "-----------start to new usr version -------------"    
	
    rm -rf out/target/product/$out_file/system/build.prop
    rm -rf out/target/product/$out_file/obj/ETC/system_build_prop_intermediates
    
	source build/envsetup.sh
	lunch_list=`print_lunch_menu`
	
	num="n"
	for var in $lunch_list
	  do
        if [ $var = $user_version ];then
          echo $var
          break
        else
          num=$var       
        fi
      done	    
      
    num=${num%.}
    echo $num
        
    lunch $num
    
    sprd=`echo $path | grep -i "SPRD"`
    
    if [ "$sprd" != "" ];then
      echo "start kheader"
      kheader
    fi    
        
    make -j8 2>&1 |tee log.txt
}
#######################################################################
#
# export fail svn folder
#
#######################################################################
function export_fail(){
  echo "-----------start to check $parm model-------------"    		
  index=0
  for var in $list
    do
      index=`expr $index + 1`
      if [ $index == $1 ];then
        if [ $1 -lt 10 ];then
         export_single $var "0"$1       
        else  
         export_single $var $1   
        fi     
      fi
    done      
}
#######################################################################
#
# svn files and folders detail
#
#######################################################################
function list_detail(){
  index=0
  for var in $list
    do
      index=`expr $index + 1`
      echo $index:$var
    done   
}

#######################################################################
#
# cp out file to versionTools/image/
#
#######################################################################
function copyfile(){
    find out/target/product/$out_file/ -maxdepth 1 -type f -exec cp -rv {} versionTools/image/ \;  
    chmod 777 versionTools/*
}

#######################################################################
#
# main 
#
#######################################################################

ROOT=`pwd`"/svn_info";

if [ ! -d "$ROOT" ];then
	mkdir $ROOT;
fi

list=`svn list $path`

if [ "$param" = "" ];then
  export_all
elif [ "$param" = "c" ];then
  export_check  
elif [ "$param" = "r" ];then
  export_custom
elif [ "$param" = "ne" ];then
  make_eng_version
elif [ "$param" = "nu" ];then
  make_user_version
elif [ "$param" = "l" ];then
   list_detail
elif [ "$param" = "cp" ];then
    copyfile
else
  export_fail $1  
fi