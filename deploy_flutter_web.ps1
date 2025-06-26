# deploy_flutter_web.ps1
param(
    [string]$Output = "test_output",
    [string]$GithubUser = "choowx2002"
)

# 构建路径等变量
$BaseHref = "/$Output/"
$GithubRepo = "https://github.com/$GithubUser/$Output"

Write-Host "🚀 开始部署 Flutter Web 项目到 GitHub Pages..."
Write-Host "📁 输出目录: $Output"
Write-Host "🌐 GitHub 仓库: $GithubRepo"
Write-Host "📦 Base Href: $BaseHref"
Write-Host ""

# 步骤 1：清理旧构建
flutter clean

# 步骤 2：获取依赖
flutter pub get

# 步骤 3：启用 Web 平台（避免新项目未启用）
flutter create . --platform web

# 步骤 4：构建 Web 项目
flutter build web --base-href $BaseHref --release

# 步骤 5：读取版本号
$BuildVersion = Select-String 'version:' pubspec.yaml | ForEach-Object { ($_ -split ' ')[1] }

# 步骤 6：Git 初始化并提交到 GitHub
Set-Location build/web
git init
git add .
git commit -m "Deploy Version $BuildVersion"
git branch -M main
git remote add origin $GithubRepo
git push -u -f origin main
Set-Location ../..

# 完成提示
Write-Host ""
Write-Host "✅ 部署完成: $GithubRepo"
Write-Host "🌐 项目已发布至: https://$GithubUser.github.io/$Output/"
