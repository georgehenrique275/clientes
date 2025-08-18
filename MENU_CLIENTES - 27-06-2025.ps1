$ErrorActionPreference = "SilentlyContinue"
$host.ui.RawUI.WindowTitle = "Consulta de Usuário TJPB"
#Set-ExecutionPolicy RemoteSigned
$Global:ScriptPath = Split-Path -Parent $PSCommandPath

# Verifica se está rodando como administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Reiniciando como administrador..." -ForegroundColor Yellow
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$Host.UI.RawUI.WindowTitle = "COSUE SISTEMAS"

function Mostrar-Banner {
    Write-Host "@@@@@@@ @@@@@@@  @@@@@@@  @@@@@@  @@@@@@@ @@@@@@@  " -ForegroundColor Green
    Write-Host "@@@@@@@ @@@@@@@  @@@@@@@  @@@@@@  @@@@@@@ @@@@@@@  " -ForegroundColor Green
    Write-Host "@@      @@@@     @@   @@  @@  @@  @@      @@@@  "-ForegroundColor Green
    Write-Host "@@      @@@@@@@  @@   @@  @@@     @@      @@@@@@@  "-ForegroundColor Green 
    Write-Host "@@   @@ @@       @@   @@  @@ @    @@   @@ @@   " -ForegroundColor Green
    Write-Host "@@@@@@@ @@@@@@@  @@@@@@@  @@  #   @@@@@@@ @@@@@@@  " -ForegroundColor Green
    Write-Host "@@@@@@@ @@@@@@@  @@@@@@@  @@  @@  @@@@@@@ @@@@@@@   " -ForegroundColor Green
    Write-Host "=================================================" 
    Write-Host "          FERRAMENTAS SUPORTE CLIENTES           " -ForegroundColor Red
    Write-Host "-------------------------------------------------"
}

function Pause {
    Read-Host -Prompt "Pressione Enter para continuar..."
}

function Mostrar-Menu {
    do {
        Clear-Host
        Mostrar-Banner
        Write-Host ""
        Write-Host "==== MENU PRINCIPAL ====" -ForegroundColor Red
        Write-Host ""
        Write-Host "  [1] CLIENTES"
        Write-Host "  [2] ADVOGADO"
        Write-Host "  [3] STATUS"
        Write-Host "  [4] BONUS"
        Write-Host "  [S] SAIR" -ForegroundColor Red
        Write-Host ""

        $opcao = Read-Host "Escolha uma opção"
        switch ($opcao) {
            '1' { Mostrar-MenuClientes }
            '2' { Mostrar-Adv }
            '3' { Mostrar-MenuStatus }
            '4' { Mostrar-MenuBonus }
            'S' { Exit }
            default { Write-Host "Opção inválida."; Pause }
        }
    } while ($true)
}


############################################# MENU CLIENTES INICIO ########################################################


function Mostrar-MenuClientes {
    do {
        Clear-Host
        Mostrar-Banner
        Write-Host ""
        Write-Host "  ==== MENU DE CLIENTES ====" -ForegroundColor Red
        Write-Host ""
        Write-Host "  [1] CONECTAR WIFI"
        Write-Host "  [2] ATUALIZAR WINDOWS"
        Write-Host "  [3] GERENCIAMENTO DE PROGRAMAS"
		Write-Host "  [4] GERENCIAMENTO DE IMPRESSORAS"
        Write-Host "  [5] FERRAMENTAS"
        Write-Host "  [V] VOLTAR " -ForegroundColor Yellow -NoNewline
        Write-Host "  [M] MENU "   -ForegroundColor Green -NoNewline
        Write-Host "  [S] SAIR"    -ForegroundColor Red
        Write-Host ""
        $opcao = Read-Host "Escolha uma opÃ§Ã£o"
        switch ($opcao) {
            '1' { WIFI }
            '2' { WindowsUpdate }
            '3' { App-Control }
			'4' { Printer-Management }
            '5' { tools }
            'V' { return }
			'M' {Mostrar-Menu}
			'S' {exit}
            default { Write-Host "OpÃ§Ã£o invÃ¡lida."; Pause }
        }
    } while ($true)
}


function WIFI {
    # Nome da rede e senha
    $nomeRede = "VIVOFIBRA-HENRIQUE-5G"
    $senha = "2018Acesso=="

    # Caminho temporário para o arquivo XML
    $caminhoTemp = "$env:TEMP\$nomeRede.xml"

    # Conteúdo do perfil Wi-Fi
    $xml = @"
<?xml version="1.0"?>
<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1">
    <name>$nomeRede</name>
    <SSIDConfig>
        <SSID>
            <name>$nomeRede</name>
        </SSID>
    </SSIDConfig>
    <connectionType>ESS</connectionType>
    <connectionMode>auto</connectionMode>
    <MSM>
        <security>
            <authEncryption>
                <authentication>WPA2PSK</authentication>
                <encryption>AES</encryption>
                <useOneX>false</useOneX>
            </authEncryption>
            <sharedKey>
                <keyType>passPhrase</keyType>
                <protected>false</protected>
                <keyMaterial>$senha</keyMaterial>
            </sharedKey>
        </security>
    </MSM>
</WLANProfile>
"@

    # Cria o arquivo XML
    $xml | Set-Content -Path $caminhoTemp -Encoding UTF8

    # Adiciona o perfil
    Write-Host "Adicionando perfil Wi-Fi..." -ForegroundColor Cyan
    netsh wlan add profile filename="$caminhoTemp" user=current | Out-Null

    # Conecta à rede
    Write-Host "Conectando à rede $nomeRede..." -ForegroundColor Cyan
    netsh wlan connect name="$nomeRede" | Out-Null

    # Aguarda e mostra status
    Start-Sleep -Seconds 5
    Write-Host "`nStatus da conexão:" -ForegroundColor Green
    netsh wlan show interfaces

    # Remove arquivo temporário
    Remove-Item $caminhoTemp -Force
    read-host "Pressione Qualquer tecla para Sair"
}
function WindowsUpdate {


# Requer execuÃ§Ã£o como administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Execute este script como administrador."
    exit
}

# Habilita o mÃ³dulo de atualizaÃ§Ã£o
Write-Host "Verificando se o mÃ³dulo de atualizaÃ§Ã£o estÃ¡ disponÃ­vel..." -ForegroundColor Cyan
Install-Module PSWindowsUpdate -Force -Confirm:$false -Scope CurrentUser

# Importa o mÃ³dulo
Import-Module PSWindowsUpdate

# Mostra atualizaÃ§Ãµes disponÃ­veis
Write-Host "`nBuscando atualizaÃ§Ãµes disponÃ­veis..." -ForegroundColor Cyan
$updates = Get-WindowsUpdate

