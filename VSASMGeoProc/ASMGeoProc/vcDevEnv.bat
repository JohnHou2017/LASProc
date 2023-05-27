echo off

rem run only once this batch before compiling MASM or C program

rem
rem This is a modified partial version for VC++ command line compile environment setup without using .NET Framework
rem A complete version is C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\vcvars32.bat
rem
rem MASM compiler: C:\Program Files\Microsoft Visual Studio 10.0\Common7\IDE\ML.EXE
rem C compiler: C:\Program Files\Microsoft Visual Studio 10.0\Common7\IDE\CL.EXE
rem MASM or C Linker : C:\Program Files\Microsoft Visual Studio 10.0\Common7\IDE\LINK.EXE

rem
rem C:\Program Files\Microsoft Visual Studio 10.0\VSTSDB\Deploy;
rem C:\Program Files\Microsoft Visual Studio 10.0\VC\BIN;
rem C:\Program Files\Microsoft Visual Studio 10.0\Common7\Tools;
rem C:\WINDOWS\Microsoft.NET\Framework\v4.0.30319;
rem C:\WINDOWS\Microsoft.NET\Framework\v3.5;
rem C:\Program Files\Microsoft Visual Studio 10.0\VC\VCPackages;
rem C:\Program Files\Microsoft SDKs\Windows\v7.0A\bin\NETFX 4.0 Tools;
rem C:\Program Files\Microsoft SDKs\Windows\v7.0A\bin;
rem append path above if required
set path=C:\Program Files\Microsoft Visual Studio 10.0\Common7\IDE;%path%

rem
set include=C:\Program Files\Microsoft Visual Studio 10.0\VC\INCLUDE;C:\Program Files\Microsoft SDKs\Windows\v7.0A\include;%include%

rem
set lib=C:\Program Files\Microsoft Visual Studio 10.0\VC\LIB;C:\Program Files\Microsoft SDKs\Windows\v7.0A\lib;

rem
rem C:\WINDOWS\Microsoft.NET\Framework\v4.0.30319;C:\WINDOWS\Microsoft.NET\Framework\v3.5
rem append libpath above if required
set libpath=C:\Program Files\Microsoft Visual Studio 10.0\VC\LIB;%libpath%
