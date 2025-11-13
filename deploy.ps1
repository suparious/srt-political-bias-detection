#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Deploy Political Bias Detection application to Kubernetes

.DESCRIPTION
    Deploys the Political Bias Detection application (frontend + backend) to the srt-hq-k8s cluster.
    Handles namespace creation, deployments, services, and ingress configuration.

.PARAMETER Build
    Build Docker images before deploying

.PARAMETER Push
    Push Docker images to Docker Hub before deploying

.PARAMETER Uninstall
    Remove all Political Bias Detection resources from cluster

.EXAMPLE
    .\deploy.ps1
    Deploy with existing images

.EXAMPLE
    .\deploy.ps1 -Build -Push
    Build, push, and deploy

.EXAMPLE
    .\deploy.ps1 -Uninstall
    Remove all resources

.NOTES
    Author: Shaun Prince
    Generated with Claude Code
#>

[CmdletBinding()]
param(
    [switch]$Build,
    [switch]$Push,
    [switch]$Uninstall
)

#region Configuration
$ErrorActionPreference = "Stop"

$namespace = "political-bias-detection"
$appName = "political-bias-detection"
$k8sPath = Join-Path $PSScriptRoot "k8s"

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

function Invoke-BuildAndPush {
    Write-Info "`nBuilding and pushing Docker images..."

    $buildArgs = @()
    if ($Push) {
        $buildArgs += "-Push"
    }

    & (Join-Path $PSScriptRoot "build-and-push.ps1") @buildArgs

    if ($LASTEXITCODE -ne 0) {
        throw "Build and push failed"
    }
}

function Remove-Deployment {
    Write-Info "`nUninstalling Political Bias Detection..."

    # Delete all resources in namespace
    kubectl delete namespace $namespace --ignore-not-found=true

    Write-Success "Political Bias Detection uninstalled successfully"
}

function Deploy-Application {
    Write-Info "`nDeploying Political Bias Detection..."

    # Apply all manifests
    Write-Info "Applying Kubernetes manifests..."
    kubectl apply -f $k8sPath

    if ($LASTEXITCODE -ne 0) {
        throw "Failed to apply manifests"
    }

    Write-Success "Manifests applied successfully"

    # Wait for rollout
    Write-Info "`nWaiting for frontend deployment rollout..."
    kubectl rollout status deployment/${appName}-frontend -n $namespace --timeout=300s

    Write-Info "`nWaiting for backend deployment rollout..."
    kubectl rollout status deployment/${appName}-backend -n $namespace --timeout=300s

    Write-Success "Deployments rolled out successfully"
}

function Show-Status {
    Write-Info "`n========================================="
    Write-Info "Deployment Status"
    Write-Info "========================================="

    # Pods
    Write-Info "`n--- Pods ---"
    kubectl get pods -n $namespace

    # Services
    Write-Info "`n--- Services ---"
    kubectl get svc -n $namespace

    # Ingress
    Write-Info "`n--- Ingress ---"
    kubectl get ingress -n $namespace

    # Certificate
    Write-Info "`n--- Certificate ---"
    kubectl get certificate -n $namespace

    Write-Info "`n========================================="
    Write-Success "Useful Commands"
    Write-Info "========================================="
    Write-Info "View frontend logs:  kubectl logs -n $namespace -l app=${appName}-frontend -f"
    Write-Info "View backend logs:   kubectl logs -n $namespace -l app=${appName}-backend -f"
    Write-Info "View all resources:  kubectl get all,certificate,ingress -n $namespace"
    Write-Info "Restart frontend:    kubectl rollout restart deployment/${appName}-frontend -n $namespace"
    Write-Info "Restart backend:     kubectl rollout restart deployment/${appName}-backend -n $namespace"
    Write-Info "`nAccess application:  https://political-bias.lab.hq.solidrust.net"
}

#endregion

#region Main Script

try {
    Write-Info "========================================="
    Write-Info "Political Bias Detection - Deployment"
    Write-Info "========================================="

    if ($Uninstall) {
        Remove-Deployment
        exit 0
    }

    # Build and push if requested
    if ($Build -or $Push) {
        Invoke-BuildAndPush
    }

    # Deploy application
    Deploy-Application

    # Show status
    Show-Status

    Write-Info "`n========================================="
    Write-Success "Deployment Complete!"
    Write-Info "========================================="
    Write-Info "`nApplication URL: https://political-bias.lab.hq.solidrust.net"
    Write-Info "`nNote: Certificate may take 1-2 minutes to issue"

} catch {
    Write-Error "`n✗ Deployment failed: $_"
    exit 1
}

#endregion
