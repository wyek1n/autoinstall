# 设置下载目录
$downloadDir = "$env:USERPROFILE\Downloads\AI_Setup"
New-Item -ItemType Directory -Path $downloadDir -Force

# 下载Python
$pythonUrl = "https://www.python.org/ftp/python/3.10.11/python-3.10.11-amd64.exe"
$pythonInstaller = "$downloadDir\python-3.10.11-amd64.exe"
Invoke-WebRequest -Uri $pythonUrl -OutFile $pythonInstaller

# 安装Python
Start-Process -FilePath $pythonInstaller -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1" -Wait

# 下载CUDA
$cudaUrl = "https://developer.download.nvidia.com/compute/cuda/12.1.0/local_installers/cuda_12.1.0_531.14_windows.exe"
$cudaInstaller = "$downloadDir\cuda_12.1.0_531.14_windows.exe"
Invoke-WebRequest -Uri $cudaUrl -OutFile $cudaInstaller

# 安装CUDA
Start-Process -FilePath $cudaInstaller -ArgumentList "-s" -Wait

# 下载cuDNN
$cudnnUrl = "https://developer.nvidia.com/downloads/compute/cudnn/secure/8.9.6/local_installers/12.x/cudnn-windows-x86_64-8.9.6.50_cuda12-archive.zip"
$cudnnZip = "$downloadDir\cudnn-windows-x86_64-8.9.6.50_cuda12-archive.zip"
Invoke-WebRequest -Uri $cudnnUrl -OutFile $cudnnZip

# 解压cuDNN
Expand-Archive -Path $cudnnZip -DestinationPath "$downloadDir\cudnn"

# 复制cuDNN文件到CUDA目录
$cudaPath = "$env:ProgramFiles\NVIDIA GPU Computing Toolkit\CUDA\v12.1"
Copy-Item -Path "$downloadDir\cudnn\cuda\bin\*" -Destination "$cudaPath\bin"
Copy-Item -Path "$downloadDir\cudnn\cuda\include\*" -Destination "$cudaPath\include"
Copy-Item -Path "$downloadDir\cudnn\cuda\lib\x64\*" -Destination "$cudaPath\lib\x64"

# 下载PyTorch
$torchUrl = "https://mirrors.aliyun.com/pytorch-wheels/cu121/torch-2.1.0+cu121-cp310-cp310-win_amd64.whl"
$torchWheel = "$downloadDir\torch-2.1.0+cu121-cp310-cp310-win_amd64.whl"
Invoke-WebRequest -Uri $torchUrl -OutFile $torchWheel

# 安装PyTorch
Start-Process -FilePath "pip" -ArgumentList "install $torchWheel" -Wait

# 下载LLaMA-Factory
$llamaFactoryUrl = "https://github.com/hiyouga/LLaMA-Factory/archive/refs/heads/main.zip"
$llamaFactoryZip = "$downloadDir\LLaMA-Factory.zip"
Invoke-WebRequest -Uri $llamaFactoryUrl -OutFile $llamaFactoryZip

# 解压LLaMA-Factory
Expand-Archive -Path $llamaFactoryZip -DestinationPath "$downloadDir\LLaMA-Factory"

# 设置环境变量
[System.Environment]::SetEnvironmentVariable("CUDA_PATH", "$cudaPath", [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable("PATH", "$env:PATH;$cudaPath\bin;$cudaPath\libnvvp", [System.EnvironmentVariableTarget]::Machine)

Write-Host "安装完成，请重新启动计算机以应用所有更改。"
