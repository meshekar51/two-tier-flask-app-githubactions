{{/* Chart name */}}
{{- define "twotier.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Fully qualified app name (used for the web tier objects) */}}
{{- define "twotier.fullname" -}}
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

{{/* Name for the MySQL objects */}}
{{- define "twotier.mysql.fullname" -}}
{{- printf "%s-mysql" (include "twotier.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "twotier.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Common labels */}}
{{- define "twotier.labels" -}}
helm.sh/chart: {{ include "twotier.chart" . }}
{{ include "twotier.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.image.tag | default .Chart.AppVersion | trunc 63 | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: {{ include "twotier.name" . }}
{{- end }}

{{- define "twotier.selectorLabels" -}}
app.kubernetes.io/name: {{ include "twotier.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "twotier.flask.selectorLabels" -}}
{{ include "twotier.selectorLabels" . }}
app.kubernetes.io/component: web
{{- end }}

{{- define "twotier.mysql.selectorLabels" -}}
{{ include "twotier.selectorLabels" . }}
app.kubernetes.io/component: database
{{- end }}

{{- define "twotier.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "twotier.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* Web image reference: repo:tag or repo:tag@sha256:... */}}
{{- define "twotier.image" -}}
{{- $tag := .Values.image.tag | default .Chart.AppVersion | toString }}
{{- if .Values.image.digest }}
{{- printf "%s:%s@%s" .Values.image.repository $tag .Values.image.digest }}
{{- else }}
{{- printf "%s:%s" .Values.image.repository $tag }}
{{- end }}
{{- end }}

{{/* Secret holding the DB passwords */}}
{{- define "twotier.secretName" -}}
{{- if .Values.mysql.auth.existingSecret }}
{{- .Values.mysql.auth.existingSecret }}
{{- else }}
{{- include "twotier.mysql.fullname" . }}
{{- end }}
{{- end }}

{{/* DB host/port the web tier connects to */}}
{{- define "twotier.db.host" -}}
{{- if .Values.mysql.enabled }}
{{- include "twotier.mysql.fullname" . }}
{{- else }}
{{- .Values.externalDatabase.host }}
{{- end }}
{{- end }}

{{- define "twotier.db.port" -}}
{{- if .Values.mysql.enabled }}
{{- .Values.mysql.service.port }}
{{- else }}
{{- .Values.externalDatabase.port }}
{{- end }}
{{- end }}

{{/* Fail early on settings that would only break at runtime */}}
{{- define "twotier.validate" -}}
{{- if and .Values.mysql.enabled (eq .Values.mysql.auth.username "root") }}
{{- fail "mysql.auth.username must not be \"root\": the mysql image only creates a non-root application user" }}
{{- end }}
{{- if not .Values.mysql.enabled }}
{{- if not .Values.externalDatabase.host }}
{{- fail "externalDatabase.host is required when mysql.enabled=false" }}
{{- end }}
{{- if and (not .Values.mysql.auth.existingSecret) (not .Values.mysql.auth.password) }}
{{- fail "Set mysql.auth.password or mysql.auth.existingSecret for the external database" }}
{{- end }}
{{- end }}
{{- if and .Values.mysql.persistence.hostPath.enabled (or (not .Values.mysql.persistence.storageClass) (eq .Values.mysql.persistence.storageClass "-")) }}
{{- fail "mysql.persistence.hostPath.enabled needs mysql.persistence.storageClass set to a name such as \"manual\"" }}
{{- end }}
{{- end }}

{{/* storageClassName line for PVCs / PVs */}}
{{- define "twotier.mysql.storageClass" -}}
{{- $sc := .Values.mysql.persistence.storageClass }}
{{- if $sc }}
{{- if eq "-" $sc }}
storageClassName: ""
{{- else }}
storageClassName: {{ $sc | quote }}
{{- end }}
{{- end }}
{{- end }}

{{/* Env vars the web tier and the init container share */}}
{{- define "twotier.db.env" -}}
- name: MYSQL_HOST
  value: {{ include "twotier.db.host" . | quote }}
- name: MYSQL_PORT
  value: {{ include "twotier.db.port" . | quote }}
{{- end }}
