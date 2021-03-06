#!/bin/bash
# William Lam
# www.virtuallyghetto
# Script to generate VCAC IaaS configuration files + installation bat script that includes SQL Server installation

VCAC_HOME_DIRECTORY=C:\\Users\\Administrator\\Desktop\\VCAC
VCAC_IAAS_SHORT_HOSTNAME=vcac-iaas
VCAC_SSO_HOSTNAME=vcac-id.primp-industries.com
VCAC_SSO_PASSWORD=VMware123!
VCAC_VA_HOSTNAME=vcac-va.primp-industries.com
VCAC_SERVICE_USER=vcac-iaas\\Administrator
VCAC_SERVICE_PASSWORD=VMware123!
VCAC_SECURITY_PASSPHRASE=VMware123!
VCAC_DATABASE_INSTANCE_NAME=VCACSQLEXPRESS
VCAC_DATABASE_NAME=vCAC
EMAIL_SERVER=
EMAIL_PASSWORD=

## DO NOT EDIT BEYOND HERE ##

VCAC_INSTALLER_BAT_SCRIPT=installVCACIaaS.bat
VCAC_DATABASE_INSTANCE=${VCAC_IAAS_SHORT_HOSTNAME}\\${VCAC_DATABASE_INSTANCE_NAME}

SQLSERVER_INSTALLER=SQLEXPR_x64_ENU.exe
SQLSERVER_CONFIG_FILE=vGhetto-SQLServerConfigFile.ini
VCAC_SERVER_CONFIG=vGhetto-VCAC-ServerConfigFile.xml
VCAC_WAPI_CONFIG=vGhetto-VCAC-WAPIConfigFile.xml

VCAC_INSTALLER=vCAC-Server-Setup.exe
VCAC_WORKFLOWMGR_INSTALLER=WorkflowManagerInstaller.msi
VCAC_VRMAGENT_INSTALLER=VrmAgentInstaller.msi
VCAC_WAPI_INSTALLER=vCAC-Wapi-Setup.exe

VCAC_CONFIG_TOOL='C:\Program Files (x86)\VMware\vCAC\Server\ConfigTool\vCAC-Config.exe'
VCAC_MODEL_MGR_CONFIG_TOOL='C:\Program Files (x86)\VMware\vCAC\Server\Model Manager Data\Cafe\Vcac-Config.exe'
VCAC_WAP_CONFIG_TOOL='C:\Program Files (x86)\VMware\vCAC\Web API\ConfigTool\Wapi-Config.exe'
VCAC_WEBSITE_MGR_LOG='C:\Program Files (x86)\VMware\vCAC\Server\Website\Logs'
VCAC_MANAGER_SERVICE_LOG='C:\Program Files (x86)\VMware\vCAC\Server\Logs'
VCAC_MODEL_MGR_LOG='C:\Program Files (x86)\VMware\vCAC\Server\Model Manager Web\Logs'
VCAC_CONFIG_TOOL_LOG='C:\Program Files (x86)\VMware\vCAC\Server\ConfigTool\Log\'
VCAC_DEM_INSTALL_PATH='C:\Program Files (x86)\VMware\vCAC\Distributed Execution Manager'
VCAC_DEM_ORCH_INSTALL_PATH='C:\Program Files (x86)\VMware\vCAC\Distributed Execution Manager'
VCAC_VSPHER_AGENT_INSTALL_PATH='C:\Program Files (x86)\VMware\vCAC\Agents'

TIMESTAMP=$(date +%Y%m%d%H%M%S)

