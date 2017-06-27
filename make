#!/bin/bash
#SUN:jicong.wang version:1.0


#########################################################
# createFloderSinglework
#########################################################
function createFolderSinglework(){
    file=$1    
    if [ ! "$file" = "" ];then
        file_name=${file#./*}
        echo $file_name
        dir_name=${file_name%*.sh}"_"`date +%F`
        echo $dir_name
        
        if [ ! -d "$dir_name" ];then
            echo "start to mkdir file"
            mkdir $dir_name
        else
            echo "folder is exist"
        fi
        cp $file $dir_name
    fi
}

#########################################################
# svn export and make project
#########################################################
function doSingleProject(){
    file=$1    
    if [ ! "$file" = "" ];then
        file_name=${file#./*}
        dir_name=${file_name%*.sh}"_"`date +%F`
        
        cd ./$dir_name
        #echo ./$dir_name/$dir_name
        source $file_name ""
        source $file_name r
        source $file_name nu
        cd -    
    fi
}

#########################################################
# main 
#########################################################
echo "====================编译文件列表==================="
sh_file_list=`find ./* -maxdepth 0 -name "*.sh"`
i=0
for var in $sh_file_list
    do
    i=`expr $i + 1`
    echo "     $i : "$var
    custom[$i]=$var
    done
echo
echo "请选择项目脚本的数字 [eg: 1 2 3 ]"
read make_files_list

for var in $make_files_list
    do
        echo "start create folder $var == ${custom[$var]} ======================="
        createFolderSinglework ${custom[$var]}
    done
    
for v in $make_files_list
    do
        echo "start make $v == ${custom[$v]} ======================="
        doSingleProject ${custom[$v]}
    done    
#########################################################