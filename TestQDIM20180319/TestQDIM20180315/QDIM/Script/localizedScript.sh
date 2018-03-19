#! /bin/bash
# cat BY**.m | grep -o 'BY.*LocalizedStr' | sort -u
# scriptSelfPath: ./BaiYouSDK/Script
#echo "---${PROJECT_DIR}"

#脚本路径：$BYCompanyProject/BaiYouSDK/Script
#运行时指定模块名称，执行EXP： `./localizedScript.sh BYShareKit`

set -e
cd ../Classes
BYROOT_PATH=`pwd`
BYMODEL_PATH=""
BYLANG_STR_FILE_PATH=""
BYLANG_IMG_FILE_PATH=""
BYLOCALIZED_KEY_STRING="$@Localized"

function helpInfo() {

    echo -e "\nERROR:无效参数,请传入正确的模块名称;\n  模块名称: ${BYROOT_PATH}路径下,一级文件夹名称；\n  EXP: ./localizedScript.sh BYShareKit\n"
    return 1;
}

if [ $# -eq 0 ]; then
    helpInfo;
    exit 1;
fi


function doLocalizedString() {

echo -e "/*\n  Created by paulus on 01242017.\n  Copyright © 2017年 www.qdingnet.com.\n  All rights reserved.\n\n*/" > ${BYLANG_STR_FILE_PATH}

find ${BYMODEL_PATH} -name "*.m" -o -name "*.mm" -o -name "*.h" | xargs cat | awk -F '${BYLOCALIZED_KEY_STRING}' '{for(i=1;i<=NF;i++){if($i~/Str\(@"/){split($i,a,"Str\\(@");print a[2]}}}' | sed 's/\(.*\)")\(.*\)/\1"BYEnd\2/' | awk -F "BYEnd" '{print $1;}' | awk '{print $0,"=",$0,";"}' | awk '!a[$0]++;' >> ${BYLANG_STR_FILE_PATH}

echo -e "/*\n  Created by paulus on 01242017.\n  Copyright © 2017年 www.qdingnet.com.\n  All rights reserved.\n\n*/" > ${BYLANG_IMG_FILE_PATH}

find ${BYMODEL_PATH} -name "*.m" -o -name "*.mm" -o -name "*.h" | xargs cat | awk -F '${BYLOCALIZED_KEY_STRING}' '{for(i=1;i<=NF;i++){if($i~/Img\(@"/){split($i,a,"Img\\(@");print a[2]}}}' | sed 's/\(.*\)")\(.*\)/\1"BYEnd\2/' | awk -F "BYEnd" '{print $1;}' | awk '{print $0,"=",$0,";"}' | awk '!a[$0]++;' >> ${BYLANG_IMG_FILE_PATH}

echo -e "\n${BYLANG_STR_FILE_PATH} 文字语言字符串Localized Success! \n"
echo -e "${BYLANG_IMG_FILE_PATH} 图片名称字符串Localized Success! \n"
}

for arg in "$@"
do
    if [ $# -ge 2 ]; then
        helpInfo;
        return 1;
    fi

    BYMODEL_PATH="${BYROOT_PATH}/$@"
    if [ -d "${BYMODEL_PATH}" ];then
        TARGET_NUM=`find ${BYMODEL_PATH} -name "zh-Hans.lproj" | wc -l`
        if [[ ${TARGET_NUM} -ge 2 ]]; then
            echo -e "\n ERROR:${BYMODEL_PATH}目录下检测到${TARGET_NUM}个语言文件路径，请核查！\n"
            exit 1
        else
            if [[ ${TARGET_NUM} -eq 0 ]]; then
                mkdir ${BYMODEL_PATH}/Resource/zh-Hans.lproj
                mkdir ${BYMODEL_PATH}/Resource/en.lproj
            fi
            BYLANG_FILE_DIRECT=`find ${BYMODEL_PATH} -name "zh-Hans.lproj"`

            BYLANG_STR_FILE_PATH="${BYLANG_FILE_DIRECT}/Language.strings"

            BYLANG_IMG_FILE_PATH="${BYLANG_FILE_DIRECT}/Image.strings"

            doLocalizedString;
        fi
    else
        helpInfo;
    fi
done
