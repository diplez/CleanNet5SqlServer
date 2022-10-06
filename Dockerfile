#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

RUN apt-get update
RUN apt-get install telnet -y
RUN apt-get install libgdiplus -y

FROM mcr.microsoft.com/dotnet/sdk:6.0-buster-slim AS build
WORKDIR /src
COPY ./ ./
RUN dotnet restore "src/Lojasoft.Contarz.Web.Api/Lojasoft.Contarz.Web.Api.csproj"
COPY . .
WORKDIR "/src/src/Lojasoft.Contarz.Web.Api"
RUN dotnet build "Lojasoft.Contarz.Web.Api.csproj" -c Release -o /app/build

FROM build AS publish
LABEL stage=builder
RUN dotnet publish "Lojasoft.Contarz.Web.Api.csproj" -c Release -o /app/publish


FROM base AS final
LABEL contarz.tempData=builder
ENV ASPNETCORE_ENVIRONMENT Development
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Lojasoft.Contarz.Web.Api.dll"]