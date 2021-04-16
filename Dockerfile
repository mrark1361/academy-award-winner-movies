FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src

COPY ["MvcMovie.csproj", "./"]
RUN dotnet restore "MvcMovie.csproj" -r linux-musl-arm64

COPY . .
WORKDIR "/src/."
RUN dotnet publish "MvcMovie.csproj" -c Release -o /app -r linux-musl-arm64 --self-contained false --no-restore


FROM mcr.microsoft.com/dotnet/aspnet:5.0-alpine-arm64v8
WORKDIR /app
EXPOSE 80
EXPOSE 443
COPY --from=build /app .
ENTRYPOINT ["dotnet", "MvcMovie.dll"]
