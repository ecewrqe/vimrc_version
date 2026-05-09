#!/bin/bash
set -e
show_usage() {
    echo "使用方法:"
    echo " $0 [オプション]"
    echo ""
    echo "オプション:"
    echo "  --dry-run, -n  実際削除せずに削除対象を表示"
    echo "  --exclude, -e 除外するブランチ(複数指定可能)"
    echo "  --pattern, -p 削除するブランチのパターン"
    echo "  --help, -h  このヘルプを表示"
    echo ""
    echo "例:"
    echo "  $0 --dry-run  # 削除対象を確認"
    echo "  $0 -e main -e develop -e staging # main, develop, stagingを除外"
    echo "  $0 -p 'feature/*' -e main     # feature/*を削除、mainは除外"
    echo "  $0 -p 'hotfix/*' -p 'bugfix/*'  # hotfix/*とbugfix/*を削除"
}

DRY_RUN=false
EXCLUDE_BRANCHES=("main" "master" "develop" "staging" "production")

PATTERNS=()
REMOTE="origin"

while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run|-n)
            DRY_RUN=true
            shift
            ;;
        --exclude|-e)
            EXCLUDE_BRANCHES+=("$2")
            shift 2
            ;;
        --pattern|-p)
            PATTERNS+=("$2")
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
        *)
            echo "error: unknown argument: $1"
            show_usage
            exit 1
            ;;
    esac
done

echo "リモートブランチ削除スクリプト"
echo "リモート: $REMOTE"
echo "除外ブランチ: ${EXCLUDE_BRANCHES[*]}"

echo "リモートブランチ情報を更新中..."
git fetch $REMOTE --prune

echo "リモートブランチ一覧を取得中..."
REMOTE_BRANCHES=$(git branch -r | grep "$REMOTE/" | sed "s|$REMOTE/||" | grep -v "HEAD")

DELETE_BRANCHES=()

if [ ${#PATTERNS[@]} -eq 0 ]; then
    # パターン指定がない場合、全ブランチから除外ブランチを除く
    for branch in $REMOTE_BRANCHES; do
        SHOULD_EXCLUDE=false
        for exclude in "${EXCLUDE_BRANCHES[@]}"; do
            if [[ "$branch" == "$exclude" ]]; then
                SHOULD_EXCLUDE=true
                break
            fi
        done

        if [ "$SHOULD_EXCLUDE" = false ]; then
            DELETE_BRANCHES+=("$branch")
        fi
    done
else
    for pattern in "${PATTERNS[@]}"; do
        for branch in $REMOTE_BRANCHES; do
            if [[ "$branch" == $pattern ]]; then
                SHOULD_EXCLUDE=false
                for exclude in "${EXCLUDE_BRANCHES[@]}"; do
                    if [[ "$branch" == "$exclude" ]]; then
                        SHOULD_EXCLUDE=true
                        break
                    fi
                done

                if [ "$SHOULD_EXCLUDE" = false ]; then
                    DELETE_BRANCHES+=("$branch")
                fi
            fi
        done
    done
fi

# 削除対象ブランチを表示
echo ""
echo "削除対象ブランチ (${#DELETE_BRANCHES[@]}個):"
if [ ${#DELETE_BRANCHES[@]} -eq 0 ]; then
    echo "削除対象のブランチはありません"
    exit 0
fi

for branch in "${DELETE_BRANCHES[@]}"; do
    echo "  - $REMOTE/$branch"
done

echo ""

# Dry run モードの場合
if [ "$DRY_RUN" = true ]; then
    echo "[DRY RUN]実際の削除は行いません"
    echo ""
    echo "実際の削除するには以下のコメンどを実行:"
    for branch in "${DELETE_BRANCHES[@]}"; do
        echo "  git push $REMOTE --delete $branch"
    done
    exit 0
fi

echo "警告: 上記のリモートブランチが削除されます"
echo "この操作は元に戻せません"
echo ""
read -p "続行しますか? (y/N): " -n 1 -r
echo ""

if [[ ! $REPLAY =~ ^[Yy]$ ]]; then
    echo "操作をキャンセルしました"
    echo 0
fi

echo ""
echo "リモートブランチを削除中..."

DELETED_COUNT=0
FAILED_COUNT=0

for branch in "${DELETE_BRANCHES[@]}"; do
    echo -n "  削除中: $REMOTE/$branch ... "
    if git push $REMOTE --delete "$branch" 2>/dev/null; then
        echo "完了"
        ((DELETED_COUNT++))
    else
        echo "失敗"
        ((FAILED_COUNT++))
    fi
done

echo ""
echo "削除結果:"
echo "  成功: $DELETED_COUNT 個"
echo "  失敗: $FAILED_COUNT 個"

echo ""
echo " ローカルのリモート追跡ブランチをクリーンアップ中..."
git remote prune $REMOTE

echo ""
echo "完了"
