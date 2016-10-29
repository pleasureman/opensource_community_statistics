#!/bin/bash
set -e
export GIT_SSL_NO_VERIFY=true

export time_stamp=`date '+%Y_%m_%d_%H_%M_%S'`
TMP=/tmp/patch`whoami`/${time_stamp}
mkdir -p $TMP
rm -rf /var/www/html/2016/*
#TMP=`mktemp -d`

echo TMP=$TMP
#REPORT=$TMP/report_debug.html
REPORT=$TMP/2016.html
TOPDIR=`dirname $0`
cd $TOPDIR;
TOPDIR=`pwd`/community
echo "TOPDIR= $TOPDIR"
otherparameter="--since 2016-1-1 --until 2016-12-31 --pretty=format:%ae"
image_tools_otherparameter="--since 2016-9-16 --until 2016-12-31 --pretty=format:%ae"
#otherparameter="--since 2016-1-1 --pretty=format:%ae"
mkdir -p $TOPDIR
#TOPDIR=/root/patch/community/
#communitylist="ltp libnetwork libcontainer"
#communitylist="kernel docker runc ltp swarm distribution libnetwork machine kpatch logrus coder mcelog syslog-ng notary rancheros rancheros-kernel rancheros-images rancher-docker-from-scratch rancher-os-base containerd runtime-spec"
#communitylist="kernel docker runc runv ocitools image-spec rkt ltp swarm distribution libnetwork machine kpatch notary containerd runtime-spec f2fs-tools rancheros rancheros-images"
communitylist="kernel ltp kpatch criu image-spec image-tools runtime-spec runc docker ocitools rkt distribution  notary containerd  f2fs-tools"

for i in $communitylist
do
	echo "checking $i community"
	if [ -e ${TOPDIR}/$i ];then
		cd ${TOPDIR}/$i
	else
		cd ${TOPDIR};
		echo "start to clone $i community"
		case $i in
		#"libcontainer" ) repo="https://github.com/docker/libcontainer.git";;
		"docker" ) repo="https://github.com/docker/docker.git";;
		"compose" ) repo="https://github.com/docker/compose.git";;
		"docker-registry" ) repo="https://github.com/docker/docker-registry.git";;
		"libnetwork" ) repo="https://github.com/docker/libnetwork.git";;
		"lxc" ) repo="https://github.com/lxc/lxc.git";;
		"oe-core" ) repo="https://github.com/openembedded/oe-core.git";;
		"runtime-spec" ) repo="https://github.com/opencontainers/runtime-spec.git";;
		"machine" ) repo="https://github.com/docker/machine.git";;
		"meta-oe" ) repo="https://github.com/openembedded/meta-oe.git";;
		"crash" ) repo="https://github.com/crash-utility/crash.git";;
		"kexec-tools" ) repo="https://git.kernel.org/pub/scm/utils/kernel/kexec/kexec-tools.git";;
		"kernel" ) repo="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git";;
		#"kernel" ) repo="https://github.com/torvalds/linux.git";;
		"distribution" ) repo="https://github.com/docker/distribution.git";;
		"kpatch" ) repo="https://github.com/dynup/kpatch";;
		"logrus" ) repo="https://github.com/Sirupsen/logrus.git";;
		"code" ) repo="http://git.code.sf.net/p/makedumpfile/code";;
		"rasdaemon" ) repo="https://git.fedorahosted.org/git/rasdaemon.git";;
		"ltp" ) repo="https://github.com/linux-test-project/ltp";;
		"mcelog" ) repo="https://git.kernel.org/pub/scm/utils/cpu/mce/mcelog.git";;
		"runc" ) repo="https://github.com/opencontainers/runc.git";;
		"swarm" ) repo="https://github.com/docker/swarm.git";;
		"docker-bench-security" ) repo="https://github.com/docker/docker-bench-security.git";;
		"notary" ) repo="https://github.com/docker/notary.git";;
		"syslog-ng" ) repo="https://github.com/balabit/syslog-ng.git";;
		"rancheros" ) repo="https://github.com/rancher/os.git";;
		"rancheros-kernel" ) repo="https://github.com/rancher/os-kernel.git";;
		"rancheros-images" ) repo="https://github.com/rancher/os-images.git";;
		"rancher-docker-from-scratch" ) repo="https://github.com/rancher/docker-from-scratch.git";;
		"rancher-os-base" ) repo="https://github.com/rancher/os-base.git";;
		"containerd" ) repo="https://github.com/docker/containerd.git";;
		"f2fs-tools" ) repo="https://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs-tools.git";;
		"rkt" ) repo="https://github.com/coreos/rkt.git";;
		"runv" ) repo="https://github.com/hyperhq/runv.git";;
		"ocitools" ) repo="https://github.com/opencontainers/ocitools.git";;
		"image-spec" ) repo="https://github.com/opencontainers/image-spec.git";;
		"rancheros" ) repo="https://github.com/rancher/os.git";;
		"rancheros-images" ) repo="https://github.com/rancher/os-images.git";;
		"criu" ) repo="https://github.com/xemul/criu.git";;
		"image-tools") repo="https://github.com/opencontainers/image-tools.git";;
		#"" ) repo="";;
		#"swarm" ) repo="https://github.com/docker/swarm.git";;
		#"swarm" ) repo="https://github.com/docker/swarm.git";;
		#"swarm" ) repo="https://github.com/docker/swarm.git";;
		#* ) echo "not exist $i repo";exit 1;;
		esac
		git clone ${repo}  $i
		cd ${TOPDIR}/$i
	fi
	#git log --since 2015-1-1 | grep ^Author: | grep "@huawei.com" | awk '{print $NF}' | sed 's/^<//g' | sed 's/>$//g' | grep -v ^$ | grep -v "\?" > ${TMP}/${i}_authors
	echo "git pull $i repo"
	touch ${TMP}/${i}_authors
	#git pull && git log ${otherparameter} | grep ^Author: | grep -e "@huawei.com" -e "@hisilicon.com" | awk '{print $NF}' | sed 's/^<//g' | sed 's/>$//g' | grep -v ^$ | grep -v "\?" > ${TMP}/${i}_authors
	git pull 
	if [ ${i} == "image-tools" ];then
		#otherparameter=${image_tools_otherparameter}
		git log ${image_tools_otherparameter} | grep -e "@huawei.com" -e "@hisilicon.com" -e "kaixu.xia@linaro.org" -e "hanjun.guo@linaro.org" | grep -v ^$ | grep -v "\?" > ${TMP}/${i}_authors || echo no huawei commit
		git log ${image_tools_otherparameter} | grep -v ^$ | grep -v "\?" | awk -F "@" '{print $2}' | sed '/^$/d' > ${TMP}/${i}_company || echo no commit

	else
	git log ${otherparameter} | grep -e "@huawei.com" -e "@hisilicon.com" -e "kaixu.xia@linaro.org" -e "hanjun.guo@linaro.org" | grep -v ^$ | grep -v "\?" > ${TMP}/${i}_authors || echo no huawei commit
	git log ${otherparameter} | grep -v ^$ | grep -v "\?" | awk -F "@" '{print $2}' | sed '/^$/d' > ${TMP}/${i}_company || echo no commit
	fi
	echo "sort $i data"
	sort ${TMP}/${i}_authors | uniq > ${TMP}/${i}_authorlist
	sort ${TMP}/${i}_company | uniq > ${TMP}/${i}_companylist

	#company_id=1
	while read line; 
	do
		touch ${TMP}/${i}_companyinfo;
		echo -n "$line " >> ${TMP}/${i}_companyinfo || touch ${TMP}/${i}_companyinfo;
		echo `grep $line ${TMP}/${i}_company | wc -l` >> ${TMP}/${i}_companyinfo || touch ${TMP}/${i}_companyinfo
		company_id=`expr ${company_id} + 1`
	done < ${TMP}/${i}_companylist
	sort -n -r -k2 ${TMP}/${i}_companyinfo > ${TMP}/${i}_companyinfosorted

	#rm -rf /var/www/html/2016/*
	#cp -rf ${TMP}/${i}_companyinfosorted /var/www/html/2016/${i}_company
	iconv -f gb2312 -t utf-8 ${TMP}/${i}_companyinfosorted > /var/www/html/2016/${i}_company.txt
	
	while read line; 
	do
		echo -n "$line  " >> ${TMP}/${i}_authorinfo || touch ${TMP}/${i}_authorinfo; 
		echo `grep $line ${TMP}/${i}_authors | wc -l` >> ${TMP}/${i}_authorinfo || touch ${TMP}/${i}_authorinfo; 
	done < ${TMP}/${i}_authorlist

	#sort -n -r  -k2 ${TMP}/authorinfo > ${TMP}/authorinfo_sorted
	sort -n -r  -k2 ${TMP}/${i}_authorinfo | grep -e "@huawei.com" -e "@hisilicon.com" > ${TMP}/${i}_authorinfosorted || touch ${TMP}/${i}_authorinfosorted 

	echo "cd $TMP"
	echo "cat ${TMP}/${i}_authorinfosorted"
	echo "--------------------------------"
done

sort ${TMP}/*_authorlist | uniq > ${TMP}/all_authorlist || touch ${TMP}/all_authorlist 

while read line; 
do
	total=`grep $line ${TMP}/*_authors | wc -l`

	personal_tmp=""
	for i in $communitylist
	do
		tmp=`grep $line ${TMP}/${i}_authors | wc -l`
		personal_tmp="${personal_tmp} $tmp"
	done
	echo  "$line ${total} ${personal_tmp}" >> ${TMP}/all_authorinfo;
done < ${TMP}/all_authorlist

	sort -n -r  -k2 ${TMP}/all_authorinfo > ${TMP}/all_authorinfosorted


echo "<style type="text/css">" >> ${REPORT}
echo "table {" >> ${REPORT}
echo "margin: 1em 1em 1em 0;" >> ${REPORT}
echo "background: #f9f9f9;" >> ${REPORT}
echo "border: 1px #aaaaaa solid;" >> ${REPORT}
echo "border-collapse: collapse;" >> ${REPORT}
echo "}" >> ${REPORT}
echo "table th, table td {" >> ${REPORT}
echo "border: 1px #aaaaaa solid;" >> ${REPORT}
echo "padding: 0.2em;" >> ${REPORT}
echo "}" >> ${REPORT}
echo "</style>" >> ${REPORT}

echo "Updated time: `date '+%Y/%m/%d %H:%M:%S'`        admin: sunyuan3@huawei.com" >> ${REPORT}

echo "<p><table>" >> ${REPORT}


echo "<tr>" >> ${REPORT}
echo "<th align=center></th>" >> ${REPORT}
echo "<th align=center></th>" >> ${REPORT}
echo "<th align=center></th>" >> ${REPORT}
echo "<th colspan=4><align=center>kernel</th>" >> ${REPORT}
echo "<th colspan=10><align=center>container</th>" >> ${REPORT}
echo "<th align=center>other</th>" >> ${REPORT}
echo "</tr>" >> ${REPORT}


echo "<tr>" >> ${REPORT}
echo "  <th align=center><div style=\"width:30px;\">num</th>" >> ${REPORT}
echo "  <th align=center><div style=\"width:150px;\">author</th>" >> ${REPORT}
echo "  <th align=center><div style=\"width:30px;\">all</th>" >> ${REPORT}
for i in $communitylist
do
	charnum=`echo $i | wc -c`
	wid=$(($charnum*8))
	if [ $wid -le 30 ];then
		wid=30
	fi
	
	#echo "  <th align=center><div style=\"width:100px;\">$i</th>" >> ${REPORT}
	echo "  <th align=center><div style=\"width:${wid}px;\">$i</th>" >> ${REPORT}
done
echo "</tr>" >> ${REPORT}


# total quantity
allpatchquantity=`cat ${TMP}/*_authors | wc -l`
echo "<tr>" >> ${REPORT}
echo "<td align=center><b> </b></td>" >> ${REPORT}
echo "<td align=center><b>all</b></td>" >> ${REPORT}
echo "<td align=center><b>${allpatchquantity}</b></td>" >> ${REPORT}

for j in $communitylist
do
	content=`cat ${TMP}/${j}_authors | wc -l`
	if [ $content -eq 0 ];then
		echo "<td align=center><b><tt><font color=gray>$content</tt></b></td>" >> ${REPORT}
	else
		echo "<td align=center><b><tt><font color=blue>$content</tt></b></td>" >> ${REPORT}
	fi
	k=`expr $k + 1`
done
echo "</tr>" >> ${REPORT}





num=1
#column_num=
while read line; 
do
        author=`echo $line | awk '{print $1}'`
        #patchquantity=`echo $line | awk '{print $2}'`
        allpatchquantity=`echo $line | awk '{print $2}'`
	echo "<tr>" >> ${REPORT}
	echo "<td align=center><b>${num}</b></td>" >> ${REPORT}
	echo "<td align=center><b>${author}</b></td>" >> ${REPORT}
	echo "<td align=center><b>${allpatchquantity}</b></td>" >> ${REPORT}

	k=3
	for j in $communitylist
	do
		#echo "andy.wangguoli@huawei.com 1  0 9 1" | awk '{print $u}' u="$u"
		content=`echo $line | awk '{print $k}' k=$k`
		#echo "cmd: echo $line | awk '{print $k}'"
		#echo "line=$line ;k=$k; content=$content"
		if [ $content -eq 0 ];then
			echo "<td align=center><b><tt><font color=gray>$content</tt></b></td>" >> ${REPORT}
		else
			echo "<td align=center><b><tt><font color=blue>$content</tt></b></td>" >> ${REPORT}
		fi
		k=`expr $k + 1`
	done

	echo "</tr>" >> ${REPORT}
	num=`expr $num + 1`
done < ${TMP}/all_authorinfosorted

cp ${REPORT} /var/www/html/
