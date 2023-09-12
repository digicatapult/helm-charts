# openapi-merger

Serves a single merged [`OpenAPI`](https://swagger.io/specification/) spec based on any number of OpenAPI specs defined under `paths` in [`values.yaml`](https://github.com/digicatapult/helm-charts/blob/main/charts/wasp-open-api/values.yaml).

Includes a node service with three endpoints:

- GET `/api-docs` to access the merged API spec
- `/swagger` to view the merged API spec in Swagger
- POST `/set-api-docs` to set the merged API spec

The merge is automated via a Helm [`CronJob`](helm/wasp-open-api/templates/cronjob.yaml). that runs [`openapi-merge-cli`](https://www.npmjs.com/package/openapi-merge-cli) then posts the merged doc to `set-api-docs` every minute.

## Getting started

`openapi-merger` can be run in a similar way to most nodejs applications. First install required dependencies using `npm`:

```sh
npm install
```

And run the application in development mode with:

```sh
npm run dev
```

Or run tests with:

```sh
npm test
```

## Environment Variables

`openapi-merger` is configured primarily using environment variables as follows:

| variable           | required |      default      | description                                                                          |
| :----------------- | :------: | :---------------: | :----------------------------------------------------------------------------------- |
| LOG_LEVEL          |    N     |      `info`       | Logging level. Valid values are [`trace`, `debug`, `info`, `warn`, `error`, `fatal`] |
| PORT               |    N     |       `80`        | Port on which the service will listen                                                |
| API_DOCS_FILE_PATH |    N     | `./api-docs.json` | Location of the api-docs file on the filesystem                                      |
