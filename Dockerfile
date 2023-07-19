FROM mcr.microsoft.com/dotnet/aspnet:5.0-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

RUN apt-get update
RUN apt-get install telnet -y
RUN apt-get install libgdiplus -y

FROM mcr.microsoft.com/dotnet/sdk:5.0-buster-slim AS build
WORKDIR /src
COPY ./ ./
RUN dotnet restore "src/Bank.WebApi/Bank.WebApi.csproj"
COPY . .
WORKDIR "/src/src/Bank.WebApi"
RUN dotnet build "Bank.WebApi.csproj" -c Release -o /app/build

FROM build AS publish
LABEL stage=builder
RUN dotnet publish "Bank.WebApi.csproj" -c Release -o /app/publish


FROM base AS final
LABEL chatGenus.tempData=builder
ENV ASPNETCORE_ENVIRONMENT Development
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Bank.WebApi.dll"]
