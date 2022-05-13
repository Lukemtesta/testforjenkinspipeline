# escape=`

# Switch the docker daemon to Windows containers 
ARG FROM_IMAGE=mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-1803
FROM ${FROM_IMAGE}

# Reset the shell.
SHELL ["cmd", "/S", "/C"]

# Download channel for fixed installed.
ARG CHANNEL_URL=https://aka.ms/vs/17/release/channel
ADD ${CHANNEL_URL} C:\TEMP\VisualStudio.chman

# Download and install Build Tools for Visual Studio 2022.
ADD https://aka.ms/vs/17/release/vs_buildtools.exe C:\TEMP\vs_buildtools.exe
RUN C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
    --channelUri C:\TEMP\VisualStudio.chman `
    --installChannelUri C:\TEMP\VisualStudio.chman `
	--installPath "%ProgramFiles(x86)%\Microsoft Visual Studio\2022\BuildTools" `
	--add	 Microsoft.Net.Component.4.7.2.TargetingPack `
	--add	 Microsoft.Net.Component.4.8.SDK `
	--add	 Microsoft.VisualStudio.Component.TextTemplating `
	--add	 Microsoft.VisualStudio.Component.VC.Redist.14.Latest `
	--add	 Microsoft.VisualStudio.Component.VC.CLI.Support `
	--add	 Microsoft.VisualStudio.Component.VC.Tools.x86.x64 `
	--add	 Microsoft.VisualStudio.Component.VC.ASAN `
	--add	 Microsoft.VisualStudio.Component.TestTools.BuildTools `
	--add	 Microsoft.VisualStudio.Component.VC.CoreBuildTools `
	--add	 Microsoft.VisualStudio.Component.VC.CoreIde `
	--add	 Microsoft.VisualStudio.Component.VC.ATL `
	--add	 Microsoft.VisualStudio.Component.VC.ATLMFC `
	--add	 Microsoft.VisualStudio.Component.Windows10SDK.19041 `
	--add	 Microsoft.VisualStudio.Component.Windows10SDK `
	--add    Microsoft.Component.MSBuild `
	--add 	 Microsoft.NetCore.Component.Runtime.6.0 `
	--add 	 Microsoft.NetCore.Component.SDK

# Set our environment vars
ENV PATH "C:\Program Files\Nuget":$PATH

# When we run the container instance...
ENTRYPOINT ["C:\\Program Files (x86)\\Microsoft Visual Studio\\2022\\BuildTools\\Common7\\Tools\\VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]

# To build: docker build -t ms -f Dockerfile.windows.vs .
# To run: docker run -v C:\Users\Luke\Documents\code\svn\HippoR6Libs:C:\svn C:\Users\pc\Documents\gh\git\HippoR6:C:\code -i -t ms C:\code\Prototypes\Docker\buildall.bat C:\svn C:\code
