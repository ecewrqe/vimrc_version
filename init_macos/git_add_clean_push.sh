#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

show_usage() {
    echo -e "${BLUE}使用方法:${NC}"
    echo "  $0 [オプション] [コミットメッセージ]"
    echo ""
    echo -e "${BLUE}オプション:${NC}"
    echo "  --include, -i  追加する拡張子(複数指定可)"
    echo "  --exclude, -e  除外するファイル/ディレクトリ"
    echo "  --clean-cache  Git キャッシュをクリア"
    echo "  --clean-build  ビルドファイルを削除"
    echo "  --clean-all    すべてのキャッシュを削除"
    echo "  --dry-run, -n  実際に実行せずに確認のみ"
    echo "  --force, -f    強制実行(確認スキップ)"
    echo "  --branch, -b   プッシュするブランチ指定"
    echo "  --remote, -r   リモート名指定 (デフォルト: origin)"
    echo "  --help, -h     このヘルプを表示"
    echo ""
    echo -e "${BLUE}例:${NC}"
    echo "  $0 -i .rb -i .yml --clean-cache 'Update Ruby files'"
    echo "  $0 -i .js -i .css -e node_modules --clean-build 'Frontend updates'"
    echo "  $0 --clean-all -f 'Clean and update all files'"
    echo "  $0 --dry-run 'Test commit message'"
}

INCLUDE_EXTENSIONS=()
EXCLUDE_PATTERNS=()
CLEAN_CACHE=false
CLEAN_BUILD=false
CLEAN_ALL=false
DRY_RUN=false
FORCE=false
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
REMOTE="origin"
COMMIT_MESSAGE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --include|-i)
            INCLUDE_EXTENSIONS+=("$2")
            shift 2
            ;;
        --exclude|-e)
            EXCLUDE_PATTERNS+=("$2")
            shift 2
            ;;
        --clean-cache)
            CLEAN_CACHE=true
            shift
            ;;
        --clean-build)
            CLEAN_BUILD=true
            shift
            ;;
        --clean-all)
            CLEAN_ALL=true
            shift
            ;;
        --dry-run|-n)
            DRY_RUN=true
            shift
            ;;
        --force|-f)
            FORCE=true
            shift
            ;;
        --branch|-b)
            BRANCH="$2"
            shift 2
            ;;
        --remote|-r)
            REMOTE="$2"
            shift 2
            ;;
        --help|-h)
            show_usage
            exit 0
            ;;
        -*)
            echo -e "${RED}エラー: 不明なオプション $1${NC}"
            show_usage
            exit 1
            ;;
        *)
            COMMIT_MESSAGE="$1"
            shift
            ;;
    esac
done

# コミットメッセージが未指定の場合
if [ -z "$COMMIT_MESSAGE" ]; then
    echo -e "${YELLOW}コミットメッセージを入力してください:${NC}"
    read -r COMMIT_MESSAGE
    if [ -z "$COMMIT_MESSAGE" ]; then
        echo -e "${RED}エラー: コミットメッセージが必要です${NC}"
        exit 1
    fi
fi

# 実行関数
execute_command() {
    local cmd="$1"
    local description="$2"

    echo -e "${BLUE}$description${NC}"
    echo -e "${YELLOW}実行: $cmd${BC}"

    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}[DRY RUN] 実際には実行されません${NC}"
        return 0
    fi

    if eval "$cmd"; then
        echo -e "${GREEN} 成功: $description${NC}"
        return 0
    else
        echo -e "${RED} 失敗: $description${NC}"
        return 1
    fi
}

clean_caches() {
    echo -e "${BLUE}キャッシュクリア開始${NC}"

    if [ "$CLEAN_CACHE" = true ] || [ "$CLEAN_ALL" = true ]; then
        if [ -d "node_modules" ]; then
            execute_command "rm -fr node_modules" "node_modules ディレクトリ削除"
        fi
        if [ -f "package-lock.json" ]; then
            execute_command "rm -f package-lock.json" "package-lock.json 削除"
        fi
        # Ruby
        if [ -d "vendor" ]; then
            execute_command "rm -fr vendor" "vendor ディレクトリ削除"
        fi

        if [ -f "Gemfile.lock" ]; then
            execute_command "git rm --cached Gemfile.lock" "Gemfile.lock の Git キャッシュ削除"
        fi

        # Python
        if [ -d "__pycache__" ]; then
            execute_command "find . -name '__pycache__' -exec rm -fr {} +" "__pycache__ ディレクトリ削除"
        fi

        # Go
        if [ -d "vendor" ] && [ -f "go.mod" ]; then
            execute_command "rm -fr vendor" "Go の vendor ディレクトリ削除"
        fi

        # その他
        for dir in build dist tmp log coverage; do
            if [ -d "$dir" ]; then
                execute_command "rm -fr $dir" "$dir ディレクトリ削除"
            fi
        done
    fi

    if [ "$CLEAN_ALL" = true ]; then
        if command -v docker &> /dev/null; then
            execute_command "docker system prune -f" "Docker システムのクリーンアップ"
        fi

        if command -v yarn &> /dev/null; then
            execute_command "yarn cache clean" "Yarn キャッシュクリア"
        fi

        if command -v npm &> /dev/null; then
            execute_command "npm cache clean --force" "npm キャッシュクリア"
        fi

        if command -v pip &> /dev/null; then
            execute_command "pip cache purge" "pip キャッシュクリア"
        fi

        if command -v bundle &> /dev/null; then
            execute_command "bundle clean --force" "Bundler キャッシュクリア"
        fi
    fi
}

add_files() {
    echo -e "${BLUE} ファイル追加開始${NC}"

    if [ ${#INCLUDE_EXTENSIONS[@]} -eq 0 ]; then
        execute_command "git add ." "すべての変更を追加"
    else
        for ext in "${INCLUDE_EXTENSIONS[@]}"; do
            if [[ "$ext" != .* ]]; then
                ext=".$ext"
            fi

            find_cmd="find . -name '*$ext' -type f"

            for exclude in "${EXCLUDE_PATTERNS[@]}"; do
                find_cmd="$find_cmd ! -path '*/$exclude/*' ! -name '$exclude'"
            done

            execute_command "$find_cmd -exec git add {} +" "拡張子 $ext のファイルを追加"
        done
    fi
}

main() {
    echo -e "${GREEN} Git自動化スクリプト開始${NC}"
    echo -e "${BLUE}ブランチ: $BRANCH${NC}"
    echo -e "${BLUE}リモート: $REMOTE${NC}"
    echo -e "${BLUE}コミットメッセージ: $COMMIT_MESSAGE${NC}"
    echo ""

    echo -e "${BLUE}現在の Git ステータス:${NC}"
    git status --short
    echo ""

    if [ "$FORCE" = false ] && [ "$DRY_RUN" = false ]; then
        echo -e "${YELLOW}続行しますか? (y/N):${NC}"
        read -r confirm
        if [[ ! $confirm =~ ^[Yy]$ ]]; then
            echo -e "${YELLOW}キャンセルしました${NC}"
            exit 0
        fi

        if [ "$CLEAN_CACHE" = true ] || [ "$CLEAN_BUILD" = true ] || [ "$CLEAN_BUILD" = true ]; then
            clean_caches
            echo ""
        fi

        add_files
        echo ""

        execute_command "git commit -m \"$COMMIT_MESSAGE\"" "変更をコミット"
        echo ""

        echo -e "${GREEN}全ての操作が完了しました${NC}"
    fi
}

main
