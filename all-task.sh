#!/bin/bash

# Mint资产

num=3
error1="error"
error2="available"

mintAmount=9999
fileName="name.txt"

for graffiti in `cat  ${fileName}`
do
echo "正在做${graffiti}的Mint资产任务"
ironfish config:set blockGraffiti "${graffiti}"
wait
tmp1=`ironfish wallet:mint --metadata="see more here" --name=${graffiti} --amount=${mintAmount} --fee=0.00000001 --confirm`
wait
echo ${tmp1}
mintResult1=$(echo $tmp1 | grep -a "${error1}")
mintResult2=$(echo $tmp1 | grep -a "${error2}")
i=1
while ((++i))
do
if [ -z "${mintResult1}" ] && [ -z "${mintResult2}" ]
then
        echo "${graffiti} Mint资产成功!"
    break
else
    if((i>${num})); then
        echo "${graffiti} Mint资产失败! 已经重试了 ${i} 次重试Mint操作!"
        echo "Mint ${graffiti} failed" >> failed.txt
    break
        fi
    echo "${graffiti} Mint资产失败! 正在执行第 ${i} 次重试Mint操作"
    sleep 20
    tmp1=`ironfish wallet:mint --metadata="see more here" --name=${graffiti} --amount=${mintAmount} --fee=0.00000001 --confirm`
    wait
    echo ${tmp1}
    mintResult1=$(echo $tmp1 | grep -a "${error1}")
    mintResult2=$(echo $tmp1 | grep -a "${error2}")
fi
done
done

# Burn资产

burnAmount=98

for graffiti in `cat  ${fileName}`
do
echo "正在做${graffiti}的Burn资产任务"
ironfish config:set blockGraffiti "${graffiti}"
wait
assetId=`ironfish wallet:balances | grep ${graffiti} | awk {'print $2'}`
wait
tmp2=`ironfish wallet:burn --assetId=${assetId} --amount=${burnAmount} --fee=0.00000001 --confirm`
wait
echo ${tmp2}
burnResult1=$(echo ${tmp2} | grep -a "${error1}")
burnResult2=$(echo ${tmp2} | grep -a "${error2}")
i=1
while ((++i))
do
if [ -z "${burnResult1}" ] && [ -z "${burnResult2}" ]
then
        echo "${graffiti} burn资产成功!"
    break
else
    if((i>${num})); then
        echo "${graffiti} burn资产失败! 已经重试了 ${i} 次重试burn操作!"
        echo "Burn ${graffiti} failed" >> failed.txt
    break
        fi
    echo "${graffiti} burn资产失败! 正在执行第 ${i} 次重试burn操作"
    sleep 20
    tmp2=`ironfish wallet:burn --assetId=${assetId} --amount=${burnAmount} --fee=0.00000001 --confirm`
    wait
    echo ${tmp2}
    burnResult1=$(echo ${tmp2} | grep -a "${error1}")
    burnResult2=$(echo ${tmp2} | grep -a "${error2}")
fi
done
done

# Send资产
sendAmount=89

for graffiti in `cat ${fileName}`
do
echo "正在做 ${graffiti} 的Send资产任务"
ironfish config:set blockGraffiti "${graffiti}"
wait
assetId=`ironfish wallet:balances | grep ${graffiti} | awk {'print $2'}`
wait
tmp3=`ironfish wallet:send -a ${sendAmount} -o 0.00000001 -i ${assetId} -t dfc2679369551e64e3950e06a88e68466e813c63b100283520045925adbe59ca -f default --confirm`
wait
echo ${tmp3}
sendResult1=$(echo $tmp3 | grep -a "${error1}")
sendResult2=$(echo $tmp3 | grep -a "${error2}")
i=1
while ((++i))
do
if [ -z "${sendResult1}" ] && [ -z "${sendResult2}" ]
then
        echo "${graffiti} Send资产成功!"
    break
else
    if((i>${num})); then
        echo "${graffiti} send资产失败! 已经重试了 ${i} 次重试send操作!"
        echo "Send ${graffiti} failed" >> failed.txt
    break
        fi
    echo "${graffiti} send资产失败! 正在执行第 ${i} 次重试send操作"
    sleep 20
    tmp3=`ironfish wallet:send -a ${sendAmount} -o 0.00000001 -i ${assetId} -t dfc2679369551e64e3950e06a88e68466e813c63b100283520045925adbe59ca -f default --confirm`
    wait
    echo ${tmp3}
    sendResult1=$(echo $tmp3 | grep -a "${error1}")
    sendResult2=$(echo $tmp3 | grep -a "${error2}")
fi
done
done