if ($updates) {
    Write-Host "`nAtualizaÃ§Ãµes encontradas:" -ForegroundColor Green
    $updates | Format-Table -AutoSize

    # Instala atualizaÃ§Ãµes
    Write-Host "`nInstalando atualizaÃ§Ãµes..." -ForegroundColor Cyan
    Install-WindowsUpdate -AcceptAll -AutoReboot
} else {
    Write-Host "Nenhuma atualizaÃ§Ã£o disponÃ­vel." -ForegroundColor Yellow
}


}
function App-Control {
    do {
        Clear-Host
        Mostrar-Banner
        Write-Host ""
        Write-Host "  ==== CONTROLE DE APLICATIVOS ====" -ForegroundColor Red
        Write-Host ""
		WRITE-HOST "  [1] INSTALAR APLICATIVOS PADRÃƒO"
		WRITE-HOST "  [2] INSTALAR FERRAMENTAS DE MONITORAMENTO E TESTES"
        WRITE-HOST "  [3] DESINSTALAR APLICATIVO"
        WRITE-HOST "  [4] LISTAR APLICATIVOS INSTALADOS"
        WRITE-HOST "  [5] EXECUTAR APLICATIVO COMO ADMINISTRADOR"
        WRITE-HOST "  [6] VER APLICATIVOS EM EXECUÃ‡ÃƒO"
		WRITE-HOST "  [7] CHOCOLATEY"
        Write-Host "  [V] VOLTAR " -ForegroundColor Yellow -NoNewline
        Write-Host "  [M] MENU "   -ForegroundColor Green -NoNewline
        Write-Host "  [S] SAIR"    -ForegroundColor Red
        
        $choice = Read-Host "`nSelecione uma opÃ§Ã£o"
        
        switch ($choice) {
            '1' {
                $scriptDir = $PSScriptRoot
                $programsPath = Join-Path $scriptDir "PROGRAMAS"
                $logFile = Join-Path $scriptDir "instalacao_log.txt"

                function Write-Log {
                    param ([string]$Message)
                    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                    $entry = "[$timestamp] $Message"
                    Add-Content -Path $logFile -Value $entry
                    Write-Host $Message
                }

                $programs = @(
                    @{ Name = "FirefoxSetup139.0.4.msi";       				 Args = "/quiet";                        Exibir = "Firefox" },
                    @{ Name = "FoxitPDFReader20251_L10N_Setup_Prom.exe";     Args = "/silent /VERYSILENT";          Exibir = "Foxit PDF Reader" },
                    @{ Name = "Ggooglechromestandaloneenterprise64.msi";     Args = "/quiet";                        Exibir = "Google Chrome" },
                    @{ Name = "GoogleDriveSetup.exe";     					 Args = "/quiet";                        Exibir = "Google Drive" },
                    @{ Name = "panda-1-1-10.exe";          					 Args = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-"; Exibir = "Panda Antivirus" },
                    @{ Name = "vlc-3.0.21-win64.exe";    			         Args = "/S";                            Exibir = "VLC Media Player" },
                    @{ Name = "winrar-x64-711.exe";      				     Args = "/S";                            Exibir = "WinRAR" }
					@{ Name = "AnyDesk.exe";              					 Args = "/S";                            Exibir = "AnyDesk" }
                )

                function Instalar-Programa {
                    param ($program)
                    $fullPath = Join-Path $programsPath $program.Name

                    if (Test-Path $fullPath) {
                        Write-Log "Iniciando instalaÃ§Ã£o de $($program.Name)..."

                        if ($program.Name.ToLower().EndsWith(".msi")) {
                            $process = Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$fullPath`" $($program.Args)" -Wait -PassThru
                        } else {
                            $process = Start-Process -FilePath $fullPath -ArgumentList $program.Args -Wait -PassThru
                        }

                        if ($process.ExitCode -eq 0) {
                            Write-Log "$($program.Name) instalado com Ãªxito."
                            return $true
                        } else {
                            Write-Log "Erro ao instalar $($program.Name). CÃ³digo de saÃ­da: $($process.ExitCode)"
                            return $false
                        }
                    } else {
                        Write-Log "Arquivo nÃ£o encontrado: $($program.Name)"
                        return $false
                    }
                }

                function Mostrar-MenuProgramas {
                    do {
                        Clear-Host
                        Mostrar-Banner
                        Write-Host ""
                        Write-Host "==== MENU DE INSTALAÃ‡ÃƒO DE PROGRAMAS ===="
                        Write-Host ""

                        for ($i = 0; $i -lt $programs.Count; $i++) {
                            Write-Host "[$($i + 1)] Instalar $($programs[$i].Exibir)"
                        }

                        $opcaoTodos = $programs.Count + 1
                        Write-Host "[$opcaoTodos] Instalar TODOS os programas"
                        Write-Host "[0] Voltar"
                        Write-Host ""

                        $opcao = Read-Host "Escolha uma opÃ§Ã£o"

                        if ($opcao -eq "0") { return }

                        Write-Log "=== InÃ­cio da instalaÃ§Ã£o ==="
                        $startTime = Get-Date
                        $successCount = 0
                        $errorCount = 0

                        if ($opcao -eq "$opcaoTodos") {
                            foreach ($program in $programs) {
                                if (Instalar-Programa $program) { $successCount++ } else { $errorCount++ }
                                Write-Log ""
                            }
                        } elseif ($opcao -as [int] -and $opcao -ge 1 -and $opcao -le $programs.Count) {
                            $index = [int]$opcao - 1
                            if (Instalar-Programa $programs[$index]) { $successCount++ } else { $errorCount++ }
                        } else {
                            Write-Host "OpÃ§Ã£o invÃ¡lida."
                            Read-Host "Pressione Enter para continuar..."
                            continue
                        }

                        $endTime = Get-Date
                        $duration = $endTime - $startTime
                        $durationFormatted = "{0:hh\:mm\:ss}" -f $duration

                        Write-Log "=== Fim da instalaÃ§Ã£o ==="
                        Write-Log "Programas instalados com sucesso: $successCount"
                        Write-Log "Programas com erro ou nÃ£o encontrados: $errorCount"
                        Write-Log "Tempo total gasto: $durationFormatted"
                        Read-Host "Pressione Enter para continuar..."
                    } while ($true)
                }

                # Chamar o menu de instalaÃ§Ã£o
                Mostrar-MenuProgramas
            }
			
			'2' {
                $scriptDir = $PSScriptRoot
                $programsPath = Join-Path $scriptDir "FERRAMENTAS"
                $logFile = Join-Path $scriptDir "instalacao_log_FERRAMENTAS.txt"

                function Write-Log {
                    param ([string]$Message)
                    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                    $entry = "[$timestamp] $Message"
                    Add-Content -Path $logFile -Value $entry
                    Write-Host $Message
                }

                $programs = @(
                    @{ Name = "cpu-z_2.15-en.exe";       			  Args = "/VERYSILENT /NORESTART";                        Exibir = "CPU-Z" },
                    @{ Name = "GPU-Z.2.66.0.exe";                     Args = "/S";                                             Exibir = "GPU-Z" },
                    @{ Name = "hdsentinel_pro_setup.exe";             Args = "/VERYSILENT /NORESTART";                        Exibir = "HARD DISK SENTINEL" },
                    @{ Name = "Listary.exe";     			          Args = "/VERYSILENT /NORESTART";                        Exibir = "LISTARY" },
                    @{ Name = "aida64extreme765.exe";          		  Args = "/VERYSILENT /NORESTART";                        Exibir = "AIDA64" },
                    @{ Name = "PerformanceTest_Windows_x86-64";    	  Args = "/VERYSILENT /NORESTART";                        Exibir = "PEFORMACE TEST" },
                    @{ Name = "PerformanceTest_Windows_x86-64";    	  Args = "/VERYSILENT /NORESTART";                        Exibir = "FUMARK" },
					@{ Name = "PerformanceTest_Windows_x86-64";    	  Args = "/VERYSILENT /NORESTART";                        Exibir = "CRYSTAL DISK MARK" },
					@{ Name = "PerformanceTest_Windows_x86-64";    	  Args = "/VERYSILENT /NORESTART";                        Exibir = "HDWMONITOR" }
                )

                function Instalar-Programa {
                    param ($program)
                    $fullPath = Join-Path $programsPath $program.Name

                    if (Test-Path $fullPath) {
                        Write-Log "Iniciando instalaÃ§Ã£o de $($program.Name)..."

                        if ($program.Name.ToLower().EndsWith(".msi")) {
                            $process = Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$fullPath`" $($program.Args)" -Wait -PassThru
                        } else {
                            $process = Start-Process -FilePath $fullPath -ArgumentList $program.Args -Wait -PassThru
                        }

                        if ($process.ExitCode -eq 0) {
                            Write-Log "$($program.Name) instalado com Ãªxito."
                            return $true
                        } else {
                            Write-Log "Erro ao instalar $($program.Name). CÃ³digo de saÃ­da: $($process.ExitCode)"
                            return $false
                        }
                    } else {
                        Write-Log "Arquivo nÃ£o encontrado: $($program.Name)"
                        return $false
                    }
                }

                function Mostrar-MenuProgramas {
                    do {
                        Clear-Host
                        Mostrar-Banner
                        Write-Host ""
                        Write-Host "==== MENU DE INSTALAÃ‡ÃƒO DE PROGRAMAS ===="
                        Write-Host ""

                        for ($i = 0; $i -lt $programs.Count; $i++) {
                            Write-Host "[$($i + 1)] Instalar $($programs[$i].Exibir)"
                        }

                        $opcaoTodos = $programs.Count + 1
                        Write-Host "[$opcaoTodos] Instalar TODOS os programas"
                        Write-Host "[0] Voltar"
                        Write-Host ""

                        $opcao = Read-Host "Escolha uma opÃ§Ã£o"

                        if ($opcao -eq "0") { return }

                        Write-Log "=== InÃ­cio da instalaÃ§Ã£o ==="
                        $startTime = Get-Date
                        $successCount = 0
                        $errorCount = 0

                        if ($opcao -eq "$opcaoTodos") {
                            foreach ($program in $programs) {
                                if (Instalar-Programa $program) { $successCount++ } else { $errorCount++ }
                                Write-Log ""
                            }
                        } elseif ($opcao -as [int] -and $opcao -ge 1 -and $opcao -le $programs.Count) {
                            $index = [int]$opcao - 1
                            if (Instalar-Programa $programs[$index]) { $successCount++ } else { $errorCount++ }
                        } else {
                            Write-Host "OpÃ§Ã£o invÃ¡lida."
                            Read-Host "Pressione Enter para continuar..."
                            continue
                        }

                        $endTime = Get-Date
                        $duration = $endTime - $startTime
                        $durationFormatted = "{0:hh\:mm\:ss}" -f $duration

                        Write-Log "=== Fim da instalaÃ§Ã£o ==="
                        Write-Log "Programas instalados com sucesso: $successCount"
                        Write-Log "Programas com erro ou nÃ£o encontrados: $errorCount"
                        Write-Log "Tempo total gasto: $durationFormatted"
                        Read-Host "Pressione Enter para continuar..."
                    } while ($true)
                }

                # Chamar o menu de instalaÃ§Ã£o
                Mostrar-MenuProgramas
            }

            '3' {
                $appName = Read-Host "Digite parte do nome do aplicativo"
                $apps = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*,
                                         HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
                    Where-Object { $_.DisplayName -like "*$appName*" } |
                    Select-Object DisplayName, UninstallString

                if ($apps) {
                    $apps | Format-Table -AutoSize
                    $uninstall = Read-Host "Deseja desinstalar algum? (S/N)"
                    if ($uninstall -eq 'S') {
                        $appToRemove = Read-Host "Digite o nome exato do aplicativo"
                        $uninstallString = ($apps | Where-Object { $_.DisplayName -eq $appToRemove }).UninstallString
                        if ($uninstallString) {
                            Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$uninstallString /quiet`"" -Wait
                            Write-Host "Aplicativo $appToRemove desinstalado!" -ForegroundColor Green
                        } else {
                            Write-Host "UninstallString nÃ£o encontrado." -ForegroundColor Red
                        }
                    }
                } else {
                    Write-Host "Nenhum aplicativo encontrado!" -ForegroundColor Red
                }
                Read-Host "Pressione Enter para continuar..."
            }

            '4' {
                Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*,
                                 HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
                    Where-Object { $_.DisplayName } |
                    Select-Object DisplayName, DisplayVersion, Publisher, InstallDate |
                    Sort-Object DisplayName |
                    Format-Table -AutoSize
                Read-Host "Pressione Enter para continuar..."
			}
            '5' {
                $appPath = Read-Host "Digite o caminho completo do aplicativo (ex: C:\app\app.exe)"
                if (Test-Path $appPath) {
                    Start-Process -FilePath $appPath -Verb RunAs
                } else {
                    Write-Host "Caminho nÃ£o encontrado!" -ForegroundColor Red
                }
                Read-Host "Pressione Enter para continuar..."
            }

            '6' {
                Get-Process | Where-Object { $_.MainWindowTitle } |
                    Select-Object Name, MainWindowTitle |
                    Format-Table -AutoSize
                Read-Host "Pressione Enter para continuar..."
            }
			'7' {
				Clear-Host
				# Verifica se está em modo administrador
If (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Este script precisa ser executado como administrador!"
    Pause
    Exit
}

# Verifica se o Chocolatey está no PATH e funcional
function Testar-Choco {
    try {
        $chocoPath = Get-Command choco -ErrorAction Stop | Select-Object -ExpandProperty Source
        return $true
    } catch {
        return $false
    }
}

# Adiciona choco ao PATH se possível
function Corrigir-Path-Choco {
    $chocoBin = "C:\ProgramData\chocolatey\bin"
    if (Test-Path $chocoBin) {
        if (-not ($env:Path -split ";" | Where-Object { $_ -eq $chocoBin })) {
            [Environment]::SetEnvironmentVariable("Path", $env:Path + ";$chocoBin", [System.EnvironmentVariableTarget]::Machine)
            Write-Host "Caminho do Chocolatey adicionado ao PATH. Reinicie o PowerShell." -ForegroundColor Green
            return $true
        }
    }
    return $false
}

# Reinstala o Chocolatey após remover
function Reinstalar-Choco {
    Write-Host "Removendo instalação corrompida do Chocolatey..." -ForegroundColor Yellow
    Stop-Process -Name choco -Force -ErrorAction SilentlyContinue
    Remove-Item -Recurse -Force "C:\ProgramData\chocolatey" -ErrorAction SilentlyContinue
    Write-Host "Reinstalando Chocolatey..." -ForegroundColor Cyan
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# Confere Chocolatey
if (-not (Testar-Choco)) {
    Write-Warning "Chocolatey não está acessível pelo PATH ou não está instalado corretamente."

    if (Corrigir-Path-Choco) {
        Write-Host "Reabra o PowerShell como administrador para continuar." -ForegroundColor Green
        Pause
        Exit
    }

    $op = Read-Host "Deseja tentar reinstalar o Chocolatey? (S/N)"
    if ($op -match "^[sS]") {
        Reinstalar-Choco
    } else {
        Write-Host "Instalação cancelada." -ForegroundColor Red
        Exit
    }
}

# Catálogo de programas por categoria
$catalogo = @{
    "Navegadores" = @{
        "1" = @{ Nome = "Google Chrome"; Pacote = "googlechrome" }
        "2" = @{ Nome = "Mozilla Firefox"; Pacote = "firefox" }
        "3" = @{ Nome = "Opera"; Pacote = "opera" }
        "4" = @{ Nome = "Microsoft Edge"; Pacote = "microsoft-edge" }
    }

    "Ferramentas de Sistema" = @{
        "5" = @{ Nome = "7-Zip"; Pacote = "7zip" }
	#	""  = @{ Nome = "Winrar"; Pacote = "winrar" } 
        "6" = @{ Nome = "CCleaner"; Pacote = "ccleaner" }
        "7" = @{ Nome = "PowerToys"; Pacote = "powertoys" }
        "8" = @{ Nome = "Everything Search"; Pacote = "everything" }
        "9" = @{ Nome = "Revo Uninstaller"; Pacote = "revo-uninstaller" }
        "10" = @{ Nome = "WinDirStat"; Pacote = "windirstat" }
    }

    "Desenvolvimento" = @{
        "11" = @{ Nome = "Visual Studio Code"; Pacote = "vscode" }
        "12" = @{ Nome = "Git"; Pacote = "git" }
        "13" = @{ Nome = "Node.js LTS"; Pacote = "nodejs-lts" }
        "14" = @{ Nome = "Python"; Pacote = "python" }
        "15" = @{ Nome = "Java JDK 17"; Pacote = "temurin17" }
        "16" = @{ Nome = "Notepad++"; Pacote = "notepadplusplus" }
        "17" = @{ Nome = "Postman"; Pacote = "postman" }
        "18" = @{ Nome = "Docker Desktop"; Pacote = "docker-desktop" }
    }

    "Comunicação" = @{
        "19" = @{ Nome = "Zoom"; Pacote = "zoom" }
        "20" = @{ Nome = "Microsoft Teams"; Pacote = "microsoft-teams" }
        "21" = @{ Nome = "Slack"; Pacote = "slack" }
        "22" = @{ Nome = "Telegram Desktop"; Pacote = "telegram" }
        "23" = @{ Nome = "Discord"; Pacote = "discord" }
    }

    "Multimídia" = @{
        "24" = @{ Nome = "VLC Player"; Pacote = "vlc" }
        "25" = @{ Nome = "Spotify"; Pacote = "spotify" }
        "26" = @{ Nome = "OBS Studio"; Pacote = "obs-studio" }
        "27" = @{ Nome = "K-Lite Codec Pack"; Pacote = "klitecodecpackfull" }
    }

    "Produtividade" = @{
        "28" = @{ Nome = "LibreOffice"; Pacote = "libreoffice-fresh" }
        "29" = @{ Nome = "Foxit Reader"; Pacote = "foxitreader" }
        "30" = @{ Nome = "SumatraPDF"; Pacote = "sumatrapdf" }
        "31" = @{ Nome = "Todoist"; Pacote = "todoist" }
        "32" = @{ Nome = "OnlyOffice"; Pacote = "onlyoffice-desktopeditors" }
    }

    "Segurança" = @{
        "33" = @{ Nome = "Malwarebytes"; Pacote = "malwarebytes" }
        "34" = @{ Nome = "Bitwarden"; Pacote = "bitwarden" }
        "35" = @{ Nome = "KeePass"; Pacote = "keepass" }
    }

    "Virtualização e Emuladores" = @{
        "36" = @{ Nome = "VirtualBox"; Pacote = "virtualbox" }
        "37" = @{ Nome = "VMware Workstation Player"; Pacote = "vmwareworkstationplayer" }
        "38" = @{ Nome = "BlueStacks"; Pacote = "bluestacks" }
    }

    "Drivers e Utilitários" = @{
        "39" = @{ Nome = "CPU-Z"; Pacote = "cpu-z" }
        "40" = @{ Nome = "GPU-Z"; Pacote = "gpu-z" }
        "41" = @{ Nome = "HWMonitor"; Pacote = "hwmonitor" }
        "42" = @{ Nome = "Speccy"; Pacote = "speccy" }
        "43" = @{ Nome = "CrystalDiskInfo"; Pacote = "crystaldiskinfo" }
        "44" = @{ Nome = "CrystalDiskMark"; Pacote = "crystaldiskmark" }
    }

    "Outros Utilitários" = @{
        "45" = @{ Nome = "F.lux"; Pacote = "flux" }
        "46" = @{ Nome = "Greenshot"; Pacote = "greenshot" }
        "47" = @{ Nome = "ShareX"; Pacote = "sharex" }
        "48" = @{ Nome = "TeamViewer"; Pacote = "teamviewer" }
        "49" = @{ Nome = "AnyDesk"; Pacote = "anydesk" }
        "50" = @{ Nome = "Rufus"; Pacote = "rufus" }
    }
}



# Exibe a lista de programas
Write-Host "`nProgramas disponíveis para instalação:" -ForegroundColor Cyan

# Ordem fixa de categorias
$ordemCategorias = @(
    "Navegadores",
    "Ferramentas de Sistema",
    "Desenvolvimento",
    "Comunicação",
    "Multimídia",
    "Produtividade",
    "Segurança",
    "Virtualização e Emuladores",
    "Drivers e Utilitários",
    "Outros Utilitários"
)

# Exibição por ordem definida
foreach ($categoria in $ordemCategorias) {
    if ($catalogo.ContainsKey($categoria)) {
        Write-Host "`n[$categoria]" -ForegroundColor Yellow

        # Ordena os programas dentro da categoria pelo ID
        $idsOrdenados = $catalogo[$categoria].Keys | Sort-Object {[int]$_}

        foreach ($id in $idsOrdenados) {
            $item = $catalogo[$categoria][$id]
            Write-Host "  $id - $($item.Nome)"
        }
    }
}






# Solicita seleção
$selecao = Read-Host "`nDigite os números dos programas a instalar separados por vírgula (ex: 1,3,6)"
$idsSelecionados = $selecao -split "," | ForEach-Object { $_.Trim() }

# Instala os pacotes selecionados
foreach ($id in $idsSelecionados) {
    foreach ($categoria in $catalogo.Keys) {
        if ($catalogo[$categoria].ContainsKey($id)) {
            $pacote = $catalogo[$categoria][$id].Pacote
            Write-Host "`nInstalando $pacote..." -ForegroundColor Green
            choco install $pacote -y
        }
    }
}

				
				
				
				
				
			}
			'V' { return }
			'M' {Mostrar-Menu}
        }
		    
			
    } while ($choice -ne 'S')
}

function Printer-Management {
    do {
        Clear-Host
        Mostrar-Banner
        Write-Host ""
        Write-Host "  ==== MENU IMPRESSORAS ====" -ForegroundColor Red
        Write-Host ""
        WRITE-HOST "  [1] LISTAR IMPRESSORAS INSTALADAS"
        WRITE-HOST "  [2] ADICIONAR IMPRESSORA"
        WRITE-HOST "  [3] REMOVER IMPRESSORA"
        WRITE-HOST "  [4] LIMPAR FILA DE IMPRESSÃƒO"
		WRITE-HOST "  [5] MENU PRINCIPAL"
        Write-Host "  [V] VOLTAR " -ForegroundColor Yellow -NoNewline
        Write-Host "  [M] MENU "   -ForegroundColor Green -NoNewline
        Write-Host "  [S] SAIR"    -ForegroundColor Red
        
        $choice = Read-Host "`nSelecione uma opÃ§Ã£o"
        
        switch ($choice) {
            '1' {
                Get-Printer | Select-Object Name, Type, PortName, Shared, Published | Format-Table -AutoSize
                Pause
            }
            '2' {
                $printerName = Read-Host "Digite o nome da impressora"
                $driverName = Read-Host "Digite o nome do driver"
                $portName = Read-Host "Digite a porta (ex: IP_192.168.1.100)"
                $ipAddress = Read-Host "Digite o endereÃ§o IP da impressora"
                
                Add-PrinterPort -Name $portName -PrinterHostAddress $ipAddress
                Add-Printer -Name $printerName -DriverName $driverName -PortName $portName
                Write-Host "Impressora $printerName adicionada com sucesso!" -ForegroundColor Green
                Pause
            }
            '3' {
                $printerName = Read-Host "Digite o nome da impressora para remover"
                Remove-Printer -Name $printerName -ErrorAction Stop
                Write-Host "Impressora $printerName removida com sucesso!" -ForegroundColor Green
                Pause
            }
            '4' {
                Get-Printer | Where-Object { $_.JobCount -gt 0 } | ForEach-Object {
                    Write-Host "Limpando fila da impressora $($_.Name)..."
                    Remove-PrintJob -PrinterName $_.Name -ID *
                }
                Write-Host "Filas de impressÃ£o limpas!" -ForegroundColor Green
                Pause
            }
			'V' { return }
			'M' {Mostrar-Menu}
        }
    } while ($choice -ne 'S')
}
function tools {
    do {
        Clear-Host
        Mostrar-Banner
        Write-Host ""
        Write-Host "  ==== MENU FERRAMENTAS ====" -ForegroundColor Red
        Write-Host ""
        WRITE-HOST "  [1] INFORMAÃ‡Ã•ES DO SISTEMA"
        WRITE-HOST "  [2] OTIMIZAR SISTEMA"
        WRITE-HOST "  [3] DESATIVAR WINSAT-WIN7"
        WRITE-HOST "  [4] GERENCIAMENTO DE DISCO E ARQUIVOS"
        WRITE-HOST "  [5] FERRAMENTAS DE BACKUP"
		WRITE-HOST "  [6] GERENCIAMENTO DE ENERGIA"
		WRITE-HOST "  [7] MENU PRINCIPAL"
        Write-Host "  [V] VOLTAR " -ForegroundColor Yellow -NoNewline
        Write-Host "  [M] MENU "   -ForegroundColor Green -NoNewline
        Write-Host "  [S] SAIR"    -ForegroundColor Red
        WRITE-HOST ""
        $OPCAO = READ-HOST "ESCOLHA UMA OPÃ‡ÃƒO"
        switch ($opcao) {
            '1' { Info-Desk }
            '2' {Otimizador-PCFraco}
            '3' {Winsat}
			'4' { Disk-File }
			'5' { Tools-Bkp }
			'6' { Habilitar-PlanosEnergia }
			'V' { return }
			'M' {Mostrar-Menu}
			'S' {exit}
			            default { Write-Host "OpÃ§Ã£o invÃ¡lida."; Pause }
        }
    } while ($true)
}


function Info-Desk {
Clear-Host
Write-Host "===== INFORMAÇÕES DO SISTEMA =====" -ForegroundColor Cyan
$compInfo = Get-CimInstance Win32_ComputerSystem
$biosInfo = Get-CimInstance Win32_BIOS
$osInfo = Get-CimInstance Win32_OperatingSystem
$baseBoard = Get-CimInstance Win32_BaseBoard
$cpuInfo = Get-CimInstance Win32_Processor

Write-Host "Nome do Computador: $($compInfo.Name)"
Write-Host "Usuário Atual: $([System.Security.Principal.WindowsIdentity]::GetCurrent().Name)"
Write-Host "Marca: $($compInfo.Manufacturer)"
Write-Host "Modelo: $($compInfo.Model)"
Write-Host "Número de Série: $($biosInfo.SerialNumber)"
Write-Host "Versão da BIOS: $($biosInfo.SMBIOSBIOSVersion) - $($biosInfo.Manufacturer)"
Write-Host "Sistema Operacional: $($osInfo.Caption) $($osInfo.Version) $($osInfo.OSArchitecture)"
Write-Host "Data da Instalação: $([Management.ManagementDateTimeConverter]::ToDateTime($osInfo.InstallDate))"
Write-Host "Tempo Ligado (Uptime): $(((Get-Date) - $osInfo.LastBootUpTime).ToString())"

Write-Host "`n===== PROCESSADOR =====" -ForegroundColor Cyan
Write-Host "Nome: $($cpuInfo.Name)"
Write-Host "Descrição: $($cpuInfo.Description)"
Write-Host "Soquete: $($cpuInfo.SocketDesignation)"
Write-Host "Velocidade Máxima: $($cpuInfo.MaxClockSpeed) MHz"
Write-Host "Velocidade Atual: $($cpuInfo.CurrentClockSpeed) MHz"

Write-Host "`n===== MEMÓRIA =====" -ForegroundColor Cyan
$memoryArray = Get-CimInstance Win32_PhysicalMemoryArray
$memModules = Get-CimInstance Win32_PhysicalMemory
$totalRAMGB = [math]::Round(($compInfo.TotalPhysicalMemory / 1GB), 2)
$memUsed = $totalRAMGB - [math]::Round(($osInfo.FreePhysicalMemory * 1KB / 1GB), 2)
$slotsTotal = $memoryArray.MemoryDevices
$slotsUsados = $memModules.Count
$slotsLivres = $slotsTotal - $slotsUsados
$maxMem = [math]::Round($memoryArray.MaxCapacity / 1MB, 0)

Write-Host "Total RAM instalada: ${totalRAMGB} GB"
Write-Host "Em uso: ${memUsed} GB"
Write-Host "Slots usados: $slotsUsados | Livres: $slotsLivres | Total: $slotsTotal"
Write-Host "Máximo suportado: $maxMem GB"

Write-Host "`n===== DISCO =====" -ForegroundColor Cyan
$diskDrives = Get-CimInstance Win32_DiskDrive | Where-Object { $_.MediaType -eq "Fixed hard disk media" }
foreach ($disk in $diskDrives) {
    $particoes = Get-CimAssociatedInstance -InputObject $disk -ResultClassName Win32_LogicalDisk
    foreach ($part in $particoes) {
        $freeGB = [math]::Round($part.FreeSpace / 1GB, 2)
        $totalGB = [math]::Round($part.Size / 1GB, 2)
        Write-Host "`nUnidade: $($part.DeviceID)"
        Write-Host "  Espaço total: ${totalGB} GB"
        Write-Host "  Espaço livre: ${freeGB} GB"
    }

    Write-Host "`nDisco: $($disk.Model)"
    Write-Host "  Interface: $($disk.InterfaceType)"
    Write-Host "  Número de Série: $($disk.SerialNumber)"
    Write-Host "  Status S.M.A.R.T.: $($disk.Status)"
}

Write-Host "`n===== REDE - INTERFACES ATIVAS =====" -ForegroundColor Cyan

# Interfaces de rede IPv4 válidas (exclui loopback e link-local)
$enderecos = Get-NetIPAddress -AddressFamily IPv4 |
    Where-Object { $_.IPAddress -notlike "169.*" -and $_.IPAddress -ne "127.0.0.1" }

foreach ($ip in $enderecos) {
    $interface = Get-NetAdapter | Where-Object { $_.InterfaceIndex -eq $ip.InterfaceIndex }
    Write-Host "`nInterface: $($interface.Name)"
    Write-Host "  IP: $($ip.IPAddress)"
    Write-Host "  Gateway: $($ip.DefaultGateway)"
}

# DNS configurado
Write-Host "`n===== DNS CONFIGURADO =====" -ForegroundColor Cyan
Get-DnsClientServerAddress -AddressFamily IPv4 | ForEach-Object {
    Write-Host "Interface: $($_.InterfaceAlias)"
    $_.ServerAddresses | ForEach-Object {
        Write-Host "  DNS: $_"
    }
}

# IP Público
Write-Host "`n===== IP PÚBLICO =====" -ForegroundColor Cyan
try {
    $ipPublico = Invoke-RestMethod -Uri "https://api.ipify.org?format=text" -TimeoutSec 5
    Write-Host "IP Público: $ipPublico"
}
catch {
    Write-Host "Não foi possível obter o IP público." -ForegroundColor Yellow
}


Write-Host "`n===== ESTADO DO FIREWALL =====" -ForegroundColor Cyan
$firewallProfiles = Get-NetFirewallProfile
foreach ($profile in $firewallProfiles) {
    switch ($profile.Profile) {
        1 { $perfilNome = "Domínio" }
        2 { $perfilNome = "Privado" }
        3 { $perfilNome = "Público" }
        default { $perfilNome = "Desconhecido" }
    }
    $estado = if ($profile.Enabled) { "Ativado" } else { "Desativado" }
    Write-Host "${perfilNome}: $estado"
}

Write-Host "`n===== STATUS DO WINDOWS DEFENDER =====" -ForegroundColor Cyan
try {
    $defenderStatus = Get-MpComputerStatus
    Write-Host "Antivírus Ativo: $($defenderStatus.AntivirusEnabled)"
    Write-Host "Proteção em Tempo Real: $($defenderStatus.RealTimeProtectionEnabled)"
    Write-Host "Firewall Ativado: $($defenderStatus.FirewallEnabled)"
    Write-Host "Antispyware Ativo: $($defenderStatus.AntispywareEnabled)"
}
catch {
    Write-Host "Windows Defender não encontrado ou PowerShell não tem permissão." -ForegroundColor Yellow
}

Write-Host "`n===== VERSÕES DO .NET FRAMEWORK INSTALADAS =====" -ForegroundColor Cyan
Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse |
    Where-Object { $_.GetValue("Version") } |
    ForEach-Object {
        $version = $_.GetValue("Version")
        $name = $_.PSChildName
        Write-Host "$name - Versão: $version"
    }

Write-Host "`n===== STATUS DE ATIVAÇÃO DO WINDOWS =====" -ForegroundColor Cyan
try {
    $osLicensing = Get-CimInstance SoftwareLicensingProduct | Where-Object { $_.PartialProductKey -and $_.LicenseStatus -eq 1 }
    if ($osLicensing) {
        Write-Host "Windows ativado. Chave parcial: $($osLicensing.PartialProductKey)"
    }
    else {
        Write-Host "Windows não ativado ou status desconhecido."
    }
}
catch {
    Write-Host "Não foi possível obter status de ativação." -ForegroundColor Yellow
}

Write-Host "`n===== CONTROLE DE CONTA DE USUÁRIO (UAC) =====" -ForegroundColor Cyan
try {
    $uacKey = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name EnableLUA
    $uacStatus = if ($uacKey.EnableLUA -eq 1) { "Ativado" } else { "Desativado" }
    Write-Host "UAC: $uacStatus"
}
catch {
    Write-Host "Não foi possível obter status do UAC." -ForegroundColor Yellow
}

Write-Host "`n===== PROGRAMAS INSTALADOS =====" -ForegroundColor Cyan
$programas = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* ,
                      HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |
            Where-Object { $_.DisplayName } |
            Select-Object DisplayName, DisplayVersion, Publisher, InstallDate

foreach ($prog in $programas | Sort-Object DisplayName) {
    Write-Host "$($prog.DisplayName) - Versão: $($prog.DisplayVersion) - Publisher: $($prog.Publisher)"
}

Write-Host "`n===== SERVIÇOS ATIVOS =====" -ForegroundColor Cyan
Get-Service | Where-Object { $_.Status -eq 'Running' } | ForEach-Object {
    Write-Host "$($_.DisplayName) ($($_.Name))"
}

Write-Host "`n===== PROGRAMAS NA INICIALIZAÇÃO =====" -ForegroundColor Cyan
Get-CimInstance Win32_StartupCommand | ForEach-Object {
    Write-Host "$($_.Name) - Local: $($_.Location) - Comando: $($_.Command)"
}

Write-Host "`n===== STATUS DO BITLOCKER =====" -ForegroundColor Cyan
try {
    $bitlocker = Get-BitLockerVolume -ErrorAction Stop
    foreach ($volume in $bitlocker) {
        Write-Host "Volume: $($volume.VolumeType)"
        $status = if ($volume.ProtectionStatus -eq 1) { "Ativado" } else { "Desativado" }
Write-Host "Proteção: $status"

        Write-Host "Criptografia: $($volume.EncryptionPercentage)%"
    }
}
catch {
    Write-Host "BitLocker não está disponível neste sistema ou sem permissão." -ForegroundColor Yellow
}

Write-Host "`n===== VERSÃO DO POWERSHELL =====" -ForegroundColor Cyan
Write-Host $PSVersionTable.PSVersion.ToString()


   
read-Host "Pressione qualquer tecla para sair"

}

function Otimizador-PCFraco {
    do {
        Clear-Host
        Mostrar-Banner
        Write-Host ""
        Write-Host "  ==== OTIMIZADOR DE WINDOWS ====" -ForegroundColor Red
        Write-Host ""
        Write-Host "  [1] Desativar serviÃ§os desnecessÃ¡rios"
        Write-Host "  [2] Desativar tarefas agendadas"
        Write-Host "  [3] Ajustar efeitos visuais para desempenho"
        Write-Host "  [4] Limpar arquivos temporÃ¡rios"
        Write-Host "  [5] Limpar registros recentes"
        Write-Host "  [6] Remover apps inÃºteis (Ex: Xbox)"
        Write-Host "  [7] Limpar pasta Prefetch"
		Write-Host "  [8] Desabilitar inicializaÃ§Ãµes automÃ¡ticas"
		Write-Host "  [9]. Executar todas as otimizaÃ§Ãµes"
        Write-Host "  [V] VOLTAR " -ForegroundColor Yellow -NoNewline
        Write-Host "  [M] MENU "   -ForegroundColor Green -NoNewline
        Write-Host "  [S] SAIR"    -ForegroundColor Red
        Write-Host ""

        $opcao = Read-Host "Escolha uma opÃ§Ã£o"
        switch ($opcao) {
            '1' { Desativar-Servicos }
            '2' { Desativar-Tarefas }
            '3' { Desativar-EfeitosVisuais }
            '4' { Limpar-Temporarios }
            '5' { Limpar-Registro }
            '6' { Desinstalar-Aplicativos }
            '7' { Limpar-Prefetch }
            '8' { Desabilitar-Inicializacoes }
			"9" { Executar-TodasOtimizaÃ§Ãµes }
			'V' { return }
			'M' {Mostrar-Menu}
			'S' {exit}
            default { Write-Host "OpÃ§Ã£o invÃ¡lida. Tente novamente." -ForegroundColor Red; Pause }
        }
    } while ($true)
}

function Desativar-Servicos {
    $services = @(
        "DiagTrack", "WMPNetworkSvc", "Fax", "RemoteRegistry", "XblGameSave",
        "WSearch", "SysMain", "WalletService"
    )
    foreach ($svc in $services) {
        Get-Service -Name $svc -ErrorAction SilentlyContinue | Set-Service -StartupType Disabled
        Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
    }
    Write-Host "ServiÃ§os desativados com sucesso." -ForegroundColor Yellow
    read-host "Pressione Qualquer Tecla para Sair"
}

function Desativar-Tarefas {
    $tasks = @(
        "\Microsoft\Windows\Application Experience\ProgramDataUpdater",
        "\Microsoft\Windows\Autochk\Proxy",
        "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator",
        "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask",
        "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip",
        "\Microsoft\Windows\Shell\FamilySafetyMonitor"
    )
    foreach ($task in $tasks) {
        schtasks /Change /TN $task /Disable 2>$null
    }
    Write-Host "Tarefas agendadas desativadas." -ForegroundColor Yellow
read-host "Pressione Qualquer Tecla para Sair"
}

function Desativar-EfeitosVisuais {
    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
    New-Item -Path $regPath -Force | Out-Null
    Set-ItemProperty -Path $regPath -Name VisualFXSetting -Value 2
    Write-Host "Efeitos visuais ajustados para desempenho." -ForegroundColor Yellow
    read-host "Pressione Qualquer Tecla para Sair"
}

function Limpar-Temporarios {
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Arquivos temporÃ¡rios removidos." -ForegroundColor Yellow
    read-host "Pressione Qualquer Tecla para Sair"
}

function Limpar-Registro {
    Remove-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSavePidlMRU" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Entradas de registro limpas." -ForegroundColor Yellow
    read-host "Pressione Qualquer Tecla para Sair"
}

function Desinstalar-Aplicativos {
    Get-AppxPackage *xbox* | Remove-AppxPackage -ErrorAction SilentlyContinue
    Write-Host "Aplicativos Xbox removidos (se presentes)." -ForegroundColor Yellow
    read-host "Pressione Qualquer Tecla para Sair"
}

function Limpar-Prefetch {
    Remove-Item -Path "C:\Windows\Prefetch\*" -Force -ErrorAction SilentlyContinue
    Write-Host "Pasta Prefetch limpa." -ForegroundColor Yellow
    read-host "Pressione Qualquer Tecla para Sair"
}

function Desabilitar-Inicializacoes {
    Write-Host "Desabilitando serviÃ§os de terceiros desnecessÃ¡rios..." -ForegroundColor Cyan

    # Lista serviÃ§os que nÃ£o sÃ£o da Microsoft e estÃ£o configurados para iniciar automaticamente
    $servicos = Get-CimInstance Win32_Service | Where-Object {
        $_.StartMode -eq "Auto" -and $_.State -ne "Stopped" -and $_.PathName -notlike "*Microsoft*"
    }

    foreach ($servico in $servicos) {
        try {
            Set-Service -Name $servico.Name -StartupType Disabled
            Stop-Service -Name $servico.Name -Force -ErrorAction SilentlyContinue
            Write-Host "Desativado: $($servico.DisplayName)" -ForegroundColor Yellow
        } catch {
            Write-Host "Falha ao desativar: $($servico.DisplayName)" -ForegroundColor Red
        }
    }

    Write-Host "`nRemovendo programas de inicializaÃ§Ã£o automÃ¡tica..." -ForegroundColor Cyan

    # Remove entradas comuns de programas iniciando junto com o Windows via registro
    $runKeys = @(
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run",
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"
    )

    foreach ($key in $runKeys) {
        if (Test-Path $key) {
            Get-ItemProperty -Path $key | ForEach-Object {
                $_.PSObject.Properties | Where-Object { $_.Name -ne "Default" } | ForEach-Object {
                    Remove-ItemProperty -Path $key -Name $_.Name -ErrorAction SilentlyContinue
                    Write-Host "Removido do registro: $($_.Name)" -ForegroundColor Yellow
                }
            }
        }
    }

    # Limpa a pasta Startup do usuÃ¡rio atual
    $startupFolder = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\*"
    Remove-Item $startupFolder -Force -Recurse -ErrorAction SilentlyContinue
    Write-Host "Itens da pasta Startup removidos." -ForegroundColor Yellow

    Write-Host "`nInicializaÃ§Ãµes desnecessÃ¡rias desabilitadas com sucesso." -ForegroundColor Green
}

function Executar-TodasOtimizaÃ§Ãµes {
    Write-Host "`n== INICIANDO OTIMIZAÃ‡Ã•ES COMPLETAS ==" -ForegroundColor Cyan
    Desativar-Servicos
    Desativar-Tarefas
    Desativar-EfeitosVisuais
    Limpar-Temporarios
    Limpar-Registro
    Desinstalar-Aplicativos
    Desabilitar-Inicializacoes
    Limpar-Prefetch
    Write-Host "`nTodas as otimizaÃ§Ãµes foram concluÃ­das com sucesso." -ForegroundColor Green
}

function Winsat {
	
# Desativar o serviÃ§o WinSAT
sc config WinSAT start= disabled

# Desativar a tarefa agendada do WinSAT
schtasks /change /tn "\Microsoft\Windows\Maintenance\WinSAT" /disable

Write-Host "WinSAT foi desativado com sucesso."	
	
	
	
	
}

function Disk-File {
    do {
    Clear-Host
    Mostrar-Banner
    Write-Host ""
    Write-Host "  ==== MENU GERENCIAMENTO DE DISCO ====" -ForegroundColor Red
    Write-Host ""
    Write-Host "  [1] ESPAÃ‡O EM DISCO"
    Write-Host "  [2] LISTAR ARQUIVOS GRANDES"
    Write-Host "  [3] LIMPAR ARQUIVOS TEMPORÃRIOS"
    Write-Host "  [4] PROCURAR ARQUIVOS"
    Write-Host "  [5] VERIFICAR INTEGRIDADE DO DISCO"
    Write-Host "  [V] VOLTAR " -ForegroundColor Yellow -NoNewline
    Write-Host "  [M] MENU "   -ForegroundColor Green -NoNewline
    Write-Host "  [S] SAIR"    -ForegroundColor Red
	Write-Host ""

	
	 $opcao = Read-Host "Escolha uma opÃ§Ã£o"
            switch ($opcao) {
            '1' { Mostrar-EspacoEmDisco }
            '2' { Listar-ArquivosGrandes }
            '3' { Limpar-ArquivosTemporarios }
            '4' { Procurar-Arquivos }
            '5' { Verificar-IntegridadeDisco }
            'V' { return }
			'M' {Mostrar-Menu}
			'S' {exit}
            default { Write-Host "OpÃ§Ã£o invÃ¡lida!" -ForegroundColor Red; Pause }
        }
    } while ($true)
}

function Mostrar-EspacoEmDisco {

    $filtroUnidade = Read-Host "Digite parte da unidade (ou Enter para todos)"
    $filtroRotulo = Read-Host "Digite parte do rótulo (ou Enter para todos)"

    $resultados = Get-Volume | ForEach-Object {
        $unidade = $_.DriveLetter
        $rotulo = $_.FileSystemLabel
        $size = $_.Size
        $sizeRemaining = $_.SizeRemaining

        if (($filtroUnidade -and ($unidade -notlike "*$filtroUnidade*")) -or
            ($filtroRotulo -and ($rotulo -notlike "*$filtroRotulo*"))) {
            return
        }

        if ($size -eq 0) { return }

        $used = $size - $sizeRemaining
        $percentUsed = ($used / $size) * 100

        [PSCustomObject]@{
            Unidade     = $unidade
            Rótulo      = $rotulo
            "Total (GB)"= "{0:N2}" -f ($size / 1GB)
            "Usado (GB)"= "{0:N2}" -f ($used / 1GB)
            "Livre (GB)"= "{0:N2}" -f ($sizeRemaining / 1GB)
            "% Usado"   = $percentUsed
        }
    }

    if (-not $resultados) {
        Write-Warning "Nenhum volume encontrado com os filtros fornecidos."
        return
    }

    foreach ($volume in $resultados) {
        if ($volume.'% Usado' -lt 70) { $cor = "Green" }
        elseif ($volume.'% Usado' -lt 90) { $cor = "Yellow" }
        else { $cor = "Red" }

        Write-Host ("Unidade: {0} | Rótulo: {1}" -f $volume.Unidade, $volume.Rótulo) -ForegroundColor Cyan
        Write-Host ("Total (GB): {0}" -f $volume.'Total (GB)') -ForegroundColor White
        Write-Host ("Usado (GB): {0}" -f $volume.'Usado (GB)') -ForegroundColor White
        Write-Host ("Livre (GB): {0}" -f $volume.'Livre (GB)') -ForegroundColor White
        Write-Host ("% Usado: {0:N2}%" -f $volume.'% Usado') -ForegroundColor $cor
        Write-Host ("-" * 40)
    }
    read-host "Pressione Qualquer Tecla para Sair"
    }

function Listar-ArquivosGrandes {
    $caminho = Read-Host "Digite o caminho para verificar"
    $limiteMB = Read-Host "Digite o tamanho mÃ­nimo em MB"

    Get-ChildItem -Path $caminho -Recurse -ErrorAction SilentlyContinue |
        Where-Object { -not $_.PSIsContainer -and ($_.Length/1MB) -ge $limiteMB } |
        Sort-Object Length -Descending |
        ForEach-Object {
            Write-Host ("{0,-80} {1,10:N2} MB" -f $_.FullName, ($_.Length/1MB)) -ForegroundColor Yellow
        }
    Pause
}

function Limpar-ArquivosTemporarios {
    $temp = $env:TEMP
    $arquivos = Get-ChildItem -Path $temp -Recurse -Force -ErrorAction SilentlyContinue

    $count = 0
    foreach ($arquivo in $arquivos) {
        try {
            Remove-Item -Path $arquivo.FullName -Force -ErrorAction SilentlyContinue
            $count++
        } catch {}
    }
    Write-Host "$count arquivos temporÃ¡rios removidos." -ForegroundColor Green
    Pause
}

function Procurar-Arquivos {
    $caminho = Read-Host "Digite o caminho para procurar"
    $nome = Read-Host "Digite parte do nome do arquivo"

    Get-ChildItem -Path $caminho -Recurse -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -like "*$nome*" } |
        ForEach-Object {
            Write-Host $_.FullName -ForegroundColor Cyan
        }
    Pause
}

function Verificar-IntegridadeDisco {
    $unidade = Read-Host "Digite a unidade (ex: C:)"

    Write-Host "Verificando integridade do disco $unidade..." -ForegroundColor Yellow
    chkdsk $unidade
    Pause
}

function Tools-Bkp {
    do {
        Clear-Host
        Mostrar-Banner
        Write-Host ""
        Write-Host "  ==== FERRAMENTAS DE BKP ====" -ForegroundColor Red
        Write-Host ""
        Write-Host "  [1] CRIAR BACKUP DE ARQUIVOS"
        WRITE-HOST "  [2] RESTAURAR BACKUP"
        WRITE-HOST "  [3] VERIFICAR BACKUPS EXISTENTES"
        WRITE-HOST "  [4] FAZER BACKUP DE DRIVERS"
		WRITE-HOST "  [5] RESTAURAR BACKUP DE DRIVERS"
		Write-Host "  [V] VOLTAR " -ForegroundColor Yellow -NoNewline
        Write-Host "  [M] MENU "   -ForegroundColor Green -NoNewline
        Write-Host "  [S] SAIR"    -ForegroundColor Red
       
        
        $choice = Read-Host "`nSelecione uma opÃ§Ã£o"
        
        switch ($choice) {
            '1' {
                $source = Read-Host "Digite o caminho de origem (ex: C:\Pasta)"
                $destination = Read-Host "Digite o caminho de destino (ex: D:\Backup)"
                $backupName = "Backup_$(Get-Date -Format 'yyyyMMdd_HHmmss').zip"
                
                if (-not (Test-Path $destination)) {
                    New-Item -ItemType Directory -Path $destination -Force
                }
                
                Compress-Archive -Path $source -DestinationPath "$destination\$backupName" -CompressionLevel Optimal
                Write-Host "Backup criado em $destination\$backupName" -ForegroundColor Green
                Pause
            }
            '2' {
                $backupFile = Read-Host "Digite o caminho do arquivo de backup (ex: D:\Backup\arquivo.zip)"
                $destination = Read-Host "Digite o caminho para restauraÃ§Ã£o (ex: C:\Restore)"
                
                if (-not (Test-Path $destination)) {
                    New-Item -ItemType Directory -Path $destination -Force
                }
                
                Expand-Archive -Path $backupFile -DestinationPath $destination -Force
                Write-Host "Backup restaurado para $destination" -ForegroundColor Green
                Pause
            }
            '3' {
                $backupDir = Read-Host "Digite o caminho dos backups (ex: D:\Backup)"
                Get-ChildItem -Path $backupDir -Filter *.zip | Select-Object Name, LastWriteTime, Length | Format-Table -AutoSize
                Pause
            }
            '4' {
            # Pasta base do script
            $scriptDir = $PSScriptRoot
            # Nome da pasta com a data atual
            $backupFolderName = "Driver-BKP-$(Get-Date -Format 'yyyyMMdd')"
            # Caminho completo da pasta de backup
            $destination = Join-Path $scriptDir $backupFolderName

            # Cria a pasta se nÃ£o existir
            if (-not (Test-Path $destination)) {
                New-Item -ItemType Directory -Path $destination -Force | Out-Null
            }

            Write-Host "`nColetando informaÃ§Ãµes de drivers..."
            $drivers = Get-WindowsDriver -Online -All

            # Caminho do arquivo de informaÃ§Ãµes dos drivers
            $backupFile = Join-Path $destination "DriversBackup_$(Get-Date -Format 'yyyyMMdd').txt"
            $drivers | Out-File -FilePath $backupFile

            Write-Host "`nExportando drivers para pasta..."
            Export-WindowsDriver -Online -Destination $destination

            Write-Host "`nBackup dos drivers concluÃ­do com sucesso!" -ForegroundColor Green
            Write-Host "Local do backup: $destination" -ForegroundColor Yellow
            Write-Host "Arquivo de informaÃ§Ãµes: $backupFile" -ForegroundColor Yellow
            Read-Host "Pressione Enter para continuar..."
        }
            '5' {
            # Pasta base do script
$scriptDir = $PSScriptRoot

# Buscar pastas com nome Driver-BKP-YYYYMMDD
$backupFolders = Get-ChildItem -Path $scriptDir -Directory -Filter "Driver-BKP-*" | 
    Sort-Object Name -Descending

if (-not $backupFolders) {
    Write-Host "Nenhum backup de drivers encontrado na pasta do script." -ForegroundColor Red
    exit
}

# Pega a pasta de backup mais recente
$latestBackup = $backupFolders[0].FullName

Write-Host "Backup de drivers mais recente encontrado em:" -ForegroundColor Green
Write-Host $latestBackup -ForegroundColor Yellow

$confirm = Read-Host "Deseja restaurar os drivers dessa pasta? (S/N)"

if ($confirm.ToUpper() -ne 'S') {
    Write-Host "RestauraÃ§Ã£o cancelada pelo usuÃ¡rio."
    exit
}

# Restaurar drivers usando pnputil (vai adicionar os drivers na fila de instalaÃ§Ã£o)
Write-Host "Iniciando restauraÃ§Ã£o dos drivers..."

# Encontra todos os arquivos .inf dentro da pasta de backup
$infFiles = Get-ChildItem -Path $latestBackup -Recurse -Filter *.inf

if (-not $infFiles) {
    Write-Host "Nenhum arquivo .inf encontrado para restaurar." -ForegroundColor Red
    exit
}

foreach ($inf in $infFiles) {
    Write-Host "Instalando driver: $($inf.FullName)"
    # Executa pnputil para adicionar driver ao driver store
    pnputil.exe /add-driver "$($inf.FullName)" /install /subdirs
}

Write-Host "`nRestauraÃ§Ã£o dos drivers concluÃ­da!" -ForegroundColor Green
Read-Host "Pressione Enter para sair..."

            

            



  }  'V' { return }
	    'M' {Mostrar-Menu}
        }
		
  } while ($choice -ne 'S')
}
function Habilitar-PlanosEnergia {
    Write-Host "Habilitando todos os planos de energia ocultos..."
    powercfg -duplicatescheme SCHEME_MIN       # Economizador de energia
    powercfg -duplicatescheme SCHEME_BALANCED  # Balanceado
    powercfg -duplicatescheme SCHEME_MAX       # Alto desempenho
    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 # Desempenho máximo
    Write-Host "Planos habilitados com sucesso!" -ForegroundColor Green
}

function Selecionar-PlanoEnergia {
    Write-Host "`nPlanos de energia disponíveis:" -ForegroundColor Yellow
    
    $planos = powercfg /list | Where-Object { $_ -match "GUID" } | ForEach-Object {
        if ($_ -match "GUID:\s+([a-f0-9\-]+)\s+\((.+)\)") {
            [PSCustomObject]@{
                Numero = $null
                GUID   = $matches[1]
                Nome   = $matches[2]
            }
        }
    }

    # Adiciona número para seleção
    $i = 1
    $planos | ForEach-Object { $_.Numero = $i; $i++ }

    # Mostra lista
    $planos | Format-Table Numero, Nome, GUID -AutoSize

    # Pergunta qual plano usar
    $escolha = Read-Host "`nDigite o número do plano que deseja ativar"
    if ($escolha -as [int] -and $escolha -ge 1 -and $escolha -le $planos.Count) {
        $planoEscolhido = $planos[$escolha - 1]
        powercfg /setactive $planoEscolhido.GUID
        Write-Host "`nPlano '$($planoEscolhido.Nome)' ativado com sucesso!" -ForegroundColor Green
    } else {
        Write-Host "Opção inválida. Nenhuma alteração feita." -ForegroundColor Red
    }
}



###########################################################MENU CLIENTES FIM ##################################################

function Mostrar-Adv {	 
    do {
        Clear-Host
        Mostrar-Banner
        Write-Host ""
        Write-Host "==== MENU ADVOGADOS ====" -ForegroundColor Red
        Write-Host ""
        Write-Host "  [1] DRIVERS TOKENS"
        Write-Host "  [2] PJE OFFICE"
        Write-Host "  [3] JAVA"
        Write-Host "  [4] SHODO"
		Write-Host "  [5] VERIFICAR AMBIENTE"
        Write-Host "  [V] VOLTAR " -ForegroundColor Yellow -NoNewline
        Write-Host "  [M] MENU "   -ForegroundColor Green -NoNewline
        Write-Host "  [S] SAIR"    -ForegroundColor Red
        Write-Host ""
        
        $opcao = Read-Host "Escolha uma opção"
        switch ($opcao) {
            '1' { D-Tokens }
            '2' { P-office_2 }
            '3' { javas }
			'4' { sho_do }
            '5' { V-ambiente }
            'V' { return }
			'M' {Mostrar-Menu}
			'S' {exit}
            default { Write-Host "Opção inválida."; Pause }
        }
    } while ($true)
}




	
function V-ambiente {	 
    do {
        Clear-Host
        Mostrar-Banner
        Write-Host ""
        Write-Host "==== MENU AMBIENTE ====" -ForegroundColor Red
        Write-Host ""
        Write-Host "  [1] CERTIFICADOS VENCIDOS"
        Write-Host "  [2] LIMPAR CACHE"
        Write-Host "  [3] PJE OFFICE"
        Write-Host "  [4] DRIVERS TOKENS"
		Write-Host "  [V] VOLTAR " -ForegroundColor Yellow -NoNewline
        Write-Host "  [M] MENU "   -ForegroundColor Green -NoNewline
        Write-Host "  [S] SAIR"    -ForegroundColor Red
        Write-Host ""
        
        $opcao = Read-Host "Escolha uma opção"
        switch ($opcao) {
            '1' { C-vencidos }
            '2' { Cache-Nave }
            '3' { Pje_Office }
            '4' { V-ambiente }
			'V' { return }
			'M' {Mostrar-Menu}
			'S' {exit}
            default { Write-Host "Opção inválida."; Pause }
        }
    } while ($true)
}	
	
function C-vencidos {


Write-Host "`n=== VERIFICANDO CERTIFICADOS VENCIDOS (INCLUINDO TOKEN) ===" -ForegroundColor Cyan

# Acessa certificados do repositório pessoal do usuário
$certs = Get-ChildItem -Path Cert:\CurrentUser\My -ErrorAction SilentlyContinue

# Verifica certificados com chave privada (armazenados localmente ou no token)
$certsVencidos = $certs | Where-Object {
    $_.HasPrivateKey -and $_.NotAfter -lt (Get-Date)
}

if ($certsVencidos.Count -eq 0) {
    Write-Host "✔ Nenhum certificado vencido foi encontrado." -ForegroundColor Green
} else {
    Write-Host "⚠ Certificados vencidos encontrados:`n" -ForegroundColor Yellow

    $index = 1
    foreach ($cert in $certsVencidos) {
        Write-Host "$index. Sujeito: $($cert.Subject)"
        Write-Host "   Emitido por: $($cert.Issuer)"
        Write-Host "   Validade: $($cert.NotBefore) até $($cert.NotAfter)"
        Write-Host "   Armazenado em token: $($cert.PrivateKey.CspKeyContainerInfo.ProviderName -like "*SafeNet*" -or "*AET*" -or "*ePass*" -or "*USB*")`n"
        $index++
    }

    $resposta = Read-Host "`nDeseja excluir certificados vencidos do repositório local (não afeta token físico)? (S/N)"
    if ($resposta.ToUpper() -eq 'S') {
        foreach ($cert in $certsVencidos) {
            try {
                $cert.Delete()
                Write-Host "✔ Certificado removido: $($cert.Subject)" -ForegroundColor Green
            } catch {
                Write-Host "✖ Falha ao remover: $($cert.Subject) - $_" -ForegroundColor Red
            }
        }
    } else {
        Write-Host "Nenhum certificado foi removido." -ForegroundColor Yellow
    }
}












}	
	
function Cache-Nave {
	
Write-Host "`n=== ETAPA 2: FECHAR NAVEGADORES E LIMPAR CACHE ===" -ForegroundColor Cyan

# Pergunta ao usuário se deseja continuar
$resp = Read-Host "Navegadores serão fechados automaticamente. Deseja continuar? (S/N)"
if ($resp.ToUpper() -ne 'S') {
    Write-Host "Operação cancelada pelo usuário." -ForegroundColor Red
    return
}

# === FECHAR NAVEGADORES ===
# Fecha o Chrome se estiver aberto
$chrome = Get-Process -Name chrome -ErrorAction SilentlyContinue
if ($chrome) {
    Write-Host "Chrome está em execução. Fechando automaticamente..." -ForegroundColor Yellow
    Stop-Process -Name chrome -Force
    Start-Sleep -Seconds 2
}

# Fecha o Firefox se estiver aberto
$firefox = Get-Process -Name firefox -ErrorAction SilentlyContinue
if ($firefox) {
    Write-Host "Firefox está em execução. Fechando automaticamente..." -ForegroundColor Yellow
    Stop-Process -Name firefox -Force
    Start-Sleep -Seconds 2
}

# === LIMPEZA DE CACHE ===

# Caminhos padrão dos perfis
$localAppData = $env:LOCALAPPDATA
$roamingAppData = $env:APPDATA

# Chrome
$chromeCachePaths = @(
    "$localAppData\Google\Chrome\User Data\Default\Cache",
    "$localAppData\Google\Chrome\User Data\Default\Cookies",
    "$localAppData\Google\Chrome\User Data\Default\Code Cache",
    "$localAppData\Google\Chrome\User Data\Default\GPUCache",
    "$localAppData\Google\Chrome\User Data\Default\Local Storage"
)

# Firefox - múltiplos perfis possíveis
$firefoxProfilesPath = "$roamingAppData\Mozilla\Firefox\Profiles"
$firefoxProfiles = Get-ChildItem -Path $firefoxProfilesPath -Directory -ErrorAction SilentlyContinue

# Função para limpar pasta
function Limpar-Pasta($path) {
    if (Test-Path $path) {
        try {
            Remove-Item -Path "$path\*" -Recurse -Force -ErrorAction Stop
            Write-Host "✔ Limpou: $path" -ForegroundColor Green
        } catch {
            Write-Host "✖ Falha ao limpar: $path - $_" -ForegroundColor Red
        }
    } else {
        Write-Host "⚠ Caminho não encontrado: $path" -ForegroundColor DarkYellow
    }
}

# Limpar Chrome
Write-Host "`n--- Limpando Chrome ---" -ForegroundColor Cyan
foreach ($path in $chromeCachePaths) {
    Limpar-Pasta $path
}

# Limpar Firefox
Write-Host "`n--- Limpando Firefox ---" -ForegroundColor Cyan
if ($firefoxProfiles) {
    foreach ($profile in $firefoxProfiles) {
        $pathsFirefox = @(
            "$($profile.FullName)\cache2",
            "$($profile.FullName)\startupCache",
            "$($profile.FullName)\cookies.sqlite",
            "$($profile.FullName)\webappsstore.sqlite"
        )
        foreach ($path in $pathsFirefox) {
            Limpar-Pasta $path
        }
    }
} else {
    Write-Host "⚠ Nenhum perfil do Firefox foi encontrado." -ForegroundColor DarkYellow
}

	
	
	
	
}	

function Pje_Office {
	
Write-Host "`n=== ETAPA 3: VERIFICAR E REINSTALAR PJeOffice PRO v2.5.16u ===" -ForegroundColor Cyan

# Caminho do instalador
$pjeInstaller = Join-Path -Path $Global:ScriptPath -ChildPath "DRIVERS\PJE OFFICE\pjeoffice-pro-v2.5.16u-windows_x64.exe"
$versaoCorreta = "2.5.16u"

# Nome parcial para localizar o PJeOffice
$pjeInstalacoes = Get-WmiObject -Class Win32_Product | Where-Object {
    $_.Name -like "*PJeOffice*" -or $_.Name -like "*PJe Office*"
}

# Remove todas as versões que não sejam a correta
$remocaoNecessaria = $false

foreach ($app in $pjeInstalacoes) {
    if ($app.Version -ne $versaoCorreta) {
        Write-Host "→ Removendo versão conflitante: $($app.Name) - Versão: $($app.Version)" -ForegroundColor Red
        try {
            $app.Uninstall() | Out-Null
            Start-Sleep -Seconds 5
            $remocaoNecessaria = $true
        } catch {
            Write-Host "✖ Erro ao remover $($app.Name): $_" -ForegroundColor DarkRed
        }
    }
}

# Após limpeza, verifica se precisa instalar ou reinstalar
$pjeAtual = Get-WmiObject -Class Win32_Product | Where-Object {
    ($_.Name -like "*PJeOffice*" -or $_.Name -like "*PJe Office*") -and $_.Version -eq $versaoCorreta
}

if (-not $pjeAtual) {
    Write-Host "`nInstalando PJeOffice versão correta v$versaoCorreta..." -ForegroundColor Yellow
    Start-Process -FilePath $pjeInstaller -ArgumentList "/silent /norestart" -Wait
    Write-Host "✔ PJeOffice v$versaoCorreta instalado com sucesso." -ForegroundColor Green
} elseif ($remocaoNecessaria) {
    Write-Host "`nReinstalando PJeOffice para garantir integridade..." -ForegroundColor Yellow
    Start-Process -FilePath $pjeInstaller -ArgumentList "/silent /norestart" -Wait
    Write-Host "✔ Reinstalação completa." -ForegroundColor Green
} else {
    Write-Host "✔ Versão correta já está instalada e sem conflitos." -ForegroundColor Green
}

	
}
function D-TOKENS_ADV {
Write-Host "`n=== ETAPA 4: VERIFICAR E INSTALAR DRIVERS DE TOKEN (ePass2003, GD, SafeNet) ===" -ForegroundColor Cyan

# Caminhos absolutos dos instaladores
$driverEPASS   = Join-Path $Global:ScriptPath "DRIVERS\TOKEN\EPASS2003\ePass2003-Setup.exe"
$driverGD      = Join-Path $Global:ScriptPath "DRIVERS\TOKEN\GD\64bits\SafeSign IC Standard Windows x64 3.5.3.0-AET.000.msi"
$driverSafeNet = Join-Path $Global:ScriptPath "DRIVERS\TOKEN\SAFENET\old\SafeNetAuthenticationClient-x32-x64-9.0.exe"

# Palavras-chave para encontrar versões anteriores
$tokenMatch = @{
    "ePass2003" = @("ePass", "Feitian", "EnterSafe")
    "GD"        = @("SafeSign", "Oberthur", "AET")
    "SafeNet"   = @("SafeNet", "Athena")
}

# === Remover versões antigas ===
foreach ($token in $tokenMatch.Keys) {
    foreach ($nome in $tokenMatch[$token]) {
        $app = Get-WmiObject Win32_Product | Where-Object { $_.Name -like "*$nome*" }
        if ($app) {
            foreach ($item in $app) {
                Write-Host "`n→ Removendo driver antigo: $($item.Name) - Versão: $($item.Version)" -ForegroundColor Red
                try {
                    $item.Uninstall() | Out-Null
                    Start-Sleep -Seconds 3
                } catch {
                    Write-Host "✖ Falha ao remover $($item.Name): $_" -ForegroundColor DarkRed
                }
            }
        }
    }
}

# Função para instalar driver
function Instalar-Driver($nome, $caminho, $argumentos) {
    if (Test-Path $caminho) {
        try {
            Write-Host "`n→ Instalando driver: $nome..." -ForegroundColor Cyan
            Start-Process -FilePath $caminho -ArgumentList $argumentos -Wait
            Write-Host "✔ Driver $nome instalado com sucesso." -ForegroundColor Green
        } catch {
            Write-Host ("✖ Falha na instalação do driver {0}: {1}" -f $nome, $_) -ForegroundColor Red

        }
    } else {
        Write-Host "❌ Instalador do driver $nome não encontrado: $caminho" -ForegroundColor Red
    }
}

# Instalar drivers (versões corretas)
Instalar-Driver -nome "ePass2003" -caminho $driverEPASS -argumentos "/S"
Instalar-Driver -nome "GD (SafeSign)" -caminho $driverGD -argumentos "/qn"
Instalar-Driver -nome "SafeNet Authentication Client" -caminho $driverSafeNet -argumentos "/quiet"
	
	
	
	
}	
	
	
	
	





function Mostrar-MenuStatus {
    Write-Host "Menu Status ainda não implementado."
    Pause
}

function Mostrar-MenuStatus {
	
Clear-Host

# Dicionário com nome e URL
$enderecos = @{
    "PJE 1° GRAU" = "http://pje.tjpb.jus.br/pje"
    "PJE 2° GRAU" = "http://pje.tjpb.jus.br/pje2g"
    "BALCAO VIRTUAL" = "https://www.tjpb.jus.br/balcaovirtual"
    "CENTRAL DE CHAMADOS SERVIDORES" = "https://portaldeservicostjpb.lanlink.com.br/assystnet/"
    "CENTRAL DE CHAMADOS ADVOGADOS" = "https://portalexternostjpb.lanlink.com.br/assystnet/"
}

# Caminho da Área de Trabalho do usuário atual
$desktop = [Environment]::GetFolderPath("Desktop")

function Verificar-Enderecos {
    $resultados = @()
    foreach ($nome in $enderecos.Keys) {
        $url = $enderecos[$nome]
        try {
            $resposta = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 5
            $status = if ($resposta.StatusCode -eq 200) { "ONLINE" } else { "ERRO ($($resposta.StatusCode))" }
            $cor = if ($resposta.StatusCode -eq 200) { "Green" } else { "Yellow" }
        } catch {
            $status = "OFFLINE"
            $cor = "Red"
        }
        $resultados += [PSCustomObject]@{
            Nome   = $nome
            URL    = $url
            Status = $status
            Cor    = $cor
        }
    }
    return $resultados
}

function Criar-AtalhoSeNaoExistir($nome, $url) {
    $atalhoPath = Join-Path $desktop "$nome.lnk"
    if (-not (Test-Path $atalhoPath)) {
        $shell = New-Object -ComObject WScript.Shell
        $atalho = $shell.CreateShortcut($atalhoPath)
        $atalho.TargetPath = $url
        $atalho.IconLocation = "$env:SystemRoot\System32\shell32.dll,220"  # ícone genérico de web
        $atalho.Save()
        Write-Host "🔗 Atalho criado na área de trabalho: $nome" -ForegroundColor Cyan
    }
}

function Mostrar-Tela {
    Clear-Host
    Write-Host "=== MONITOR E ACESSO RÁPIDO ===" -ForegroundColor Cyan
    Write-Host "Atualizado em: $(Get-Date -Format 'HH:mm:ss')" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host ("{0,-4} {1,-40} {2}" -f "N°", "SERVIÇO", "STATUS") -ForegroundColor White
    Write-Host ("-"*80) -ForegroundColor DarkGray

    $global:lista = Verificar-Enderecos
    $i = 1
    foreach ($item in $lista) {
        Write-Host ("[{0}] {1,-40} {2}" -f $i, $item.Nome, $item.Status) -ForegroundColor $item.Cor
        $i++
    }

    Write-Host ""
}

# Loop
while ($true) {
    Mostrar-Tela

    $escolha = Read-Host "Digite o número do site que deseja abrir (ou S para sair)"
    if ($escolha -match '^\d+$') {
        $indice = [int]$escolha - 1
        if ($indice -ge 0 -and $indice -lt $lista.Count) {
            $site = $lista[$indice]
            Write-Host "`nAbrindo $($site.Nome)..." -ForegroundColor Green
            Start-Process $site.URL
            Criar-AtalhoSeNaoExistir -nome $site.Nome -url $site.URL
            Pause
        } else {
            Write-Host "❌ Número inválido." -ForegroundColor Red
            Pause
        }
    } elseif ($escolha.ToUpper() -eq "S") {
        break
    } else {
        Write-Host "❌ Entrada inválida." -ForegroundColor Red
        Pause
    }
}

   
	
}







###########################################################MENU BONUS ##################################################


function Mostrar-MenuBonus {
    do {
        Clear-Host
        Mostrar-Banner
        Write-Host ""
        Write-Host "  ==== MENU BÔNUS ====" -ForegroundColor Red
        Write-Host ""
        Write-Host "  [1] TESTE REDES"
        Write-Host "  [2] ATIVAR MODO DEUS"
        WRITE-HOST "  [3] ATIVADOR"
        WRITE-HOST "  [4] SENHA WIFI"
		WRITE-HOST "  [5] HD 100%"
        WRITE-HOST "  [6] DOWNLOAD VIDEOS/MP3 YOUTUBE"
		write-host "  [7] DISKPART"
		write-host "  [8] CHRIS TITUS TOOLS"
  		write-host "  [9] PADRAO HELIO"
		write-host "  [10] TECLADO PADRAO"
		Write-Host "  [V] VOLTAR " -ForegroundColor Yellow -NoNewline
        Write-Host "  [M] MENU "   -ForegroundColor Green -NoNewline
        Write-Host "  [S] SAIR"    -ForegroundColor Red
        Write-Host ""

        $opcao = Read-Host "Escolha uma opção"
        switch ($opcao) {
            '1' { Test_Redes }
            '2' { God-mod }
            '3' { AttVv }
            '4' { Passwi-fi }
			'5' {HD_100}
			'6' {YTDownload}
			'7' {DiskManagerPro}
			'8' {ChrisTitusTool}
			'9' {heliotools}
			'10' {Set-KeyboardLayout}
			'V' { return }
			'M' {Mostrar-Menu}
			'S' {exit}
            default { Write-Host "Opção inválida."; Pause }
        }
    } while ($true)
}


function Test_Redes {
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    $OutputEncoding = [System.Text.Encoding]::UTF8

    # Ajusta política de execução temporariamente
    if ((Get-ExecutionPolicy) -notin 'RemoteSigned', 'Bypass', 'Unrestricted') {
        try {
            Set-ExecutionPolicy Bypass -Scope Process -Force -ErrorAction Stop
            Write-Host "`n[INFO] Política de execução ajustada para Bypass." -ForegroundColor Yellow
        } catch {
            Write-Host "`n[ERRO] Execute como administrador para ajustar a política." -ForegroundColor Red
            return
        }
    }

    function Get-NetworkAddress {
        param ([string]$IP)
        $bytes = [System.Net.IPAddress]::Parse($IP).GetAddressBytes()
        $bytes[3] = 0
        return [System.Net.IPAddress]::new($bytes).ToString()
    }

    function Get-MACAddress {
        param ([string]$IP)
        try {
            $localIPs = @(Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled } | ForEach-Object { $_.IPAddress }) -join "," -split ","
        } catch { $localIPs = @() }

        if ($localIPs -contains $IP) {
            try {
                $adapter = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -and $_.IPAddress -contains $IP } | Select-Object -First 1
                return $adapter.MACAddress -replace '-', ':' 
            } catch { return "Local (erro)" }
        }

        try {
            Test-Connection -ComputerName $IP -Count 1 -Quiet | Out-Null
            $arpOutput = arp -a | Where-Object { $_ -match $IP }
            return ($arpOutput -split '\s+')[-1] -replace '-', ':'
        } catch {
            return "Indefinido"
        }
    }

    function Test-Port {
        param ([string]$IP, [int[]]$Ports = @(21,22,23,80,443,3389,8080), [int]$TimeoutMs = 300)
        $openPorts = @()
        foreach ($port in $Ports) {
            try {
                $tcpClient = New-Object System.Net.Sockets.TcpClient
                $asyncResult = $tcpClient.BeginConnect($IP, $port, $null, $null)
                if ($asyncResult.AsyncWaitHandle.WaitOne($TimeoutMs, $false) -and $tcpClient.Connected) {
                    $openPorts += $port
                    $tcpClient.EndConnect($asyncResult)
                }
                $tcpClient.Close()
            } catch {}
        }
        return $openPorts
    }

    function Get-IPRange {
        param ([string]$StartIP, [string]$EndIP)
        $startBytes = [System.Net.IPAddress]::Parse($StartIP).GetAddressBytes()
        $endBytes = [System.Net.IPAddress]::Parse($EndIP).GetAddressBytes()
        if (($startBytes[0..2] -join '.') -ne ($endBytes[0..2] -join '.')) {
            throw "ERRO: Os IPs devem estar na mesma sub-rede /24"
        }
        $ipList = @()
        for ($i = $startBytes[3]; $i -le $endBytes[3]; $i++) {
            $ipList += ($startBytes[0..2] + $i) -join '.'
        }
        return $ipList
    }

    Clear-Host
    Mostrar-Banner
    Write-Host "`n[INTERFACES DE REDE LOCAIS]" -ForegroundColor Green
    try {
        Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled } | ForEach-Object {
            Write-Host " - $($_.Description): $($_.IPAddress -join ', ')" -ForegroundColor Gray
        }
    } catch {
        Write-Host "Não foi possível listar interfaces." -ForegroundColor Red
    }

    # Solicita IPs
    do {
        $startIP = Read-Host "`nDigite o IP inicial (ex: 192.168.1.1)"
        $endIP = Read-Host "Digite o IP final (ex: 192.168.1.254)"
        try {
            $ipRange = Get-IPRange -StartIP $startIP -EndIP $endIP
            $networkIP = Get-NetworkAddress -IP $startIP
            if ($ipRange.Count -gt 256) {
                Write-Host "AVISO: Intervalo grande. Continuar? (S/N)" -ForegroundColor Yellow
                if ((Read-Host) -notmatch '^[sS]') { continue }
            }
            break
        } catch {
            Write-Host $_.Exception.Message -ForegroundColor Red
        }
    } while ($true)

    Write-Host "`n[CONFIGURAÇÃO]" -ForegroundColor Yellow
    Write-Host "Rede: $networkIP" -ForegroundColor Cyan
    Write-Host "Intervalo: $startIP a $endIP ($($ipRange.Count) hosts)" -ForegroundColor Cyan
    Write-Host "Portas: 21,22,23,80,443,3389,8080" -ForegroundColor Cyan

    $results = @()
    $ping = New-Object System.Net.NetworkInformation.Ping
    $total = $ipRange.Count
    $i = 0

    foreach ($ip in $ipRange) {
        $i++
        $pct = [math]::Round(($i / $total) * 100)
        Write-Progress -Activity "Varredura" -Status "$pct% - $ip" -PercentComplete $pct
        try {
            $reply = $ping.Send($ip, 500)
            if ($reply.Status -eq 'Success') {
                Write-Host "[+] Host ativo: $ip" -ForegroundColor Green
                $hostname = try { [System.Net.Dns]::GetHostEntry($ip).HostName } catch { "Desconhecido" }
                $mac = Get-MACAddress $ip
                $ports = Test-Port -IP $ip
                $results += [PSCustomObject]@{
                    IP = $ip; Hostname = $hostname; MAC = $mac
                    PortasAbertas = if ($ports) { $ports -join ',' } else { "Nenhuma" }
                    Status = "Ativo"
                }
            }
        } catch { Write-Debug "Erro em $ip" }
    }

    Write-Progress -Activity "Varredura" -Completed
    if ($results.Count) {
        Write-Host "`n[RESULTADOS]" -ForegroundColor Green
        $results | Sort-Object IP | Format-Table -AutoSize
        $file = "Resultados_Varredura_$(Get-Date -f yyyyMMdd-HHmmss).csv"
        $results | Export-Csv $file -NoTypeInformation -Encoding UTF8
        Write-Host "`nExportado para: $file" -ForegroundColor Cyan
    } else {
        Write-Host "`nNenhum host ativo." -ForegroundColor Red
    }

    Write-Host "`nConcluído." -ForegroundColor Yellow
}
function God-mod {
# Caminho para a pasta Documentos do usuário atual
$documentos = [Environment]::GetFolderPath("MyDocuments")

# Nome especial do "Modo Deus"
$nomePasta = "Modo Deus.{ED7BA470-8E54-465E-825C-99712043E01C}"

# Caminho completo
$caminhoCompleto = Join-Path $documentos $nomePasta

# Criar a pasta se não existir
if (-not (Test-Path $caminhoCompleto)) {
    New-Item -Path $caminhoCompleto -ItemType Directory | Out-Null
    Write-Host "✅ Pasta 'Modo Deus' criada com sucesso em: $documentos" -ForegroundColor Green
} else {
    Write-Host "ℹ️ A pasta 'Modo Deus' já existe em: $documentos" -ForegroundColor Yellow
}

# Abrir a pasta no Explorer
Start-Process "explorer.exe" $documentos
read-host "Pressione qualquer tecla para sair"
}
function AttVv {

   powershell -NoProfile -Command "irm https://get.activated.win | iex"
}
function Passwi-fi {
	
# Obtém a lista de perfis Wi-Fi salvos
$profilesOutput = netsh wlan show profiles
$profiles = @()

foreach ($line in $profilesOutput) {
    if ($line -match ":\s*(.+)$") {
        $profiles += $Matches[1].Trim()
    }
}

if ($profiles.Count -eq 0) {
    Write-Host "Nenhum perfil Wi-Fi encontrado." -ForegroundColor Red
    exit
}

# Itera sobre cada perfil e exibe o SSID e a senha
foreach ($profile in $profiles) {
    Write-Host "`nSSID: $profile" -ForegroundColor Cyan

    $profileInfo = netsh wlan show profile name="$profile" key=clear

    # Busca qualquer linha que contenha "Conte" e "Chave" (corrigindo codificação)
    $passwordLine = $profileInfo | Where-Object { ($_ -like "*Conte*") -and ($_ -like "*Chave*") }

    if ($passwordLine) {
        $password = ($passwordLine -split ":")[1].Trim()
        Write-Host "Senha: $password" -ForegroundColor Green
    } else {
        Write-Host "Senha: Não disponível ou perfil sem senha" -ForegroundColor Yellow
    }

    Write-Host ("-" * 40)
}
	
read-host "Pressione Qualquer Tecla para Sair"	

	
	
}
function HD_100 {
	
# ===================================================================
# SCRIPT COMPLETO PARA RESOLVER 100% DE USO DO DISCO - Windows 10/11
# Execute como ADMINISTRADOR
# ===================================================================

# Verifica se está em modo administrador
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "ERRO: Execute este script como administrador!"
    Write-Host "Clique com botão direito no PowerShell e selecione 'Executar como administrador'"
    Pause
    exit
}

