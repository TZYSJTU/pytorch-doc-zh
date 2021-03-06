#!/bin/bash
loginfo() { echo "[INFO] $@"; }
logerror() { echo "[ERROR] $@" 1>&2; }

python3 src/script.py "home" "book"
rm -rf node_modules/gitbook-plugin-tbfed-pagefooter
gitbook install
python3 src/script.py "home" "powered"
python3 src/script.py "home" "gitalk"
gitbook build ./ _book
# python3 src/script.py "home" "index"

versions="0.2 0.3 0.4 1.0"
for version in $versions;do
    loginfo "==========================================================="
    loginfo "开始", ${version}, "版本编译"

    echo "cp book.json docs/${version}"
    cp book.json docs/${version}

    # 替换 book.json 的编辑地址
    echo "python3 src/script.py ${version} book"
    python3 src/script.py ${version} "book"

    echo "rm -rf docs/${version}/node_modules/gitbook-plugin-tbfed-pagefooter"
    rm -rf docs/${version}/node_modules/gitbook-plugin-tbfed-pagefooter

    echo "gitbook install docs/${version}"
    gitbook install docs/${version}

    echo "python3 src/script.py ${version} powered"
    python3 src/script.py ${version} "powered"

    echo "python3 src/script.py ${version} gitalk"
    python3 src/script.py ${version} "gitalk"

    echo "gitbook build docs/${version} _book/docs/${version}"
    gitbook build docs/${version} _book/docs/${version}

    # 注释多余的内容
    # echo "python3 src/script.py ${version} index"
    # python3 src/script.py ${version} "index"
done

# rm -rf /opt/apache-tomcat-9.0.17/webapps/test_book
# cp -r _book /opt/apache-tomcat-9.0.17/webapps/test_book
