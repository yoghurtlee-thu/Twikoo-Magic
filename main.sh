#! /usr/bin/env zsh

input_dir="image-origin"
output_dir="image"

find "$input_dir" -type f \( -iname '*.webp' -o -iname '*.webp' -o -iname '*.jpeg' -o -iname '*.webp' \) | while read -r file; do
    # 获取相对路径
    relative_path="${file#$input_dir/}"
    # 获取文件名和目录
    dir_name=$(dirname "$relative_path")
    base_name=$(basename "$relative_path" | sed 's/\.[^.]*$//')
    
    # 创建输出目录
    mkdir -p "$output_dir/$dir_name"
    
    # 检查文件扩展名
    extension="${file##*.}"
    if [[ "$extension" == "gif" ]]; then
        # 转换为YUV格式并编码为WebP格式，保持动画效果
        if ffmpeg -i "$file" -pix_fmt yuv420p -c:v libwebp -q:v 75 -loop 0 "$output_dir/$dir_name/$base_name.webp"; then
            echo "Converted $file to $output_dir/$dir_name/$base_name.webp"
        else
            echo "Failed to convert $file" >&2
        fi
    else
        # 转换为YUV格式并编码为WebP格式
        if ffmpeg -i "$file" -pix_fmt yuv420p -c:v libwebp -q:v 75 "$output_dir/$dir_name/$base_name.webp"; then
            echo "Converted $file to $output_dir/$dir_name/$base_name.webp"
        else
            echo "Failed to convert $file" >&2
        fi
    fi
done