{{/*
Return the proper sqnc-attachment-api image name
*/}}
{{- define "sqnc-attachment-api.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper init container image name
*/}}
{{- define "sqnc-attachment-api.initDbCreate.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.initDbCreate.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "sqnc-attachment-api.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.initDbCreate.image ) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "sqnc-attachment-api.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the identity service hostname
*/}}
{{- define "sqnc-attachment-api.sqncIdentityHost" -}}
{{- ternary (include "common.names.dependency.fullname" (dict "chartName" "identity" "chartValues" .Values.identity "context" $)) .Values.externalSqncIdentity.host .Values.identity.enabled -}}
{{- end -}}

{{/*
Return the identity service port
*/}}
{{- define "sqnc-attachment-api.sqncIdentityPort" -}}
{{- ternary "3000" .Values.externalSqncIdentity.port .Values.identity.enabled | quote -}}
{{- end -}}

{{/*
Return the ipfs hostname
*/}}
{{- define "sqnc-attachment-api.sqncIpfsHost" -}}
{{- ternary (include "common.names.dependency.fullname" (dict "chartName" "ipfs" "chartValues" .Values.ipfs "context" $)) .Values.externalSqncIpfs.host .Values.ipfs.enabled -}}
{{- end -}}

{{/*
Return the ipfs port
*/}}
{{- define "sqnc-attachment-api.sqncIpfsPort" -}}
{{- ternary "5001" .Values.externalSqncIpfs.port .Values.ipfs.enabled | quote -}}
{{- end -}}

{{/*
Return the storage backend hostname
*/}}
{{- define "sqnc-attachment-api.storageBackendHost" -}}
{{- if eq .Values.storageBackend.mode "S3" -}}
    {{- if .Values.minio.enabled -}}
        {{- include "common.names.dependency.fullname" (dict "chartName" "minio" "chartValues" .Values.minio "context" $) -}}
    {{- else -}}
        {{- .Values.externalStorageBackendHost | quote -}}
    {{- end -}}
{{- else if eq .Values.storageBackend.mode "AZURE" -}}
    {{- if .Values.azurite.enabled -}}
        {{- include "common.names.dependency.fullname" (dict "chartName" "azurite" "chartValues" .Values.azurite "context" $) -}}
    {{- else -}}
        {{- .Values.externalStorageBackendHost | quote -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the storage backend port
*/}}
{{- define "sqnc-attachment-api.storageBackendPort" -}}
{{- if eq .Values.storageBackend.mode "S3" -}}
    {{- if .Values.minio.enabled -}}
        {{- default 9000 .Values.minio.service.ports.api | quote -}}
    {{- else -}}
        {{- .Values.externalStorageBackendPort | quote -}}
    {{- end -}}
{{- else if eq .Values.storageBackend.mode "AZURE" -}}
    {{- if .Values.azurite.enabled -}}
        "10000"
    {{- else -}}
        {{- .Values.externalStorageBackendPort | quote -}}
    {{- end -}}
{{- end -}}
{{- end -}}


