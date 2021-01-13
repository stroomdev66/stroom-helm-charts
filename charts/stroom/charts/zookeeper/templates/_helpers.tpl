{{/*
Expand the name of the chart.
*/}}
{{- define "zookeeper.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "zookeeper.fullname" -}}
{{- $chart := .Values.global.zookeeper }}
{{- printf "%s-%s" .Release.Name $chart.chartId | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "zookeeper.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "zookeeper.labels" -}}
helm.sh/chart: {{ include "zookeeper.chart" . }}
{{ include "zookeeper.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{ include "stroom.extraLabels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "zookeeper.selectorLabels" -}}
app.kubernetes.io/name: {{ include "zookeeper.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Generate a list of servers based on the number of replicas
*/}}
{{- define "zookeeper.servers" -}}
{{- range $i, $e := until (.Values.global.zookeeper.replicaCount | int) }}
{{- $fullName := (include "zookeeper.fullname" $) }}
{{- $hostName := ( printf "%s-%d.%s" $fullName $i $fullName ) }}
{{- $ports := $.Values.global.zookeeper.ports }}
{{- printf "server.%d=%s:%d:%d;%d " (add $i 1) $hostName ($ports.follower | int) ($ports.election | int) ($ports.client | int) }}
{{- end }}
{{- end }}

{{/*
Zookeeper connection string
*/}}
{{- define "zookeeper.connectionString" -}}
{{- range $i, $e := until (.Values.global.zookeeper.replicaCount | int) }}
{{- $fullName := (include "zookeeper.fullname" $) }}
{{- $hostName := ( printf "%s-%d.%s" $fullName $i $fullName ) }}
{{- printf "%s:%d," $hostName ($.Values.global.zookeeper.port | int) }}
{{- end }}
{{- end }}