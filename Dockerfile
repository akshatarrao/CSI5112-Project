# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app/CSI5112-Project

# Copy csproj and restore as distinct layers
COPY backend/*.csproj ./backend
RUN dotnet restore

# Copy everything else and build
COPY backend/. ./backend
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "backend.dll"]
