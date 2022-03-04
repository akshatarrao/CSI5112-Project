# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app/backend

# Copy csproj and restore as distinct layers
RUN ls
COPY *.csproj ./
RUN pwd
RUN ls
RUN dotnet restore

# Copy everything else and build
COPY ./ ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app/backend
COPY --from=build-env /app/backend/out .
ENTRYPOINT ["dotnet", "backend.dll"]
