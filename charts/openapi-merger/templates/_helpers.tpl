
Return the proper openapi-merger image name
{{/*
*/}}
{{- define "openapi-merger.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "openapi-merger.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.cronjob.initImage .Values.cronjob.image ) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "openapi-merger.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the proper cronjob init container image name
*/}}
{{- define "openapi-merger.cronjob.initImage" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.cronjob.initImage "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper cronjob container image name
*/}}
{{- define "openapi-merger.cronjob.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.cronjob.image "global" .Values.global) }}
{{- end -}}

{{- define "openapi-merger.base.securitySchemes" -}}
{{- $securitySchema := dict .Values.securitySchema.name (omit .Values.securitySchema "name") -}}
{{- range $securityScheme := .Values.extraSecuritySchemas -}}
    {{- $_ := set $securitySchema $securityScheme.name (omit . "name") -}}
{{- end -}}

{{- range $name, $scheme := $securitySchema -}}

{{- end -}}

{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "openapi-merger.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "openapi-merger.validateValues.securitySchema" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{- define "openapi-merger.validateValues.securitySchema" -}}
{{- if .Values.securitySchema.enabled -}}
{{- include "openapi-merger.validateValues.securitySchema.names" . }}
{{- include "openapi-merger.validateValues.securitySchema.types" . }}
{{- include "openapi-merger.validateValues.securitySchema.oauth2" . }}
{{- include "openapi-merger.validateValues.securitySchema.bearer" . }}
{{- end -}}
{{- end -}}

{{- define "openapi-merger.validateValues.securitySchema.names" -}}
    {{- $securitySchema := dict .Values.securitySchema.name "" -}}
    {{- range $securityScheme := .Values.extraSecuritySchemas -}}
        {{- if hasKey $securitySchema $securityScheme.name -}}
securitySchema.names:
    duplicate security schema name detected "{{ $securityScheme.name }}"
        {{- end -}}
    {{- end -}}
{{- end -}}

{{- define "openapi-merger.validateValues.securitySchema.types" -}}
    {{- $securitySchema := dict .Values.securitySchema.name (omit .Values.securitySchema "name") -}}
    {{- range $securityScheme := .Values.extraSecuritySchemas -}}
        {{- $_ := set $securitySchema $securityScheme.name (omit . "name") -}}
    {{- end -}}

    {{- range $name, $securityScheme := $securitySchema -}}
        {{- if and (ne $securityScheme.type "bearer") (ne $securityScheme.type "oauth2") -}}
securitySchema.types:
    invalid security schema type "{{ $securityScheme.type }}" on securityScheme "{{ $name }}"
        {{- end -}}
    {{- end -}}
{{- end -}}

{{- define "openapi-merger.validateValues.securitySchema.oauth2" -}}
    {{- $securitySchema := dict .Values.securitySchema.name (omit .Values.securitySchema "name") -}}
    {{- range $securityScheme := .Values.extraSecuritySchemas -}}
        {{- $_ := set $securitySchema $securityScheme.name (omit . "name") -}}
    {{- end -}}

    {{- range $name, $securityScheme := $securitySchema -}}
        {{- if eq $securityScheme.type "oauth2" -}}
            {{- if not $securityScheme.oauth2 -}}
securitySchema.oauth2:
    Missing oauth2 configuration for {{ $name }}
            {{- else -}}
                {{- if and (or (has "authorizationCode" $securityScheme.oauth2.flows) (has "implicit" $securityScheme.oauth2.flows)) (not (hasKey $securityScheme.oauth2 "authorizationUrl")) -}}
securitySchema.oauth2:
    Missing oauth2 parameter "authorizationUrl" for scheme {{ $name }}. This error has occured because flows contains either "authorizationCode" or "implicit"
                {{- end -}}

                {{- if and (or (has "authorizationCode" $securityScheme.oauth2.flows) (has "password" $securityScheme.oauth2.flows) (has "clientCredentials" $securityScheme.oauth2.flows)) (not (hasKey $securityScheme.oauth2 "tokenUrl")) -}}
securitySchema.oauth2:
    Missing oauth2 parameter "tokenUrl" for scheme {{ $name }}. This error has occured because flows contains either "authorizationCode", "password" or "clientCredentials"
                {{- end -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{- define "openapi-merger.validateValues.securitySchema.bearer" -}}
    {{- $securitySchema := dict .Values.securitySchema.name (omit .Values.securitySchema "name") -}}
    {{- range $securityScheme := .Values.extraSecuritySchemas -}}
        {{- $_ := set $securitySchema $securityScheme.name (omit . "name") -}}
    {{- end -}}

    {{- range $name, $securityScheme := $securitySchema -}}
        {{- if eq $securityScheme.type "bearer" -}}
            {{- if not $securityScheme.bearer -}}
securitySchema.bearer:
    Missing bearer configuration for {{ $name }}
            {{- else -}}
                {{- if not (hasKey $securityScheme.bearer "format") -}}
securitySchema.bearer:
    Missing bearer parameter "format" for scheme {{ $name }}.
                {{- end -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