createSQLServerConfig() {
  echo "Creating SQL Server unattended configuration file ${SQLSERVER_CONFIG_FILE} ..."
  cat > ${SQLSERVER_CONFIG_FILE} << __VCAC_SQL_SERVER_CONFIG_FILE__
[SQLSERVER2008]
INSTANCEID="${VCAC_DATABASE_INSTANCE_NAME}"
ACTION="Install"
FEATURES=SQLENGINE
HELP="False"
INDICATEPROGRESS="False"
QUIET="True"
QUIETSIMPLE="False"
X86="False"
ROLE="AllFeatures_WithDefaults"
ENU="True"
ERRORREPORTING="False"
SQMREPORTING="False"
INSTANCENAME="${VCAC_DATABASE_INSTANCE_NAME}"
AGTSVCACCOUNT="NT AUTHORITY\NETWORK SERVICE"
AGTSVCSTARTUPTYPE="Disabled"
ISSVCSTARTUPTYPE="Automatic"
ISSVCACCOUNT="NT AUTHORITY\NetworkService"
ASSVCSTARTUPTYPE="Automatic"
ASCOLLATION="Latin1_General_CI_AS"
ASDATADIR="Data"
ASLOGDIR="Log"
ASBACKUPDIR="Backup"
ASTEMPDIR="Temp"
ASCONFIGDIR="Config"
ASPROVIDERMSOLAP="1"
FARMADMINPORT="0"
SQLSVCSTARTUPTYPE="Automatic"
FILESTREAMLEVEL="0"
ENABLERANU="True"
SQLCOLLATION="SQL_Latin1_General_CP1_CI_AS"
SQLSVCACCOUNT="NT AUTHORITY\NETWORK SERVICE"
SQLSYSADMINACCOUNTS="${VCAC_SERVICE_USER}"
TCPENABLED="1"
NPENABLED="0"
BROWSERSVCSTARTUPTYPE="Disabled"
RSSVCACCOUNT="NT AUTHORITY\NETWORK SERVICE"
RSSVCSTARTUPTYPE="Automatic"
RSINSTALLMODE="FilesOnlyMode"
IACCEPTSQLSERVERLICENSETERMS="True"
__VCAC_SQL_SERVER_CONFIG_FILE__
}

