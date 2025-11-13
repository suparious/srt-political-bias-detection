#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Build and push Political Bias Detection Docker images (frontend + backend)

.DESCRIPTION
    Builds multi-stage Docker images for the Political Bias Detection application:
    - Frontend: React SPA with nginx
    - Backend: Flask API with PyTorch and Transformers

    Supports cross-platform execution (WSL2 + Windows)

.PARAMETER Login
    Perform Docker Hub login before building

.PARAMETER Push
    Push images to Docker Hub after building

.PARAMETER Frontend
    Build only the frontend image

.PARAMETER Backend
    Build only the backend image

.EXAMPLE
    .\build-and-push.ps1
    Build both images locally

.EXAMPLE
    .\build-and-push.ps1 -Login -Push
    Login, build, and push both images

.EXAMPLE
    .\build-and-push.ps1 -Frontend -Push
    Build and push only the frontend image

.NOTES
    Author: Shaun Prince
    Generated with Claude Code
#>

[CmdletBinding()]
param(
    [switch]$Login,
    [switch]$Push,
    [switch]$Frontend,
    [switch]$Backend
)

#region Configuration
$ErrorActionPreference = "Stop"

# Docker Hub configuration
$dockerHubUsername = "suparious"
$frontendImageName = "political-bias-detection-frontend"
$backendImageName = "political-bias-detection-backend"
$imageTag = "latest"

# Cross-platform path handling
$scriptPath = $PSScriptRoot
if (-not $scriptPath) {
    $scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
}

# Determine repository root (3 levels up: apps/political-bias-detection -> apps -> manifests -> root)
$repoRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $scriptPath))

# Color output functions
function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

function Write-Success { Write-ColorOutput Green @args }
function Write-Info { Write-ColorOutput Cyan @args }
function Write-Warning { Write-ColorOutput Yellow @args }
function Write-Error { Write-ColorOutput Red @args }

#endregion

#region Functions

function Test-DockerLogin {
    Write-Info "`nChecking Docker authentication..."

    $loginStatus = docker info 2>&1 | Select-String "Username"
    if (-not $loginStatus) {
        Write-Warning "Not logged in to Docker Hub"
        return $false
    }

    Write-Success "Docker authentication verified"
    return $true
}

function Invoke-DockerLogin {
    Write-Info "`nLogging in to Docker Hub..."
    docker login
    if ($LASTEXITCODE -ne 0) {
        throw "Docker login failed"
    }
    Write-Success "Docker login successful"
}

function Build-Image {
    param(
        [string]$ImageName,
        [string]$Dockerfile,
        [string]$Context
    )

    $fullImageName = "$dockerHubUsername/${ImageName}:$imageTag"

    Write-Info "`nBuilding image: $fullImageName"
    Write-Info "Dockerfile: $Dockerfile"
    Write-Info "Context: $Context"

    docker build `
        -f $Dockerfile `
        -t $fullImageName `
        $Context

    if ($LASTEXITCODE -ne 0) {
        throw "Build failed for $ImageName"
    }

    Write-Success "Build successful: $fullImageName"
    return $fullImageName
}

function Push-Image {
    param(
        [string]$ImageName
    )

    Write-Info "`nPushing image: $ImageName"
    docker push $ImageName

    if ($LASTEXITCODE -ne 0) {
        throw "Push failed for $ImageName"
    }

    Write-Success "Push successful: $ImageName"
}

#endregion

#region Main Script

try {
    Write-Info "========================================="
    Write-Info "Political Bias Detection - Build & Push"
    Write-Info "========================================="

    # Default to building both if neither specified
    if (-not $Frontend -and -not $Backend) {
        $Frontend = $true
        $Backend = $true
    }

    # Docker login if requested
    if ($Login) {
        Invoke-DockerLogin
    }

    # Verify authentication if pushing
    if ($Push -and -not (Test-DockerLogin)) {
        Write-Warning "Docker push requested but not authenticated"
        Write-Info "Run with -Login flag or manually run: docker login"
        exit 1
    }

    $builtImages = @()

    # Build frontend
    if ($Frontend) {
        $frontendImage = Build-Image `
            -ImageName $frontendImageName `
            -Dockerfile (Join-Path $scriptPath "Dockerfile.frontend") `
            -Context $scriptPath

        $builtImages += $frontendImage

        if ($Push) {
            Push-Image -ImageName $frontendImage
        }
    }

    # Build backend
    if ($Backend) {
        $backendImage = Build-Image `
            -ImageName $backendImageName `
            -Dockerfile (Join-Path $scriptPath "Dockerfile.backend") `
            -Context $scriptPath

        $builtImages += $backendImage

        if ($Push) {
            Push-Image -ImageName $backendImage
        }
    }

    # Summary
    Write-Info "`n========================================="
    Write-Success "Build Summary"
    Write-Info "========================================="

    foreach ($image in $builtImages) {
        Write-Success "  ✓ $image"
    }

    if ($Push) {
        Write-Success "`nImages pushed to Docker Hub successfully!"
    } else {
        Write-Info "`nImages built successfully (not pushed)"
        Write-Info "To push images, run: .\build-and-push.ps1 -Push"
    }

    Write-Info "`nNext steps:"
    Write-Info "  - Deploy to Kubernetes: .\deploy.ps1"
    Write-Info "  - Test locally: docker run -p 8080:80 $dockerHubUsername/${frontendImageName}:$imageTag"
    Write-Info "  - Test backend: docker run -p 5000:5000 $dockerHubUsername/${backendImageName}:$imageTag"

} catch {
    Write-Error "`n✗ Build failed: $_"
    exit 1
}

#endregion
