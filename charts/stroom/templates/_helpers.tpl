{{/*
Expand the name of the chart.
*/}}
{{- define "stroom.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "stroom.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
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
stroom/stack: {{ .Values.stackName }}
stroom/rack: {{ .Values.rackName }}
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
{{- if .Values.serviceAccount.create }}
{{- default (include "stroom.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Generates a random password. Parameter is the number of characters to generate.
*/}}
{{- define "stroom.password" -}}
{{- randAlphaNum ( . | default 16 ) | b64enc }}
{{- end }}

{{/*
Root URL of the advertised web frontend
*/}}
{{- define "stroom.rootUrl" -}}
https://{{ .Values.global.advertisedHost }}
{{- end }}