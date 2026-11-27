# ragflow-research

一个独立的 RAGFlow 研究仓库，用于沉淀对 RAGFlow 架构、源码实现、技术选型与设计方案的深度研究报告。项目通过只读 Git submodule 固定指向官方 RAGFlow 的最新稳定发布版。

本仓库仅用于研究报告、架构分析与设计方案，不用于扩展开发、上游缺陷追踪（issues）或维护代码分支。

## 研究基线

- RAGFlow：[`v1.0.0`](https://github.com/infiniflow/ragflow/releases/tag/v1.0.0)，提交 `db1cd5929a7885a3074547791f5ecc4d2f891739`。
- 以只读纯净 submodule 形式记录在 `upstream/ragflow/`。

克隆本项目后初始化 submodule：

```sh
git submodule update --init
```

检查或升级 submodule 到远端最新稳定版（匹配 `vX.Y.Z`，自动过滤 `-rc*` 与 `dev-*` 标签）：

```sh
./scripts/sync-latest-stable.sh --check
./scripts/sync-latest-stable.sh
```

## 原则与规则

- **全中文规范**：本仓库内所有文档、报告、说明与注释统一使用简体中文，不维护英文副本。
- **上游只读**：严禁修改 `upstream/ragflow/` 下的任何文件（`git status --porcelain` 必须始终为空）。
- **证据优先**：每一条关于 RAGFlow 行为的判断都应锚定到 `upstream/ragflow/` 中的具体相对文件路径、符号名或行号，必要时附带可复现命令或实验数据。
- **标明研究基线**：每份报告顶部标明所基于的 RAGFlow Release tag 与 commit SHA，便于后续基线升级时核验结论是否仍然成立。
- **事实与判断分离**：明确区分“源码实测事实”与“架构建议 / 选型判断”。
- **提交规范**：Git 提交信息统一使用简体中文，每行显示宽度不超过 80 列。

## 目录结构

```text
文档目录.md         所有研究报告与架构设计文档的集中索引
reports/           深度研究报告、能力盘点与基准评测分析
designs/           架构设计方案、技术选型对比与权衡复盘
scripts/           辅助脚本（如同步 upstream/ragflow 到最新稳定版）
upstream/ragflow/  指向最新稳定版的官方 RAGFlow submodule
```

完整文档列表见 [文档目录](文档目录.md)。

## 许可证

本仓库采用 [MIT 许可证](LICENSE)（`upstream/ragflow/` 子模块沿用 RAGFlow 官方自身许可证）。
