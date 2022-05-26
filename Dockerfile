FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env

# copy cprof file and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything and build 
COPY . .
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:6.0
WORKDIR /app
COPY --from=build-env /app/out .

# Run the app on container startup
ENTRYPOINT [ "dotnet", "ims.dll" ]