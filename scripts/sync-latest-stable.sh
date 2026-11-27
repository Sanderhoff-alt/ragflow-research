#!/usr/bin/env bash
set -euo pipefail

# 将 upstream/ragflow submodule 同步到远端最新稳定语义化版本标签（vX.Y.Z）。
# 自动排除预发布与开发标签（例如 v1.0.0-rc3、dev-YYYYMMDD）。
#
# 用法：
#   ./scripts/sync-latest-stable.sh          # 检查并切换 submodule 到最新稳定版（不自动提交）
#   ./scripts/sync-latest-stable.sh --check  # 仅检查当前基线与远端最新稳定版，不修改任何文件

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SUBMODULE_DIR="${REPO_ROOT}/upstream/ragflow"
REMOTE_URL="$(git -C "${REPO_ROOT}" config --file .gitmodules --get submodule.upstream/ragflow.url)"

CHECK_ONLY=false
if [[ "${1:-}" == "--check" ]]; then
  CHECK_ONLY=true
elif [[ -n "${1:-}" ]]; then
  echo "用法: $0 [--check]" >&2
  exit 2
fi

if [[ ! -d "${SUBMODULE_DIR}/.git" && ! -f "${SUBMODULE_DIR}/.git" ]]; then
  echo "Submodule 尚未初始化，请先执行：git submodule update --init" >&2
  exit 1
fi

CURRENT_COMMIT="$(git -C "${SUBMODULE_DIR}" rev-parse HEAD)"
CURRENT_TAG="$(git -C "${SUBMODULE_DIR}" describe --tags --exact-match 2>/dev/null || echo "<untagged>")"

LATEST_TAG="$(
  git ls-remote --tags --refs "${REMOTE_URL}" 'v*' \
    | awk '{print $2}' \
    | sed 's|^refs/tags/||' \
    | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' \
    | sort -V \
    | tail -n 1
)"

if [[ -z "${LATEST_TAG}" ]]; then
  echo "无法从 ${REMOTE_URL} 解析最新稳定版标签" >&2
  exit 1
fi

echo "当前基线  : ${CURRENT_TAG} (${CURRENT_COMMIT})"
echo "最新稳定版: ${LATEST_TAG}"

if [[ "${CURRENT_TAG}" == "${LATEST_TAG}" ]]; then
  echo "当前已是最新稳定版（${LATEST_TAG}）。"
  exit 0
fi

if [[ "${CHECK_ONLY}" == "true" ]]; then
  echo "发现新稳定版：${CURRENT_TAG} -> ${LATEST_TAG}"
  exit 0
fi

git -C "${SUBMODULE_DIR}" fetch --tags origin
git -C "${SUBMODULE_DIR}" checkout --detach "${LATEST_TAG}"
NEW_COMMIT="$(git -C "${SUBMODULE_DIR}" rev-parse HEAD)"

echo "已将 upstream/ragflow 切换至 ${LATEST_TAG} (${NEW_COMMIT})。"
echo "请核对受影响的研究报告、更新 README.md 中的基线记录，然后手动提交。"
