{{/*
Return the proper veritable-cloudagent image name
*/}}
{{- define "veritable-cloudagent.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper init container image name
*/}}
{{- define "veritable-cloudagent.initDbCreate.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.initDbCreate.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "veritable-cloudagent.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.initDbCreate.image ) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper ipfs image name
*/}}
{{- define "ipfs.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.ipfs.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "ipfs.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.ipfs.image ) "global" .Values.global) -}}
{{- end -}}


{{/*
Create the name of the service account to use
*/}}
{{- define "veritable-cloudagent.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name for the wallet.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "veritable-cloudagent.wallet.fullname" -}}
{{- printf "%s-wallet-key" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-"  -}}
{{- end -}}

{{/*
Return the wallet Secret Name
*/}}
{{- define "veritable-cloudagent.walletSecretName" -}}
{{- if .Values.walletKey.existingSecret -}}
    {{- tpl .Values.walletKey.existingSecret $ -}}
{{- else -}}
    {{- include "veritable-cloudagent.wallet.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure wallet secret key
*/}}
{{- define "veritable-cloudagent.walletSecretKey" -}}
{{- if .Values.walletKey.existingSecretKey -}}
    {{- printf "%s" .Values.walletKey.existingSecretKey -}}
{{- else -}}
    {{- print "secret" -}}
{{- end -}}
{{- end -}}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "veritable-cloudagent.cnpg.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "cnpg" "chartValues" .Values.cnpg "context" $) -}}
{{- end -}}

{{/*
Return the CNPG hostname
*/}}
{{- define "veritable-cloudagent.databaseHost" -}}
{{- if .Values.cnpg.enabled -}}
    {{- printf "%v-rw" (include "veritable-cloudagent.cnpg.fullname" $) }}
{{- else if .Values.externalDatabase.host -}}
    {{- .Values.externalDatabase.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the CNPG port
*/}}
{{- define "veritable-cloudagent.databasePort" -}}
{{- ternary "5432" .Values.externalDatabase.port .Values.cnpg.enabled | quote -}}
{{- end -}}

{{/*
Return the CNPG database name
*/}}
{{- define "veritable-cloudagent.databaseName" -}}
{{- if .Values.cnpg.enabled -}}
  {{- $initdb := .Values.cnpg.cluster.initdb | default dict }}
  {{- $initdb.database -}}
{{- else -}}
    {{- .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the CNPG user
*/}}
{{- define "veritable-cloudagent.databaseUser" -}}
{{- if .Values.cnpg.enabled -}}
  {{- $initdb := .Values.cnpg.cluster.initdb | default dict }}
  {{- $initdb.owner -}}
{{- else -}}
    {{- .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}

{{/*
Return the CNPG secret name
*/}}
{{- define "veritable-cloudagent.databaseSecretName" -}}
{{- if .Values.cnpg.enabled -}}
  {{- $secret := .Values.cnpg.cluster.initdb.secret | default dict }}
  {{- $secretName := $secret.name | default (printf "%s-cnpg-superuser" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-") }}
  {{- $secretName -}}
{{- else -}}
    {{- default (printf "%s-externaldb" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-") (tpl .Values.externalDatabase.existingSecret $) -}}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "veritable-cloudagent.databaseSecretPasswordKey" -}}
{{- if .Values.cnpg.enabled -}}
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
{{- define "veritable-cloudagent.databaseSecretPostgresPasswordKey" -}}
{{- if .Values.cnpg.enabled -}}
    {{- print "pgpass" -}}
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
Generate the endpoint URL. If `.Values.endpoint` is defined, print it. 
If `.Values.ingressHttpWs.hostname` is present, validate required fields 
and construct the URL like so: `<transport>://<hostname><path>`, 
fail on missing values. 
*/}}

{{- define "veritable-cloudagent.defineEndpoint" -}}
{{- if .Values.endpoint -}}
    {{- printf "%s" .Values.endpoint -}}
{{- else -}}
    {{- if .Values.ingressHttpWs.hostname -}} 
        {{ printf "%s://%s%s" .Values.ingressHttpWs.httpOrWsTransportDefault .Values.ingressHttpWs.hostname (index .Values.ingressHttpWs.paths 0).path }}
    {{- end -}} 
{{- end -}} 
{{- end -}}


{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "veritable-cloudagent.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "veritable-cloudagent.validateValues.databaseName" .) -}}
{{- $messages := append $messages (include "veritable-cloudagent.validateValues.databaseUser" .) -}}
{{- $messages := append $messages (include "veritable-cloudagent.validateValues.ingressHttpWs" .) -}}


{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate database name */}}
{{- define "veritable-cloudagent.validateValues.databaseName" -}}
{{- if and (not .Values.cnpg.enabled) .Values.externalDatabase.create -}}
{{- $db_name := (include "veritable-cloudagent.databaseName" .) -}}
{{- if not (regexMatch "^[-a-zA-Z_]+$" $db_name) -}}
veritable-cloudagent:
    When creating a database the database name must consist of the characters a-z, A-Z, - and _ only
{{- end -}}
{{- end -}}
{{- end -}}

{{/* Validate database username */}}
{{- define "veritable-cloudagent.validateValues.databaseUser" -}}
{{- if and (not .Values.cnpg.enabled) .Values.externalDatabase.create -}}
{{- $db_user := (include "veritable-cloudagent.databaseUser" .) -}}
{{- if not (regexMatch "^[-a-zA-Z_]+$" $db_user) -}}
veritable-cloudagent:
    When creating a database the username must consist of the characters a-z, A-Z, - and _ only
{{- end -}}
{{- end -}}
{{- end -}}

{{/* Validate ingressHttpWs hostname, path, and transport default */}}
{{- define "veritable-cloudagent.validateValues.ingressHttpWs" -}}
{{- if not .Values.ingressHttpWs.hostname -}}
veritable-cloudagent:
    Missing value for ingressHttpWs.hostname
{{- end -}}
{{- if not .Values.ingressHttpWs.paths -}}
veritable-cloudagent:
    Missing value for ingressHttpWs.paths
{{- end -}}
{{- if not .Values.ingressHttpWs.httpOrWsTransportDefault -}}
veritable-cloudagent:
    Missing value for ingressHttpWs.httpOrWsTransportDefault
{{- end -}}
{{- $transport := .Values.ingressHttpWs.httpOrWsTransportDefault -}}
{{- if not (or (eq $transport "http") (eq $transport "ws")) -}}
veritable-cloudagent:
    Invalid transport, must be http or ws
{{- end -}}
{{- end -}}