Write-Host "`n=== CORRIGINDO 100% USO DO DISCO ===" -ForegroundColor Cyan
Write-Host "Aguarde... Este processo pode demorar alguns minutos.`n"

# ===================================================================
# 1. DESATIVAR SERVIÇOS QUE CAUSAM ALTO USO DE DISCO
# ===================================================================
Write-Host "🔧 Desativando serviços problemáticos..." -ForegroundColor Yellow

$problematicServices = @(
    @{Name="WSearch"; DisplayName="Windows Search"},
    @{Name="SysMain"; DisplayName="SysMain (Superfetch)"},
    @{Name="DiagTrack"; DisplayName="Telemetria"},
    @{Name="dmwappushservice"; DisplayName="WAP Push Message"},
    @{Name="BITS"; DisplayName="Background Intelligent Transfer"},
    @{Name="Fax"; DisplayName="Fax"},
    @{Name="HomeGroupListener"; DisplayName="HomeGroup Listener"},
    @{Name="HomeGroupProvider"; DisplayName="HomeGroup Provider"},
    @{Name="TrkWks"; DisplayName="Distributed Link Tracking Client"},
    @{Name="WbioSrvc"; DisplayName="Windows Biometric Service"}
)

foreach ($svc in $problematicServices) {
    try {
        $service = Get-Service -Name $svc.Name -ErrorAction SilentlyContinue
        if ($service) {
            Stop-Service $svc.Name -Force -ErrorAction SilentlyContinue
            Set-Service $svc.Name -StartupType Disabled -ErrorAction SilentlyContinue
            Write-Host "✅ $($svc.DisplayName) desativado" -ForegroundColor Green
        }
    }
    catch {
        Write-Host "⚠️  Não foi possível desativar $($svc.DisplayName)" -ForegroundColor DarkYellow
    }
}

