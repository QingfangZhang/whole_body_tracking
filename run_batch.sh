#!/bin/bash

# 1. 设置你的 CSV 文件夹路径
INPUT_DIR="/root/gpufree-data/zqf/LAFAN1_Retargeting_Dataset/g1"

if [ ! -d "$INPUT_DIR" ]; then 
	echo "错误: 目录 $INPUT_DIR 不存在！" 
	exit 1 
fi

# 2. 循环遍历文件夹下所有的 .csv 文件
for file in $INPUT_DIR/*.csv; do
    # 获取文件名（不带路径和后缀）作为 output_name
    filename=$(basename "$file")  # basename用于去掉路径前缀，只保留文件名
    motion_name="${filename%.*}"  # 删掉一个点以及后面的内容，这样可以去掉.csv

    echo "------------------------------------------------"
    echo "正在处理动作: $motion_name"
    echo "文件路径: $file"
    echo "------------------------------------------------"

    # 3. 调用你的 Python 脚本
    # 假设你的脚本接受 --input_file 和 --output_name 参数
    python scripts/csv_to_npz.py --input_file "$file" --output_name "$motion_name" --headless

    # 4. (可选) 检查上一个命令是否成功，如果不成功可以停止
    if [ $? -ne 0 ]; then    # $?是退出状态码，成功返回0，失败返回非0， -ne：not equal
        echo "错误：$motion_name 处理失败，停止运行。"
        exit 1
    fi
done

echo "所有动作转换完成！"