createVCACConfigFile() {
  echo "Creating vCAC Server configuration file ${VCAC_SERVER_CONFIG} ..."
  cat > ${VCAC_SERVER_CONFIG} << __VCAC_CONFIG_FILE__
<?xml version="1.0" encoding="utf-8"?>
<vCACProperties>
  <componentRegistry>
    <TENANT>vsphere.local</TENANT>
    <COMPONENT_REGISTRY_CERTIFICATE_THUMBPRINT></COMPONENT_REGISTRY_CERTIFICATE_THUMBPRINT>
    <SSO_ADMIN_PASSWORD>${VCAC_SSO_PASSWORD}</SSO_ADMIN_PASSWORD>
    <SSO_ADMIN_USERNAME>administrator@vsphere.local</SSO_ADMIN_USERNAME>
    <COMPONENT_REGISTRY_SERVER>${VCAC_VA_HOSTNAME}</COMPONENT_REGISTRY_SERVER>
    <IAAS_SERVER_LOCALIP>${VCAC_IAAS_SHORT_HOSTNAME}</IAAS_SERVER_LOCALIP>
  </componentRegistry>
  <common>
    <DATABASE_INSTANCE>${VCAC_DATABASE_INSTANCE}</DATABASE_INSTANCE>
    <DATABASE_NAME>${VCAC_DATABASE_NAME}</DATABASE_NAME>
    <DATA_PROTECTED>FALSE</DATA_PROTECTED>
    <INSTALL_MODE>SilentInstall</INSTALL_MODE>
  </common>
  <webServiceCommon>
    <SECURITY_PASSPHRASE>${VCAC_SECURITY_PASSPHRASE}</SECURITY_PASSPHRASE>
    <WEBSITE_NAME>Default Web Site</WEBSITE_NAME>
    <CERTIFICATE></CERTIFICATE>
    <SUPPRESS_CERTIFICATE_MISMATCH_FLAG>false</SUPPRESS_CERTIFICATE_MISMATCH_FLAG>
    <HTTPS_PORT>443</HTTPS_PORT>
    <SERVICE_USER>${VCAC_SERVICE_USER}</SERVICE_USER>
    <SERVICE_USER_PASSWORD>${VCAC_SERVICE_PASSWORD}</SERVICE_USER_PASSWORD>
    <MODEL_MANAGER_WEB_HOSTNAME>${VCAC_IAAS_SHORT_HOSTNAME}</MODEL_MANAGER_WEB_HOSTNAME>
    <CREATE_MSSQL_AZMAN_STORE_FLAG>false</CREATE_MSSQL_AZMAN_STORE_FLAG>
    <AZMAN_STORE_TYPE>AUTHZ</AZMAN_STORE_TYPE>
    <AZMAN_CONNECTION_STRING>https://${VCAC_SSO_HOSTNAME}/</AZMAN_CONNECTION_STRING>
  </webServiceCommon>
  <database>
    <DATABASE_DATA_PATH />
    <DATABASE_LOG_PATH />
    <WINDOWS_AUTHEN_DATABASE_INSTALL_FLAG>true</WINDOWS_AUTHEN_DATABASE_INSTALL_FLAG>
    <DATABASE_INSTALL_SQL_USER></DATABASE_INSTALL_SQL_USER>
    <DATABASE_INSTALL_SQL_USER_PASSWORD></DATABASE_INSTALL_SQL_USER_PASSWORD>
    <PRECREATED_DATABASE_FLAG>false</PRECREATED_DATABASE_FLAG>
    <CREATE_MSSQL_AZMAN_STORE_FLAG>false</CREATE_MSSQL_AZMAN_STORE_FLAG>
  </database>
  <managerService>
    <MANAGER_SERVICE_HOSTNAME>${VCAC_IAAS_SHORT_HOSTNAME}</MANAGER_SERVICE_HOSTNAME>
    <MANAGER_SERVICE_LOG_PATH>${VCAC_MANAGER_SERVICE_LOG}</MANAGER_SERVICE_LOG_PATH>
    <MANAGER_SERVICE_SERVICESTART_FLAG>true</MANAGER_SERVICE_SERVICESTART_FLAG>
    <MANAGER_SERVICE_SERVICESTANDBY_FLAG>false</MANAGER_SERVICE_SERVICESTANDBY_FLAG>
  </managerService>
  <modelManagerWeb>
    <MODEL_MANAGER_WEB_LOG_PATH>${VCAC_MODEL_MGR_LOG}</MODEL_MANAGER_WEB_LOG_PATH>
  </modelManagerWeb>
  <modelManagerData>
    <MODEL_MANAGER_WEB_HOSTNAME>${VCAC_IAAS_SHORT_HOSTNAME}</MODEL_MANAGER_WEB_HOSTNAME>
    <HTTPS_PORT>443</HTTPS_PORT>
    <AZMAN_STORE_TYPE>AUTHZ</AZMAN_STORE_TYPE>
    <AZMAN_CONNECTION_STRING>https://${VCAC_VA_HOSTNAME}/</AZMAN_CONNECTION_STRING>
    <SMTP_ENABLE_SSL_FLAG>False</SMTP_ENABLE_SSL_FLAG>
    <SMTP_WEBSITE_CONSOLE_HOSTNAME>${VCAC_IAAS_SHORT_HOSTNAME}</SMTP_WEBSITE_CONSOLE_HOSTNAME>
    <SMTP_SERVER>${EMAIL_SERVER}</SMTP_SERVER>
    <SMTP_FROM_ADDRESS>${EMAIL_ADDRESS}</SMTP_FROM_ADDRESS>
    <SMTP_ANONYMOUS_AUTHEN_FLAG>True</SMTP_ANONYMOUS_AUTHEN_FLAG>
    <SMTP_USER />
    <SMTP_USER_PASSWORD />
  </modelManagerData>
  <website>
    <WEBSITE_LOG_PATH>${VCAC_WEBSITE_LOG_DIR}</WEBSITE_LOG_PATH>
    <WEBSITE_WEBFARM_FLAG>false</WEBSITE_WEBFARM_FLAG>
    <WEBSITE_SESSION_STATE_DATABASE_NAME>ASPState</WEBSITE_SESSION_STATE_DATABASE_NAME>
  </website>
</vCACProperties>
__VCAC_CONFIG_FILE__
}

createVCACWapiConfigFile() {
  echo "Creating WAPI configuration file ${VCAC_WAPI_CONFIG} ..."
  cat > ${VCAC_WAPI_CONFIG} << __WAPI_CONFIGURATION_FILE__
<?xml version="1.0" encoding="utf-8"?>
<vCACProperties>
  <website>
    <DATA_PROTECTED>FALSE</DATA_PROTECTED>
    <WEBSITE_NAME>Default Web Site</WEBSITE_NAME>
    <HTTPS_PORT>443</HTTPS_PORT>
    <CERTIFICATE></CERTIFICATE>
    <SUPPRESS_CERTIFICATE_MISMATCH_FLAG>FALSE</SUPPRESS_CERTIFICATE_MISMATCH_FLAG>
    <SERVICE_USER>${VCAC_SERVICE_USER}</SERVICE_USER>
    <SERVICE_USER_PASSWORD>${VCAC_SERVICE_PASSWORD}</SERVICE_USER_PASSWORD>
    <MODEL_MANAGER_WEB_HOSTNAME>${VCAC_IAAS_SHORT_HOSTNAME}</MODEL_MANAGER_WEB_HOSTNAME>
    <IAAS_SERVER_LOCALIP>${VCAC_IAAS_SHORT_HOSTNAME}</IAAS_SERVER_LOCALIP>
  </website>
</vCACProperties>
__WAPI_CONFIGURATION_FILE__
}