# ===================================================================
# 2. OTIMIZAR WINDOWS UPDATE
# ===================================================================
Write-Host "`n🔄 Otimizando Windows Update..." -ForegroundColor Yellow

# Parar Windows Update temporariamente
Stop-Service "wuauserv" -Force -ErrorAction SilentlyContinue
Stop-Service "UsoSvc" -Force -ErrorAction SilentlyContinue

# Limpar cache do Windows Update
Remove-Item -Path "$env:WINDIR\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "✅ Cache do Windows Update limpo" -ForegroundColor Green

# Reiniciar serviços
Start-Service "wuauserv" -ErrorAction SilentlyContinue
Start-Service "UsoSvc" -ErrorAction SilentlyContinue

# ===================================================================
# 3. CONFIGURAR ARQUIVO DE PAGINAÇÃO
# ===================================================================
Write-Host "`n💾 Configurando arquivo de paginação..." -ForegroundColor Yellow

try {
    $ram = [math]::Round((Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
    $minSize = [math]::Max(1024, $ram * 512)  # Mínimo 1GB ou 0.5x RAM
    $maxSize = $ram * 1024  # 1x RAM
    
    # Desabilitar gerenciamento automático
    $pageFile = Get-WmiObject -Class Win32_ComputerSystem
    $pageFile.AutomaticManagedPagefile = $false
    $pageFile.Put() | Out-Null
    
    # Configurar tamanho fixo
    $pageFileSetting = Get-WmiObject -Class Win32_PageFileSetting
    if ($pageFileSetting) {
        $pageFileSetting.InitialSize = $minSize
        $pageFileSetting.MaximumSize = $maxSize
        $pageFileSetting.Put() | Out-Null
    }
    
    Write-Host "✅ Arquivo de paginação: ${minSize}MB - ${maxSize}MB (RAM: ${ram}GB)" -ForegroundColor Green
}
catch {
    Write-Host "⚠️  Erro ao configurar arquivo de paginação" -ForegroundColor DarkYellow
}

# ===================================================================
# 4. LIMPEZA AGRESSIVA DE ARQUIVOS TEMPORÁRIOS E CACHE
# ===================================================================
Write-Host "`n🧹 Limpando arquivos temporários e cache..." -ForegroundColor Yellow

$cleanupPaths = @(
    "$env:TEMP\*",
    "$env:WINDIR\Temp\*",
    "$env:WINDIR\Prefetch\*",
    "$env:LOCALAPPDATA\Temp\*",
    "$env:WINDIR\Logs\*",
    "$env:WINDIR\SoftwareDistribution\Download\*",
    "$env:USERPROFILE\AppData\Local\Microsoft\Windows\INetCache\*",
    "$env:USERPROFILE\AppData\Local\Microsoft\Windows\WebCache\*",
    "$env:WINDIR\System32\LogFiles\*",
    "$env:USERPROFILE\AppData\Local\CrashDumps\*",
    "$env:USERPROFILE\AppData\Local\Microsoft\Windows\Explorer\*",
    "$env:LOCALAPPDATA\Microsoft\Windows\Caches\*"
)

# Parar serviços que podem estar usando os arquivos
$servicesToStop = @("Themes", "FontCache", "WSearch")
foreach ($svc in $servicesToStop) {
    Stop-Service $svc -Force -ErrorAction SilentlyContinue
}

$totalCleaned = 0
foreach ($path in $cleanupPaths) {
    try {
        $items = Get-ChildItem -Path $path -Force -ErrorAction SilentlyContinue
        if ($items) {
            $size = 0
            $items | ForEach-Object {
                if (-not $_.PSIsContainer) {
                    $size += $_.Length
                }
            }
            Remove-Item $path -Force -Recurse -ErrorAction SilentlyContinue
            $totalCleaned += ($size / 1MB)
        }
    }
    catch {}
}

# Executar Disk Cleanup se disponível
if (Get-Command cleanmgr -ErrorAction SilentlyContinue) {
    Write-Host "Executando Disk Cleanup..."
    Start-Process -FilePath "cleanmgr" -ArgumentList "/sagerun:1" -WindowStyle Hidden -Wait -ErrorAction SilentlyContinue
}

# Reiniciar serviços
foreach ($svc in $servicesToStop) {
    Start-Service $svc -ErrorAction SilentlyContinue
}

Write-Host "✅ Liberados ~$([math]::Round($totalCleaned, 2)) MB de arquivos temporários" -ForegroundColor Green

# ===================================================================
# 5. DESATIVAR PROGRAMAS DE INICIALIZAÇÃO PESADOS
# ===================================================================
Write-Host "`n🚀 Desabilitando programas pesados na inicialização..." -ForegroundColor Yellow

$heavyStartupApps = @(
    "Skype*", "OneDrive*", "Teams*", "Spotify*", "Steam*", 
    "Adobe*", "Creative Cloud*", "iTunes*", "Dropbox*",
    "Google Chrome*", "Firefox*", "Slack*", "Discord*"
)

foreach ($app in $heavyStartupApps) {
    try {
        Get-CimInstance Win32_StartupCommand | Where-Object { $_.Name -like $app } | ForEach-Object {
            $_.Delete()
            Write-Host "✅ Removido da inicialização: $($_.Name)" -ForegroundColor Green
        }
    }
    catch {}
}

# ===================================================================
# 6. OTIMIZAR CONFIGURAÇÕES DO SISTEMA
# ===================================================================
Write-Host "`n⚙️  Aplicando otimizações do sistema..." -ForegroundColor Yellow

# Desativar efeitos visuais pesados
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
New-Item -Path $regPath -Force -ErrorAction SilentlyContinue | Out-Null
Set-ItemProperty -Path $regPath -Name "VisualFXSetting" -Value 2 -ErrorAction SilentlyContinue

# Desativar indexação em drives
Get-WmiObject -Class Win32_Volume | Where-Object { $_.DriveLetter -and $_.IndexingEnabled } | ForEach-Object {
    $_.IndexingEnabled = $false
    $_.Put() | Out-Null
    Write-Host "✅ Indexação desabilitada no drive $($_.DriveLetter)" -ForegroundColor Green
}

# Desativar Windows Defender Real-time (CUIDADO: Só se tiver outro antivírus)
# Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue

# ===================================================================
# 7. VERIFICAR E CORRIGIR DISCO
# ===================================================================
Write-Host "`n🔍 Verificando integridade do disco..." -ForegroundColor Yellow

# Executar CHKDSK
$drives = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }
foreach ($drive in $drives) {
    Write-Host "Agendando verificação para o drive $($drive.DeviceID) na próxima reinicialização..."
    Start-Process -FilePath "chkdsk" -ArgumentList "$($drive.DeviceID) /f /r" -WindowStyle Hidden -ErrorAction SilentlyContinue
}

# Executar SFC
Write-Host "Executando verificação de arquivos do sistema..."
Start-Process -FilePath "sfc" -ArgumentList "/scannow" -WindowStyle Hidden -Wait -ErrorAction SilentlyContinue

# ===================================================================
# 8. DESATIVAR RECURSOS DESNECESSÁRIOS DO WINDOWS
# ===================================================================
Write-Host "`n🎛️  Desativando recursos desnecessários..." -ForegroundColor Yellow

$registryOptimizations = @(
    @{Path="HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; Name="ShowSyncProviderNotifications"; Value=0},
    @{Path="HKLM:\SOFTWARE\Microsoft\Windows Search"; Name="EnableWebResultsSetting"; Value=0},
    @{Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"; Name="AllowCortana"; Value=0},
    @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"; Name="SearchboxTaskbarMode"; Value=0},
    @{Path="HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance"; Name="MaintenanceDisabled"; Value=1}
)

foreach ($reg in $registryOptimizations) {
    try {
        New-Item -Path $reg.Path -Force -ErrorAction SilentlyContinue | Out-Null
        Set-ItemProperty -Path $reg.Path -Name $reg.Name -Value $reg.Value -ErrorAction SilentlyContinue
    }
    catch {}
}

Write-Host "✅ Configurações do registro otimizadas" -ForegroundColor Green

# ===================================================================
# 9. LIMPAR LOGS E ARQUIVOS DE CRASH
# ===================================================================
Write-Host "`n📄 Limpando logs e arquivos de crash..." -ForegroundColor Yellow

# Limpar Event Logs principais
$eventLogs = @("Application", "System", "Security", "Setup")
foreach ($logName in $eventLogs) {
    try {
        wevtutil cl "$logName" 2>$null
        Write-Host "✅ Log $logName limpo" -ForegroundColor Green
    } 
    catch { 
        Write-Host "⚠️  Não foi possível limpar log $logName" -ForegroundColor DarkYellow
    }
}

# Limpar arquivos de dump e crash
$crashPaths = @(
    "$env:WINDIR\Minidump\*",
    "$env:WINDIR\memory.dmp",
    "$env:USERPROFILE\AppData\Local\CrashDumps\*",
    "$env:WINDIR\LiveKernelReports\*"
)

foreach ($crashPath in $crashPaths) {
    Remove-Item -Path $crashPath -Force -Recurse -ErrorAction SilentlyContinue
}

Write-Host "✅ Logs e dumps limpos" -ForegroundColor Green

# ===================================================================
# 10. OTIMIZAÇÕES ADICIONAIS DE PERFORMANCE
# ===================================================================
Write-Host "`n⚡ Aplicando otimizações adicionais..." -ForegroundColor Yellow

# Configurar para melhor performance do sistema
powercfg -change -standby-timeout-ac 0
powercfg -change -disk-timeout-ac 0
powercfg -change -monitor-timeout-ac 15

# Desativar hibernação (libera espaço = tamanho da RAM)
powercfg -h off

# Configurar prioridade de processamento para programas
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl"
Set-ItemProperty -Path $regPath -Name "Win32PrioritySeparation" -Value 38 -ErrorAction SilentlyContinue

Write-Host "✅ Hibernação desativada, configurações de energia otimizadas" -ForegroundColor Green

# ===================================================================
# 11. RELATÓRIO FINAL
# ===================================================================
Write-Host "`n📊 RELATÓRIO FINAL" -ForegroundColor Cyan
Write-Host "==================" -ForegroundColor Cyan

# Mostrar uso atual do disco
Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } | ForEach-Object {
    $freePercent = [math]::Round(($_.FreeSpace / $_.Size) * 100, 2)
    Write-Host "Drive $($_.DeviceID) - Espaço livre: $freePercent%" -ForegroundColor White
}

# Mostrar processos que mais usam disco
Write-Host "`nProcessos que mais usam disco:" -ForegroundColor White
Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 5 | ForEach-Object {
    $memoryMB = [math]::Round($_.WorkingSet / 1MB, 2)
    Write-Host "- $($_.ProcessName): $memoryMB MB" -ForegroundColor Gray
}

Write-Host "`n✅ OTIMIZAÇÃO CONCLUÍDA!" -ForegroundColor Green
Write-Host "📋 PRÓXIMOS PASSOS:" -ForegroundColor Yellow
Write-Host "1. REINICIE o computador para aplicar todas as alterações"
Write-Host "2. Monitore o uso do disco no Gerenciador de Tarefas"
Write-Host "3. Se o problema persistir, considere:"
Write-Host "   - Verificar se o HD não está com defeito"
Write-Host "   - Atualizar drivers do controlador de armazenamento"
Write-Host "   - Considerar upgrade para SSD"

Write-Host "`n⚠️  AVISO: Algumas funcionalidades podem ter sido desabilitadas." -ForegroundColor DarkYellow
Write-Host "Se precisar de alguma funcionalidade específica, reative o serviço correspondente.`n"

Pause	
	
	
	
}
function YTDownload {
$pastaDownload = "$PSScriptRoot\Downloads"

function Show-Menu {
    param (
        [string[]]$Options,
        [string]$Title = "Selecione uma opção:"
    )
    $selected = 0
    [Console]::CursorVisible = $false

    while ($true) {
        Clear-Host
        Write-Host "$Title`n"
        for ($i = 0; $i -lt $Options.Count; $i++) {
            if ($i -eq $selected) {
                Write-Host "=> $($Options[$i])" -ForegroundColor Cyan
            } else {
                Write-Host "   $($Options[$i])"
            }
        }

        $key = [Console]::ReadKey($true)
        switch ($key.Key) {
            'UpArrow'   { if ($selected -gt 0) { $selected-- } }
            'DownArrow' { if ($selected -lt $Options.Count - 1) { $selected++ } }
            'Enter'     {
                [Console]::CursorVisible = $true
                return $selected
            }
        }
    }
}

function Caminho-Executavel {
    param([string]$nome)
    $local = Get-Command $nome -ErrorAction SilentlyContinue
    return $local?.Source
}

function Verificar-Binarios {
    $ytDlp = Caminho-Executavel "yt-dlp.exe"
    $ffmpeg = Caminho-Executavel "ffmpeg.exe"

    if (-not $ytDlp) {
        if (Test-Path "$PSScriptRoot\yt-dlp.exe") {
            $ytDlp = "$PSScriptRoot\yt-dlp.exe"
        } else {
            Write-Host "`n❌ yt-dlp.exe não encontrado."
            Write-Host "🔗 Baixe: https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe"
            Write-Host "➕ Adicione a pasta ao PATH ou coloque o executável na mesma pasta do script."
            Pause
            exit
        }
    }

    if (-not $ffmpeg) {
        if (Test-Path "$PSScriptRoot\ffmpeg.exe") {
            $ffmpeg = "$PSScriptRoot\ffmpeg.exe"
        } else {
            Write-Host "`n⚠️  ffmpeg.exe não encontrado (necessário para juntar vídeo e áudio)."
            Write-Host "🔗 Baixe: https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip"
            Write-Host "➕ Extraia e coloque ffmpeg.exe na mesma pasta do script ou adicione ao PATH."
            Pause
            exit
        }
    }

    return $ytDlp
}

function Iniciar-Download {
    param ([int]$Opcao)

    $url = Read-Host "`nDigite a URL do vídeo ou playlist"
    if (-not $url) { return }

    if (-not (Test-Path $pastaDownload)) {
        New-Item -ItemType Directory -Path $pastaDownload | Out-Null
    }

    $args = @()
    switch ($Opcao) {
        0 {
            $args = @(
                "--output", "$pastaDownload\%(title)s.%(ext)s",
                "--format", "bestvideo+bestaudio/best",
                $url
            )
        }
        1 {
            $args = @(
                "--extract-audio",
                "--audio-format", "mp3",
                "--output", "$pastaDownload\%(title)s.%(ext)s",
                $url
            )
        }
        2 {
            $args = @(
                "--yes-playlist",
                "--output", "$pastaDownload\%(playlist_title)s\%(title)s.%(ext)s",
                "--format", "bestvideo+bestaudio/best",
                $url
            )
        }
    }

    $ytDlpPath = Verificar-Binarios
    Write-Host "`n⏳ Iniciando download..."

    # Captura a saída do yt-dlp
    $output = & $ytDlpPath @args 2>&1

    # Exibe a saída
    $output | ForEach-Object { Write-Host $_ }

    # Verifica falhas na fusão de vídeo + áudio
    if ($output -match "merging formats failed" -or $output -match "ffmpeg not found") {
        Write-Host "`n❌ Falha ao juntar vídeo com áudio." -ForegroundColor Red
        Write-Host "Certifique-se de que ffmpeg.exe está disponível e no PATH ou na mesma pasta do script."
        Write-Host "🔗 Baixe FFmpeg: https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip"
    } else {
        Write-Host "`n✅ Download concluído em: $pastaDownload"
    }

    Pause
}

# Loop principal do menu
while ($true) {
    $opcoes = @(
        "Baixar vídeo",
        "Baixar somente áudio (MP3)",
        "Baixar playlist",
        "Configurar pasta de download (atual: $pastaDownload)",
        "Sair"
    )

    $escolha = Show-Menu -Options $opcoes -Title "Menu YouTube Downloader"

    switch ($escolha) {
        0 { Iniciar-Download -Opcao 0 }
        1 { Iniciar-Download -Opcao 1 }
        2 { Iniciar-Download -Opcao 2 }
        3 {
            $novaPasta = Read-Host "Digite o novo caminho para salvar os arquivos"
            if ($novaPasta) {
                $pastaDownload = $novaPasta
                Write-Host "✅ Pasta atualizada para: $pastaDownload"
                Pause
            }
        }
        4 {
            Write-Host "`nEncerrando..."; break
        }
    }
}
	
	
	
	
}

function DiskManagerPro{
Clear-Host

$systemDisk = (Get-Partition | Where-Object { $_.IsBoot }).DiskNumber

function Confirm-Action($msg) {
    $res = Read-Host "$msg (s/N)"
    return $res -match '^(s|S)$'
}

function Get-AvailableDriveLetter {
    $used = (Get-Volume).DriveLetter
    return ([char[]](67..90) | ForEach-Object { [char]$_ }) | Where-Object { $_ -notin $used }
}

function Format-FAT32 {
    param([char]$DriveLetter)
    Write-Host "Formatando ${DriveLetter}: em FAT32 via format.com (pode demorar)..."


    # - /Q formato rápido, /FS:FAT32 sistema de arquivos
    # - /Y para confirmar automaticamente (sem prompt)
    cmd.exe /c "format $DriveLetter`: /FS:FAT32 /Q /Y" | Out-Null
    Write-Host "Formatação FAT32 concluída."
}

function Listar-Discos {
    Write-Host "`n==== DISCOS DISPONÍVEIS ====" -ForegroundColor Cyan
    $discos = Get-Disk | Sort-Object Number
    foreach ($d in $discos) {
        $tipo = if ($d.BusType -in @('USB','SD')) {"Removível"} elseif ($d.IsBoot) {"Sistema"} else {"Normal"}
        Write-Host "`nDisco $($d.Number) - $($d.FriendlyName) | Tipo: $tipo | Tamanho: $([math]::Round($d.Size/1GB)) GB" -ForegroundColor Yellow
        $particoes = Get-Partition -DiskNumber $d.Number -ErrorAction SilentlyContinue
        foreach ($p in $particoes) {
            $vol = Get-Volume -Partition $p -ErrorAction SilentlyContinue
            $letra = if ($p.DriveLetter) { "$($p.DriveLetter):" } else { "Sem letra" }
            $label = if ($vol) { $vol.FileSystemLabel } else { "N/A" }
            Write-Host " └─ Partição $($p.PartitionNumber) - $letra - $($p.Type) - Label: $label"
        }
    }
}

function Formatar-Particao {
    $d = Read-Host "Número do disco"
    $p = Read-Host "Número da partição"
    $fs = Read-Host "Sistema de arquivos (FAT32 ou NTFS)"
    $label = Read-Host "Label (nome da partição)"

    $part = Get-Partition -DiskNumber $d -PartitionNumber $p -ErrorAction Stop
    if (-not $part.DriveLetter) {
        $letra = (Get-AvailableDriveLetter)[0]
        Set-Partition -DiskNumber $d -PartitionNumber $p -NewDriveLetter $letra
    } else {
        $letra = $part.DriveLetter
    }

    if ($fs -eq "FAT32") {
        # Usar format.com se partição > 32GB (limitação do Windows)
        $volumeInfo = Get-Volume -DriveLetter $letra
        if ($volumeInfo.SizeRemaining -gt 32GB) {
            Format-FAT32 -DriveLetter $letra
        } else {
            Format-Volume -DriveLetter $letra -FileSystem FAT32 -NewFileSystemLabel $label -Force -Confirm:$false
        }
    } else {
        Format-Volume -DriveLetter $letra -FileSystem $fs -NewFileSystemLabel $label -Force -Confirm:$false
    }

    Write-Host "Partição formatada com sucesso."
}

function Alterar-Letra {
    $d = Read-Host "Número do disco"
    $p = Read-Host "Número da partição"
    $nova = Read-Host "Nova letra (ex: E)"
    Set-Partition -DiskNumber $d -PartitionNumber $p -NewDriveLetter $nova.ToUpper()
    Write-Host "Letra alterada para $nova"
}

function Ativar-Particao {
    $d = Read-Host "Número do disco"
    $p = Read-Host "Número da partição"
    Set-Partition -DiskNumber $d -PartitionNumber $p -IsActive $true
    Write-Host "Partição marcada como ativa."
}

function Excluir-Particao {
    $d = Read-Host "Número do disco"
    if ($d -eq $systemDisk) {
        Write-Warning "Você não pode modificar o disco do sistema!"
        return
    }
    $p = Read-Host "Número da partição"
    if (Confirm-Action "Deseja realmente excluir a partição $p do disco $d?") {
        Remove-Partition -DiskNumber $d -PartitionNumber $p -Confirm:$false
        Write-Host "Partição excluída."
    }
}

function Limpar-Todas {
    $d = Read-Host "Número do disco"
    if ($d -eq $systemDisk) {
        Write-Warning "Você não pode limpar o disco do sistema!"
        return
    }
    if (Confirm-Action "Tem certeza que deseja limpar TODAS as partições do disco $d?") {
        Clear-Disk -Number $d -RemoveData -Confirm:$false
        Write-Host "Todas as partições removidas."
    }
}

function Formatar-Disco {
    $d = Read-Host "Número do disco"
    if ($d -eq $systemDisk) {
        Write-Warning "Você não pode formatar o disco do sistema!"
        return
    }
    if (Confirm-Action "Apagar e formatar disco $d inteiro?") {
        Clear-Disk -Number $d -RemoveData -Confirm:$false
        Start-Sleep -Seconds 2
        $disk = Get-Disk -Number $d
        if ($disk.PartitionStyle -eq 'RAW') {
            Initialize-Disk -Number $d -PartitionStyle MBR -Confirm:$false
            Start-Sleep -Seconds 1
        } else {
            Write-Host "Disco já inicializado. Pulando Initialize-Disk."
        }
        $part = New-Partition -DiskNumber $d -UseMaximumSize -AssignDriveLetter
        $fs = Read-Host "Sistema de arquivos (FAT32 ou NTFS)"
        $label = Read-Host "Label (nome da partição)"
        if ($fs -eq "FAT32" -and ($disk.Size -gt 32GB)) {
            Format-FAT32 -DriveLetter $part.DriveLetter
        } else {
            Format-Volume -DriveLetter $part.DriveLetter -FileSystem $fs -NewFileSystemLabel $label -Force -Confirm:$false
        }
        Write-Host "Disco formatado e nova partição criada."
    }
}

function Criar-Particoes-Divididas {
    $d = Read-Host "Número do disco"
    if ($d -eq $systemDisk) {
        Write-Warning "Você não pode modificar o disco do sistema!"
        return
    }
    if (Confirm-Action "Esta ação apagará todas as partições e criará partições divididas. Continuar?") {
        Clear-Disk -Number $d -RemoveData -Confirm:$false
        Start-Sleep -Seconds 2

        $disk = Get-Disk -Number $d
        if ($disk.PartitionStyle -eq 'RAW') {
            Initialize-Disk -Number $d -PartitionStyle MBR -Confirm:$false
            Start-Sleep -Seconds 1
        }

        $sizeFat32 = Read-Host "Tamanho da partição FAT32 em MB (ex: 8192 para 8GB)"
        $sizeFat32Bytes = [int64]$sizeFat32 * 1MB
        $totalSize = $disk.Size

        if ($sizeFat32Bytes -ge $totalSize) {
            Write-Warning "Tamanho da partição FAT32 não pode ser maior ou igual ao tamanho do disco."
            return
        }

        # Criar e formatar partição FAT32
        $part1 = New-Partition -DiskNumber $d -Size $sizeFat32Bytes -AssignDriveLetter
        Start-Sleep -Seconds 1
        Format-FAT32 -DriveLetter $part1.DriveLetter

        # Criar partição NTFS com o resto do espaço
        $part2 = New-Partition -DiskNumber $d -UseMaximumSize -AssignDriveLetter
        Start-Sleep -Seconds 1
        Format-Volume -DriveLetter $part2.DriveLetter -FileSystem NTFS -NewFileSystemLabel "NTFS_PART" -Force -Confirm:$false

        Write-Host "Partições criadas e formatadas com sucesso."
    }
}


function Converter-MBRGPT {
    $d = Read-Host "Número do disco"
    if ($d -eq $systemDisk) {
        Write-Warning "Você não pode converter o disco do sistema!"
        return
    }
    $estiloAtual = (Get-Disk -Number $d).PartitionStyle
    $estiloNovo = if ($estiloAtual -eq "GPT") {"MBR"} else {"GPT"}

    if (Confirm-Action "Deseja apagar tudo e converter o disco $d para $estiloNovo?") {
        Clear-Disk -Number $d -RemoveData -Confirm:$false
        Initialize-Disk -Number $d -PartitionStyle $estiloNovo
        Write-Host "Disco convertido para $estiloNovo com sucesso."
    }
}

function Ativar-DiscoOffline {
    $offline = Get-Disk | Where-Object { $_.IsOffline -eq $true }
    if ($offline) {
        foreach ($d in $offline) {
            Write-Host "Ativando disco $($d.Number)..."
            Set-Disk -Number $d.Number -IsOffline $false
        }
    } else {
        Write-Host "Nenhum disco offline encontrado."
    }
}

do {
    Listar-Discos
    Write-Host "`n==== MENU PRINCIPAL ====" -ForegroundColor Cyan
    Write-Host "1 - Formatar partição"
    Write-Host "2 - Alterar letra de partição"
    Write-Host "3 - Tornar partição ativa"
    Write-Host "4 - Excluir partição"
    Write-Host "5 - Excluir TODAS as partições de um disco"
    Write-Host "6 - Criar nova partição"
    Write-Host "7 - Formatar disco inteiro"
    Write-Host "8 - Criar partições divididas (ex: 8GB FAT32 + resto NTFS)"
    Write-Host "9 - Converter MBR <-> GPT"
    Write-Host "10 - Ativar discos offline"
    Write-Host "0 - Sair"

    $op = Read-Host "Escolha uma opção"
    switch ($op) {
        "1" { Formatar-Particao }
        "2" { Alterar-Letra }
        "3" { Ativar-Particao }
        "4" { Excluir-Particao }
        "5" { Limpar-Todas }
        "6" { 
            # Criar uma partição simples (usa todo espaço livre)
            $d = Read-Host "Número do disco"
            if ($d -eq $systemDisk) {
                Write-Warning "Você não pode modificar o disco do sistema!"
                break
            }
            $tam = Read-Host "Tamanho da nova partição (em MB) ou deixe em branco para usar todo o espaço"
            if ([string]::IsNullOrEmpty($tam)) {
                $part = New-Partition -DiskNumber $d -UseMaximumSize -AssignDriveLetter
            } else {
                $part = New-Partition -DiskNumber $d -Size ($tam*1MB) -AssignDriveLetter
            }
            $fs = Read-Host "Sistema de arquivos (FAT32 ou NTFS)"
            $label = Read-Host "Label (nome da partição)"
            if ($fs -eq "FAT32" -and ($part.Size -gt 32GB)) {
                Format-FAT32 -DriveLetter $part.DriveLetter
            } else {
                Format-Volume -DriveLetter $part.DriveLetter -FileSystem $fs -NewFileSystemLabel $label -Force -Confirm:$false
            }
            Write-Host "Partição criada e formatada."
        }
        "7" { Formatar-Disco }
        "8" { Criar-Particoes-Divididas }
        "9" { Converter-MBRGPT }
        "10" { Ativar-DiscoOffline }
        "0" { break }
        default { Write-Warning "Opção inválida." }
    }

    Write-Host "`nPressione Enter para continuar..."
    [void][System.Console]::ReadLine()
    Clear-Host
} while ($true)
	

	
	
}

function ChrisTitusTool{

irm "https://christitus.com/win" | iex
}

function heliotools {
$Global:ScriptPath = Split-Path -Parent $PSCommandPath

# Redes Wi-Fi desejadas com senhas
$redes = @(
    @{ SSID = "VIVOFIBRA-HENRIQUE-5G"; Senha = "2018Acesso==" },
    @{ SSID = "VIVOFIBRA-HENRIQUE";    Senha = "2018Acesso==" }
)

Write-Host "Verificando redes Wi-Fi disponíveis..."
$redesDisponiveis = netsh wlan show networks | Select-String "SSID" | ForEach-Object { ($_ -split ":")[1].Trim() }

# Função para testar conexão com a internet
function Test-Internet {
    try {
        Invoke-WebRequest -Uri "https://www.microsoft.com" -UseBasicParsing -TimeoutSec 10 | Out-Null
        return $true
    } catch {
        return $false
    }
}

# Função para conectar a uma rede com ou sem perfil
function Conectar-WiFi {
    param (
        [string]$ssid,
        [string]$senha
    )

    # Verifica se o perfil já existe
    $perfilExiste = netsh wlan show profiles | Select-String $ssid

    if (-not $perfilExiste) {
        Write-Host "Criando perfil para rede $ssid..."

        $xmlProfile = @"
<?xml version="1.0"?>
<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1">
    <name>$ssid</name>
    <SSIDConfig>
        <SSID>
            <name>$ssid</name>
        </SSID>
    </SSIDConfig>
    <connectionType>ESS</connectionType>
    <connectionMode>auto</connectionMode>
    <MSM>
        <security>
            <authEncryption>
                <authentication>WPA2PSK</authentication>
                <encryption>AES</encryption>
                <useOneX>false</useOneX>
            </authEncryption>
            <sharedKey>
                <keyType>passPhrase</keyType>
                <protected>false</protected>
                <keyMaterial>$senha</keyMaterial>
            </sharedKey>
        </security>
    </MSM>
</WLANProfile>
"@

        $xmlPath = "$env:TEMP\$ssid.xml"
        $xmlProfile | Out-File -Encoding ASCII -FilePath $xmlPath
        netsh wlan add profile filename="$xmlPath" | Out-Null
    }

    Write-Host "Conectando à rede $ssid..."
    netsh wlan connect name="$ssid" | Out-Null
    Start-Sleep -Seconds 5
    return Test-Internet
}

# Tenta conectar nas redes preferenciais
foreach ($rede in $redes) {
    if ($redesDisponiveis -contains $rede.SSID) {
        if (Conectar-WiFi -ssid $rede.SSID -senha $rede.Senha) {
            Write-Host "Conectado com sucesso à rede $($rede.SSID)."
            break
        } else {
            Write-Warning "Falha ao conectar à rede $($rede.SSID)."
        }
    }
}

# Aguarda até a internet estar disponível, por no máximo 30 segundos
$tempoMaximo = 30
$tempoDecorrido = 0
$internetOk = $false

while ($tempoDecorrido -lt $tempoMaximo) {
    if (Test-Internet) {
        $internetOk = $true
        break
    }
    Start-Sleep -Seconds 3
    $tempoDecorrido += 3
    Write-Host "Aguardando conexão com a internet... ($tempoDecorrido s)"
}

if (-not $internetOk) {
    Write-Error "Sem conexão com a internet após $tempoMaximo segundos. Saindo..."
    exit
} else {
    Write-Host "Internet conectada com sucesso após $tempoDecorrido segundos."
}

# Verifica ou instala o Chocolatey
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Chocolatey não encontrado. Instalando..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

    # Adiciona chocolatey ao PATH temporariamente para uso imediato
    $env:Path += ";$env:ALLUSERSPROFILE\chocolatey\bin"
} else {
    Write-Host "Chocolatey já está instalado."
}

# Testa o comando choco após a instalação
try {
    choco --version
    Write-Host "Chocolatey está funcionando corretamente."
} catch {
    Write-Warning "Chocolatey parece não estar funcionando. Tentando reinstalar..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# Arrays de log
$instaladosNovos = @()
$atualizados = @()
$jaAtualizados = @()
$falhas = @()

# Função para verificar instalação e atualização de pacote Chocolatey
function VerificarEInstalar {
    param([string]$pacote)

    Write-Host "`n🔍 Verificando $pacote..."

    $instalado = choco list --localonly --exact $pacote | Select-String "^$pacote "

    if ($instalado) {
        $desatualizado = choco outdated | Select-String "^$pacote "
        if ($desatualizado) {
            Write-Host "🔄 Atualizando $pacote..."
            if (choco upgrade $pacote -y --ignore-checksums) {
                $atualizados += $pacote
            } else {
                $falhas += $pacote
            }
        } else {
            Write-Host "✅ $pacote já está instalado e atualizado."
            $jaAtualizados += $pacote
        }
    } else {
        Write-Host "📦 Instalando $pacote..."
        if (choco install $pacote -y --ignore-checksums) {
            $instaladosNovos += $pacote
        } else {
            $falhas += $pacote
        }
    }
}

# Lista de pacotes Chocolatey (sem libreoffice-fresh)
$pacotes = @(
    "googlechrome",
    "firefox",
    "winrar",
    "vlc",
    # "googledrive",
    "netfx-4.8-runtime",
    "adobereader"
)

# Verificar e instalar pacotes Chocolatey (exceto LibreOffice)
foreach ($pacote in $pacotes) {
    VerificarEInstalar $pacote
}

# Pergunta para instalar LibreOffice por último
$instalarLibreOffice = Read-Host "Deseja instalar o LibreOffice? (S/N)"
if ($instalarLibreOffice.Trim().ToUpper() -eq "S") {
    VerificarEInstalar "libreoffice-fresh"
} else {
    Write-Host "Pulo a instalação do LibreOffice conforme sua escolha."
}

# -------------------------
# Criar atalho para Adobe Reader
# -------------------------
$atalhoAdobe = "$env:Public\Desktop\Adobe Reader.lnk"
$caminhoAdobe = "${env:ProgramFiles(x86)}\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe"

if ((Test-Path $caminhoAdobe) -and (-not (Test-Path $atalhoAdobe))) {
    Write-Host "`n📄 Criando atalho para Adobe Reader na área de trabalho..."
    $WshShell = New-Object -ComObject WScript.Shell
    $Atalho = $WshShell.CreateShortcut($atalhoAdobe)
    $Atalho.TargetPath = $caminhoAdobe
    $Atalho.WorkingDirectory = Split-Path $caminhoAdobe
    $Atalho.Save()
    Write-Host "✅ Atalho criado com sucesso!"
}

# -------------------------
# RESUMO FINAL
# -------------------------
Write-Host "`n📋 RESUMO DA INSTALAÇÃO:" -ForegroundColor Cyan

if ($instaladosNovos.Count) {
    Write-Host "`n🆕 Instalados:" -ForegroundColor Green
    $instaladosNovos | ForEach-Object { Write-Host " - $_" }
}

if ($atualizados.Count) {
    Write-Host "`n🔄 Atualizados:" -ForegroundColor Yellow
    $atualizados | ForEach-Object { Write-Host " - $_" }
}

if ($jaAtualizados.Count) {
    Write-Host "`n✔️ Já atualizados:" -ForegroundColor Gray
    $jaAtualizados | ForEach-Object { Write-Host " - $_" }
}

if ($falhas.Count) {
    Write-Host "`n❌ Falhas na instalação/atualização:" -ForegroundColor Red
    $falhas | ForEach-Object { Write-Host " - $_" }
} else {
    Write-Host "`n✅ Tudo foi instalado ou verificado com sucesso!" -ForegroundColor Green
}


}

function Set-KeyboardLayout {
    <#
    .SYNOPSIS
        Função para escolher e definir layout de teclado (ABNT2 PT-BR ou Inglês US).
    .DESCRIPTION
        Mostra o layout atual, lista opções, solicita escolha e aplica o layout selecionado.
    #>

    # Obtém o layout atual
    $currentLayout = (Get-WinUserLanguageList)[0].LanguageTag

    Write-Host "===================================" -ForegroundColor Cyan
    Write-Host " Layout atual de teclado: $currentLayout" -ForegroundColor Green
    Write-Host "===================================" -ForegroundColor Cyan
    Write-Host "Selecione o layout de teclado:" -ForegroundColor Cyan
    Write-Host "1 - Teclado ABNT2 (Português Brasil)"
    Write-Host "2 - Teclado Inglês (Estados Unidos)"
    Write-Host ""

    $opcao = Read-Host "Digite o número correspondente"

    switch ($opcao) {
        1 {
            Write-Host "Aplicando teclado ABNT2 (Português Brasil)..." -ForegroundColor Yellow
            Set-WinUserLanguageList -LanguageList pt-BR -Force
        }
        2 {
            Write-Host "Aplicando teclado Inglês (US)..." -ForegroundColor Yellow
            Set-WinUserLanguageList -LanguageList en-US -Force
        }
        Default {
            Write-Host "Opção inválida. Nenhuma alteração feita." -ForegroundColor Red
        }
    }
}

########################################################### FIM MENUBONUS ###################################################




















# Inicia o menu
Mostrar-Menu



