#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["WebApplication1/WebApplication1.csproj", "WebApplication1/"]
COPY ["WebApplication1.Tests/WebApplication1.Tests.csproj", "WebApplication1.Tests/"] 
RUN dotnet restore "WebApplication1/WebApplication1.csproj"
RUN dotnet restore "WebApplication1.Tests/WebApplication1.Tests.csproj" 
COPY . .
RUN dotnet build "WebApplication1/WebApplication1.csproj" -c Release -o /app/build
RUN dotnet build "WebApplication1.Tests/WebApplication1.Tests.csproj" -c Release -o /app/build

RUN dotnet test "WebApplication1.Tests/WebApplication1.Tests.csproj" --logger "trx;LogFileName=webapplication1.trx" 

FROM build AS publish
RUN dotnet publish "WebApplication1.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "WebApplication1.dll"]