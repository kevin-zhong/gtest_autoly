#!/bin/bash
## author - kevin_zhong; date - 2011-02-24

if [ $# -lt 2 ];then
	echo "usage: $0 work_path target_exe_name"
	exit -1
fi

TARGET_EXE=$2
TARGET_CPP=${TARGET_EXE}.cpp
TARGET_CPP_NEW=/tmp/${TARGET_CPP}.new
cd $1

TPL_SOURCE=/usr/local/include/gtest/unit_testor_template2.tpl
if [ $# -lt 3 ];then
	TPL_SOURCE=/usr/local/include/gtest/unit_testor_template.tpl
fi

ALL_LINE=0
HEAD_LINE=0
init_template()
{
	ALL_LINE=`cat ${TPL_SOURCE} | wc -l`
	HEAD_LINE=`cat -n ${TPL_SOURCE} | grep UnitTestorApp | head -1 | awk '{print $1}'`
	HEAD_LINE=`expr ${HEAD_LINE} - 1`

	head -${HEAD_LINE} ${TPL_SOURCE} > ${TARGET_CPP_NEW}
}

add_test()
{
	head_file=$1
	echo "#include \"${head_file}\"" >> ${TARGET_CPP_NEW}
	cat $each | grep TEST_F\( | sed "s/TEST_F(/TEST_F_INIT(/g" >> ${TARGET_CPP_NEW}
}

add_tail()
{
	tail_line=`expr ${ALL_LINE} - $HEAD_LINE`
	echo "" >> ${TARGET_CPP_NEW}
	tail -${tail_line} ${TPL_SOURCE} >> ${TARGET_CPP_NEW}
}

cnt=0

for each in `find . -name '*.h'`
do
	cat $each | grep TEST_F\(
	if [ $? != 0 ];then
		continue
	fi

	cnt=`expr $cnt + 1`
	if [ $cnt == 1 ];then
		init_template
	fi
	
	add_test $each
done

if [ $cnt == 0 ];then
	exit 1
fi

add_tail

if [ -f ${TARGET_CPP} ];then
	diff ${TARGET_CPP_NEW} ${TARGET_CPP}
	if [ $? -eq 0 ];then
		echo "no change on unit_testor.cpp"
		exit 0;
	fi
fi

echo "unit testor file changed !"
cp ${TARGET_CPP_NEW} ${TARGET_CPP}

exit 0


