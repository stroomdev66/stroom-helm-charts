{{/*
Expand the name of the chart.
*/}}
{{- define "stroom.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "stroom.fullname" -}}
{{- $.Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "stroom.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "stroom.labels" -}}
helm.sh/chart: {{ include "stroom.chart" . }}
{{ include "stroom.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{ include "stroom.extraLabels" . }}
{{- end }}

{{/*
Stroom-specific labels, used by subcharts
*/}}
{{- define "stroom.extraLabels" -}}
stroom/stack: {{ .Values.global.stackName }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "stroom.selectorLabels" -}}
app.kubernetes.io/name: {{ include "stroom.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "stroom.serviceAccountName" -}}
{{- include "stroom.fullname" . }}
{{- end }}

{{/*
Name of the cluster `Secret` resource
*/}}
{{- define "stroom.globalSecretName" -}}
{{- include "stroom.fullname" . }}
{{- end }}

{{/*
Generates a random password. Result is NOT base-64 encoded - this is left to the caller.
*/}}
{{- define "stroom.password" -}}
{{- randAlphaNum (.Values.randomPasswordLength | int) }}
{{- end }}