createVCACInstallerBatScript() {
  echo "Creating ${VCAC_INSTALLER_BAT_SCRIPT} ..."
  cat > ${VCAC_INSTALLER_BAT_SCRIPT} << __VCAC_IAAS_INSTALLER_SCRIPT__
:: William Lam
:: www.virtuallyghetto.com
:: Script to automate the installation of SQL Server 2008 & all VCAC IaaS components on a single machine completely automated & unattended

@ECHO off

set VCAC_IAAS_SHORT_HOSTNAME=${VCAC_IAAS_SHORT_HOSTNAME}
set VCAC_SERVICE_USER=${VCAC_SERVICE_USER}
set VCAC_SERVICE_PASSWORD=${VCAC_SERVICE_PASSWORD}

:: SQLSERVER INSTALL ::
set SQLSERVER_INSTALLER=${VCAC_HOME_DIRECTORY}\\${SQLSERVER_INSTALLER}
set SQLSERVER_CONFIG_FILE=${VCAC_HOME_DIRECTORY}\\${SQLSERVER_CONFIG_FILE}

:: VCAC CONFIG FILES ::
set VCAC_SERVER_CONFIG=${VCAC_HOME_DIRECTORY}\\${VCAC_SERVER_CONFIG}
set VCAC_WAPI_CONFIG=${VCAC_HOME_DIRECTORY}\\${VCAC_WAPI_CONFIG}

:: VCAC Installers downloaded from vCAC VA ::
set VCAC_INSTALLER=${VCAC_HOME_DIRECTORY}\\${VCAC_INSTALLER}
set VCAC_WORKFLOWMGR_INSTALLER=${VCAC_HOME_DIRECTORY}\\${VCAC_WORKFLOWMGR_INSTALLER}
set VCAC_VRMAGENT_INSTALLER=${VCAC_HOME_DIRECTORY}\\${VCAC_VRMAGENT_INSTALLER}
set VCAC_WAPI_INSTALLER=${VCAC_HOME_DIRECTORY}\\${VCAC_WAPI_INSTALLER}

set VCAC_CONFIG_TOOL=${VCAC_CONFIG_TOOL}
set VCAC_CONFIG_TOOL_LOG=${VCAC_CONFIG_TOOL_LOG}
set VCAC_CONFIG_TOOl_LOG_FILE=vCACConfiguration-${TIMESTAMP}.log

set VCAC_WAP_CONFIG_TOOL=${VCAC_WAP_CONFIG_TOOL}
set VCAC_MODEL_MGR_CONFIG_TOOL=${VCAC_MODEL_MGR_CONFIG_TOOL}

set VCAC_DEM_INSTALL_PATH=${VCAC_DEM_INSTALL_PATH}
set VCAC_DEM_LOG=DEM-Install.log

set VCAC_DEM_ORCH_INSTALL_PATH=${VCAC_DEM_ORCH_INSTALL_PATH}
set VCAC_DEM_ORCH_LOG=DEO-Install.log

set VCAC_VSPHER_AGENT_INSTALL_PATH=${VCAC_VSPHER_AGENT_INSTALL_PATH}
set VCAC_VSPHERE_AGENT_LOG=vSphereAgent-Install.log

echo.
echo Start Time:
date/t
time /t
echo.

echo Installing SQL Server 2008 R2 ...
"%SQLSERVER_INSTALLER%" /ConfigurationFile="%SQLSERVER_CONFIG_FILE%"
time /t
echo.

echo Deploying vCAC Core Server Components ...
"%VCAC_INSTALLER%" /s /w /V"/qn ADDLOCAL=Database,Website,ModelManagerWeb,ModelManagerData,ManagerService"
time /t
echo.

echo Configuring vCAC Core Server Components ...
"%VCAC_CONFIG_TOOL%" /S "/P:%VCAC_SERVER_CONFIG%" "/L:%VCAC_CONFIG_TOOL_LOG%%VCAC_CONFIG_TOOl_LOG_FILE%"
time /t
echo.

echo Installing vCAC DEM Service (Distributed Execution Manager) ...
msiexec.exe /i "%VCAC_WORKFLOWMGR_INSTALLER%" /qn /norestart /Lvoicewarmup! "%VCAC_DEM_LOG%" ADDLOCAL=All REPO_SERVER_URL="https://%VCAC_IAAS_SHORT_HOSTNAME%/repository/" REPO_HOSTNAME="%VCAC_IAAS_SHORT_HOSTNAME%" SERVICE_USER_NAME="%VCAC_SERVICE_USER%" SERVICE_USER_PASSWORD="%VCAC_SERVICE_PASSWORD%" REPOSITORY_USER="%VCAC_SERVICE_USER%" REPOSITORY_USER_PASSWORD="%VCAC_SERVICE_PASSWORD%" DEM_NAME="DEM" DEM_NAME_DESCRIPTION="DEM Worker" INSTALLLOCATION="%VCAC_DEM_INSTALL_PATH%" VALID_DEM_NAME="1" MSINEWINSTANCE="1" TRANSFORMS=":DemInstanceId01" DEM_ROLE="Worker" HTTPS_SUPPORT=1 ENABLE_SSL=true  MANAGERSERVICE_HOSTNAME="%VCAC_IAAS_SHORT_HOSTNAME%"
time /t
echo.

echo Installing vCAC DEO Service (Distributed Execution Orchestrator) ...
msiexec.exe /i "%VCAC_WORKFLOWMGR_INSTALLER%" /qn /norestart /Lvoicewarmup! "%VCAC_DEM_ORCH_LOG%" ADDLOCAL=All REPO_SERVER_URL="https://%VCAC_IAAS_SHORT_HOSTNAME%/repository/" REPO_HOSTNAME="%VCAC_IAAS_SHORT_HOSTNAME%" SERVICE_USER_NAME="%VCAC_SERVICE_USER%" SERVICE_USER_PASSWORD="%VCAC_SERVICE_PASSWORD%" REPOSITORY_USER="%VCAC_SERVICE_USER%" REPOSITORY_USER_PASSWORD="%VCAC_SERVICE_PASSWORD%" DEM_NAME="DEO" DEM_NAME_DESCRIPTION="DEM Orchestrator" INSTALLLOCATION="%VCAC_DEM_ORCH_INSTALL_PATH%" VALID_DEM_NAME="1" MSINEWINSTANCE="1" TRANSFORMS=":DemInstanceId02" DEM_ROLE="Orchestrator" HTTPS_SUPPORT=1 ENABLE_SSL=true  MANAGERSERVICE_HOSTNAME="%VCAC_IAAS_SHORT_HOSTNAME%"
time /t
echo.

echo Installing vCAC vSphere Agent Service ...
msiexec.exe /i "%VCAC_VRMAGENT_INSTALLER%" /qn /norestart /Lvoicewarmup! "%VCAC_VSPHERE_AGENT_LOG%" ADDLOCAL="vSphereAgent,CoreAgent" AGENT_TYPE="vSphere" AGENT_NAME="vSphereAgent" VSPHERE_AGENT_ENDPOINT="vCenter" REPOSITORY_HOSTNAME="%VCAC_IAAS_SHORT_HOSTNAME%" VRM_SERVER_NAME="%VCAC_IAAS_SHORT_HOSTNAME%" SERVICE_USER_NAME="%VCAC_SERVICE_USER%" SERVICE_USER_PASSWORD="%VCAC_SERVICE_PASSWORD%" INSTALLLOCATION="%VCAC_VSPHER_AGENT_INSTALL_PATH%" HTTPS_SUPPORT=1 MSINEWINSTANCE=1 TRANSFORMS=":VrmAgentInstanceId01"
time /t
echo.

echo Installing WAPI Service ...
"%VCAC_WAPI_INSTALLER%" /s /w /V"/qn ADDLOCAL=All"
time /t
echo.

echo Configuring WAPI Service ...
"%VCAC_WAP_CONFIG_TOOL%" /S "/P:%VCAC_WAPI_CONFIG%"
time /t
echo.

echo Register Catalog Types ...
"%VCAC_MODEL_MGR_CONFIG_TOOL%" RegisterCatalogTypes -v
time /t
echo.

echo.
echo End Time:
date/t
time /t
echo.
__VCAC_IAAS_INSTALLER_SCRIPT__
}

createSQLServerConfig
createVCACConfigFile
createVCACWapiConfigFile
createVCACInstallerBatScript
