function sprdenv
{
	if test -f build/envsetup.sh
	then
		source build/envsetup.sh
		lunch
		kheader
	else
		echo "非正常展讯代码目录!"
		return 
	fi
}
function sprdmake
{
	make -j8  2>&1 |tee build.log
}
