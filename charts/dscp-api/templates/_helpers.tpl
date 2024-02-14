{{/*
Create name to be used with deployment.
*/}}
{{- define "dscp-api.fullname" -}}
    {{- if .Values.fullnameOverride -}}
        {{- .Values.fullnameOverride | trunc 63 | trimSuffix "-"| lower -}}
    {{- else -}}
      {{- $name := default .Chart.Name .Values.nameOverride -}}
      {{- if contains $name .Release.Name -}}
        {{- .Release.Name | trunc 63 | trimSuffix "-" | lower -}}
      {{- else -}}
        {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" | lower -}}
      {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "dscp-api.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" | lower }}
{{- end }}

{{/*
Template to define the sqnc-node hostname.
*/}}
{{- define "dscp-api.node-host" -}}
  {{- if .Values.config.externalNodeHost -}}
    {{- .Values.config.externalNodeHost -}}
  {{- else if .Values.node.enabled -}}
    {{- template "sqnc-node.fullname" .Subcharts.node -}}
  {{- else if .Values.ipfs.dscpNode.enabled -}}
    {{- template "dscp-ipfs.dscpNodeHost" .Subcharts.ipfs -}}
  {{- else }}
    {{- fail "Must supply either externalNodeHost or enable node or ipfs" -}}
  {{- end -}}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "dscp-api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "dscp-api.fullname" . }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "dscp-api.labels" -}}
helm.sh/chart: {{ include "dscp-api.chart" . }}
{{ include "dscp-api.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Conditionally populate imagePullSecrets if present in the context
*/}}
{{- define "dscp-api.imagePullSecrets" -}}
  {{- if (not (empty .Values.image.pullSecrets)) }}
imagePullSecrets:
    {{- range .Values.image.pullSecrets }}
  - name: {{ . }}
    {{- end }}
  {{- end }}
{{- end -}}
