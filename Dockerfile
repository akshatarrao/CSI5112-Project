# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY CSI5112-Project/backend/*.csproj ./CSI5112-Project/backend/
RUN dotnet restore

# Copy everything else and build
COPY CSI5112-Project/backend/. ./CSI5112-Project/backend/
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "backend.dll"]