{{/*
Return the name of the secret containing S3 credentials
*/}}
{{- define "sqnc-attachment-api.s3SecretName" -}}
{{- if .Values.storageBackend.existingS3Secret -}}
    {{ .Values.storageBackend.existingS3Secret | quote }}
{{- else if .Values.minio.enabled -}}
    {{ printf "%s-minio" (include "common.names.fullname" .) | quote }}
{{- else -}}
    {{ printf "%s-s3-creds" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" | quote }}
{{- end -}}
{{- end -}}

{{/*
Return the access key ID key used in the S3 secret
*/}}
{{- define "sqnc-attachment-api.s3AccessKeyIdKey" -}}
{{- if .Values.storageBackend.existingS3Secret -}}
    {{ .Values.storageBackend.existingS3AccessKeyIdKey | default "accessKeyId" | quote }}
{{- else if .Values.minio.enabled -}}
    "root-user"
{{- else -}}
    "accessKeyId"
{{- end -}}
{{- end -}}

{{/*
Return the secret access key used in the S3 secret
*/}}
{{- define "sqnc-attachment-api.s3SecretAccessKeyKey" -}}
{{- if .Values.storageBackend.existingS3Secret -}}
    {{ .Values.storageBackend.existingS3SecretAccessKeyKey | default "secretAccessKey" | quote }}
{{- else if .Values.minio.enabled -}}
    "root-password"
{{- else -}}
    "secretAccessKey"
{{- end -}}
{{- end -}}

{{/*
Return the name of the secret containing Azure credentials (only if not Azurite)
*/}}
{{- define "sqnc-attachment-api.azureSecretName" -}}
{{- if .Values.storageBackend.existingAzureSecret -}}
    {{ .Values.storageBackend.existingAzureSecret | quote }}
{{- else -}}
    {{ printf "%s-azure-creds" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" | quote }}
{{- end -}}
{{- end -}}

{{/*
Return the key name for Azure accountName (used in the Secret)
*/}}
{{- define "sqnc-attachment-api.azureAccountNameKey" -}}
{{- if .Values.storageBackend.existingAzureSecret -}}
    {{ .Values.storageBackend.existingAzureAccountNameKey | default "accountName" | quote }}
{{- else -}}
    "accountName"
{{- end -}}
{{- end -}}

{{/*
Return the key name for Azure accountKey (used in the Secret)
*/}}
{{- define "sqnc-attachment-api.azureAccountKeyKey" -}}
{{- if .Values.storageBackend.existingAzureSecret -}}
    {{ .Values.storageBackend.existingAzureAccountKeyKey | default "accountKey" | quote }}
{{- else -}}
    "accountKey"
{{- end -}}
{{- end -}}



{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "sqnc-attachment-api.postgresql.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "postgresql" "chartValues" .Values.postgresql "context" $) -}}
{{- end -}}

{{/*
Return the Postgresql hostname
*/}}
{{- define "sqnc-attachment-api.databaseHost" -}}
{{- ternary (include "sqnc-attachment-api.postgresql.fullname" .) .Values.externalDatabase.host .Values.postgresql.enabled | quote -}}
{{- end -}}

{{/*
Return the Postgresql port
*/}}
{{- define "sqnc-attachment-api.databasePort" -}}
{{- ternary "5432" .Values.externalDatabase.port .Values.postgresql.enabled | quote -}}
{{- end -}}

{{/*
Return the Postgresql database name
*/}}
{{- define "sqnc-attachment-api.databaseName" -}}
{{- if .Values.postgresql.enabled -}}
    {{- if .Values.global.postgresql -}}
        {{- if .Values.global.postgresql.auth -}}
            {{- coalesce .Values.global.postgresql.auth.database .Values.postgresql.auth.database -}}
        {{- else -}}
            {{- .Values.postgresql.auth.database -}}
        {{- end -}}
    {{- else -}}
        {{- .Values.postgresql.auth.database -}}
    {{- end -}}
{{- else -}}
    {{- .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the Postgresql user
*/}}
{{- define "sqnc-attachment-api.databaseUser" -}}
{{- if .Values.postgresql.enabled -}}
    {{- if .Values.global.postgresql -}}
        {{- if .Values.global.postgresql.auth -}}
            {{- coalesce .Values.global.postgresql.auth.username .Values.postgresql.auth.username -}}
        {{- else -}}
            {{- .Values.postgresql.auth.username -}}
        {{- end -}}
    {{- else -}}
        {{- .Values.postgresql.auth.username -}}
    {{- end -}}
{{- else -}}
    {{- .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL Secret Name
*/}}
{{- define "sqnc-attachment-api.databaseSecretName" -}}
{{- if .Values.postgresql.enabled -}}
    {{- if .Values.global.postgresql -}}
        {{- if .Values.global.postgresql.auth -}}
            {{- if .Values.global.postgresql.auth.existingSecret -}}
                {{- tpl .Values.global.postgresql.auth.existingSecret $ -}}
            {{- else -}}
                {{- default (include "sqnc-attachment-api.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
            {{- end -}}
        {{- else -}}
            {{- default (include "sqnc-attachment-api.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
        {{- end -}}
    {{- else -}}
        {{- default (include "sqnc-attachment-api.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
    {{- end -}}
{{- else -}}
    {{- default (printf "%s-externaldb" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-") (tpl .Values.externalDatabase.existingSecret $) -}}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "sqnc-attachment-api.databaseSecretPasswordKey" -}}
{{- if .Values.postgresql.enabled -}}
    {{- print "password" -}}
{{- else -}}
    {{- if .Values.externalDatabase.existingSecret -}}
        {{- if .Values.externalDatabase.existingSecretPasswordKey -}}
            {{- printf "%s" .Values.externalDatabase.existingSecretPasswordKey -}}
        {{- else -}}
            {{- print "password" -}}
        {{- end -}}
    {{- else -}}
        {{- print "password" -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "sqnc-attachment-api.databaseSecretPostgresPasswordKey" -}}
{{- if .Values.postgresql.enabled -}}
    {{- print "postgres-password" -}}
{{- else -}}
    {{- if .Values.externalDatabase.existingSecret -}}
        {{- if .Values.externalDatabase.existingSecretPostgresPasswordKey -}}
            {{- printf "%s" .Values.externalDatabase.existingSecretPostgresPasswordKey -}}
        {{- else -}}
            {{- print "postgres-password" -}}
        {{- end -}}
    {{- else -}}
        {{- print "postgres-password" -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "sqnc-attachment-api.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "sqnc-attachment-api.validateValues.databaseName" .) -}}
{{- $messages := append $messages (include "sqnc-attachment-api.validateValues.databaseUser" .) -}}
{{- $messages := append $messages (include "sqnc-attachment-api.validateValues.s3Secrets" .) -}}
{{- $messages := append $messages (include "sqnc-attachment-api.validateValues.azureSecrets" .) -}}
{{- $messages := append $messages (include "sqnc-attachment-api.validateValues.idpCredentials" .) -}}
{{- $messages := append $messages (include "sqnc-attachment-api.validateValues.storageBackend" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate database name */}}
{{- define "sqnc-attachment-api.validateValues.databaseName" -}}
{{- if and (not .Values.postgresql.enabled) .Values.externalDatabase.create -}}
{{- $db_name := (include "sqnc-attachment-api.databaseName" .) -}}
{{- if not (regexMatch "^[a-zA-Z_]+$" $db_name) -}}
sqnc-attachment-api:
    When creating a database the database name must consist of the characters a-z, A-Z and _ only
{{- end -}}
{{- end -}}
{{- end -}}

{{/* Validate database username */}}
{{- define "sqnc-attachment-api.validateValues.databaseUser" -}}
{{- if and (not .Values.postgresql.enabled) .Values.externalDatabase.create -}}
{{- $db_user := (include "sqnc-attachment-api.databaseUser" .) -}}
{{- if not (regexMatch "^[a-zA-Z_]+$" $db_user) -}}
sqnc-attachment-api:
    When creating a database the username must consist of the characters a-z, A-Z and _ only
{{- end -}}
{{- end -}}
{{- end -}}

{{/* Validate idpCredentials */}}
{{- define "sqnc-attachment-api.validateValues.idpCredentials" -}}
{{- if .Values.idpCredentialsSecret.enabled -}}
{{- if or (not .Values.idpCredentials) (eq (len .Values.idpCredentials) 0) -}}
sqnc-attachment-api:
    When idpCredentialsSecret.enabled is true, idpCredentials must be a non-empty array
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "sqnc-attachment-api.validateValues.s3Secrets" -}}
{{- if and (eq .Values.storageBackend.mode "S3") (not (or .Values.minio.enabled .Values.storageBackend.existingS3Secret)) -}}
  {{- if not .Values.storageBackend.accessKeyId }}
sqnc-attachment-api:
    storageBackend.accessKeyId is required if mode=S3 and no existing secret is defined.
  {{- end }}
  {{- if not .Values.storageBackend.secretAccessKey }}
sqnc-attachment-api:
    storageBackend.secretAccessKey is required if mode=S3 and no existing secret is defined.
  {{- end }}
{{- end }}
{{- end }}

{{- define "sqnc-attachment-api.validateValues.azureSecrets" -}}
{{- if and (eq .Values.storageBackend.mode "AZURE") (not .Values.azurite.enabled) (not .Values.storageBackend.existingAzureSecret) -}}
  {{- if not .Values.storageBackend.accountName }}
sqnc-attachment-api:
    storageBackend.accountName is required if mode=AZURE and no existing secret is defined.
  {{- end }}
  {{- if not .Values.storageBackend.accountKey }}
sqnc-attachment-api:
    storageBackend.accountKey is required if mode=AZURE and no existing secret is defined.
  {{- end }}
{{- end }}
{{- end }}

{{- define "sqnc-attachment-api.validateValues.storageBackend" -}}
{{- $mode := .Values.storageBackend.mode | default "" -}}
{{- if not (or (eq $mode "S3") (eq $mode "AZURE") (eq $mode "IPFS")) -}}
sqnc-attachment-api:
	storageBackend.mode must be one of: S3, AZURE, or IPFS
{{- end }}
{{- if eq $mode "S3" -}}
	{{- if and (not .Values.minio.enabled) (not .Values.externalStorageBackendHost) -}}
sqnc-attachment-api:
	storageBackend.externalStorageBackendHost is required when mode=S3 and MinIO is disabled.
	{{- end }}
	{{- if and (not .Values.minio.enabled) (not .Values.externalStorageBackendPort) -}}
sqnc-attachment-api:
	storageBackend.externalStorageBackendPort is required when mode=S3 and MinIO is disabled.
	{{- end }}
{{- end }}
{{- if eq $mode "AZURE" -}}
	{{- if and (not .Values.azurite.enabled) (not .Values.externalStorageBackendHost) -}}
sqnc-attachment-api:
	storageBackend.externalStorageBackendHost is required when mode=AZURE and Azurite is disabled.
	{{- end }}
	{{- if and (not .Values.azurite.enabled) (not .Values.externalStorageBackendPort) -}}
sqnc-attachment-api:
	storageBackend.externalStorageBackendPort is required when mode=AZURE and Azurite is disabled.
	{{- end }}
{{- end }}
{{- if eq $mode "IPFS" -}}
	{{- if and (not .Values.ipfs.enabled) (not .Values.externalSqncIpfs.host) -}}
sqnc-attachment-api:
	externalSqncIpfs.host is required when mode=IPFS and ipfs is disabled.
	{{- end }}
	{{- if and (not .Values.ipfs.enabled) (not .Values.externalSqncIpfs.port) -}}
sqnc-attachment-api:
	externalSqncIpfs.port is required when mode=IPFS and ipfs is disabled.
	{{- end }}
{{- end }}
{{- end }}
