#!/bin/bash
i=0
allCount=0
echo -e "\n"

# 将ssuers的端口存入数组 ports
for line in `cat ssusers| awk 'NR>3 {print $1}'`
do
    ports[${i}]=$line
    let i=${i}+1
done

# 遍历端口，查询此端口正在使用着的ip
for port in ${ports[@]}
do
    # 将查到的ip地址加入到 ips 数组
    for line in `netstat -anp |grep ESTABLISHED |grep python|grep $port |awk '{print $5}' |awk -F ":" '{print $1}'| sort -u`
    do
        ips[${i}]=$line
        let i=${i}+1
    done

    # ips 数组的长度不为零，则输出对应的 ip信息
    if [ ${#ips[@]} -gt 0 ]
    then
        echo "[端口：$port]"
        for ip in ${ips[@]}
        do
            # 查询ip信息
            curl https://ip.cn?ip=$ip
            let allCount=${allCount}+1
        done
        echo '——————————————————————————————————————————————'
    fi

    # 清空 ips 数组，初始化下标 i
    unset ips
    i=0
done

echo -e "\n当前在线人数：${allCount} 人\n"
