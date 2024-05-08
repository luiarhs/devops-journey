FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG TARGETARCH
WORKDIR /source

# Copy everything
COPY ./api ./
# Restore as distinct layers
RUN dotnet restore -a $TARGETARCH
# Build and publish a release
RUN dotnet publish -a $TARGETARCH --no-restore -o /app

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
EXPOSE 8080
WORKDIR /app
COPY --from=build /app .
USER $APP_UID
ENTRYPOINT ["dotnet", "journey-api.dll"]