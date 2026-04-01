# Use the official .NET SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app

# Copy the project file and restore dependencies
COPY ["src/DiIiS-NA/Blizzless.csproj", "src/DiIiS-NA/"]
RUN dotnet restore "src/DiIiS-NA/Blizzless.csproj"

# Copy the rest of the project files and build the application
COPY ["src/", "src/"]
WORKDIR "/app/src/DiIiS-NA"
RUN dotnet publish "Blizzless.csproj" -c Release --runtime linux-x64 --self-contained true -o /app/publish

# Use the official .NET runtime image to run the application
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime
WORKDIR /app

# envsubst (from gettext-base) is used by entrypoint.sh to substitute env vars into config files
RUN apt-get update && apt-get install -y --no-install-recommends gettext-base && rm -rf /var/lib/apt/lists/*
WORKDIR /app

# Copy the published application from the build stage
COPY --from=build /app/publish .

# Copy config templates into container (envsubst will generate real config files at startup)
COPY src/DiIiS-NA/database.Account.config.template /app/database.Account.config.template
COPY src/DiIiS-NA/database.Worlds.config.template /app/database.Worlds.config.template
COPY src/DiIiS-NA/config.ini.template /app/config.ini.template

# Copy certificate inside container - https://git.ciolan.net/Gaming/blizzless-diiis/issues/8
#COPY src/DiIiS-NA/bnetserver.p12 /app/BNetServer.pfx
COPY README.md /app/BNetServer.pfx

# Copy entrypoint script (substitutes DB env vars into NHibernate config files at startup)
COPY docker/entrypoint.sh /app/entrypoint.sh

# Expose the port your application is running on (if needed)
EXPOSE 83 1119 1345 2001 9100 9800

# Start the application
ENTRYPOINT ["/bin/sh", "/app/entrypoint.sh"]
